import 'dart:async';
import 'dart:typed_data';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/widgets.dart';
import '../constants.dart';
import '../l10n/gen/app_localizations.dart';
import '../services/api_client.dart';
import '../services/location_service.dart';
import '../services/session.dart';
import '../theme/colors.dart';
import '../theme/effects.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';
import '../widgets/core/app_button.dart';
import '../widgets/core/app_chip.dart';
import '../widgets/core/app_icon.dart';
import '../widgets/core/photo_source_sheet.dart';
import '../widgets/forms/app_input.dart';

/// Ported from ui_kits/dating-app/Onboarding.jsx — welcome -> name ->
/// interests — extended into a full registration flow (email/password,
/// age, an optional photo) now that there's a real backend to register
/// against.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    required this.session,
    required this.onDone,
    required this.onLogin,
  });

  final Session session;
  final VoidCallback onDone;
  final VoidCallback onLogin;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
  String? _gender;
  String? _lookingFor;
  final Set<String> _interests = {};
  Uint8List? _photoBytes;
  String? _photoName;
  Position? _position;
  bool _locating = false;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _toggleInterest(String t) {
    setState(() => _interests.contains(t) ? _interests.remove(t) : _interests.add(t));
  }

  Future<void> _pickPhoto() async {
    final source = await showPhotoSourceSheet(context);
    if (source == null) return;
    final file = await ImagePicker().pickImage(source: source, maxWidth: 1600, imageQuality: 85);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    setState(() {
      _photoBytes = bytes;
      _photoName = file.name;
    });
  }

  Future<void> _shareLocation() async {
    setState(() => _locating = true);
    final position = await LocationService.getCurrentPosition();
    if (mounted) {
      setState(() {
        _position = position;
        _locating = false;
      });
    }
  }

  Future<void> _submit() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    final api = ApiClient(widget.session);
    try {
      final (token, me) = await api.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        age: int.parse(_ageController.text.trim()),
        tags: _interests.toList(),
        gender: _gender,
        lookingFor: _lookingFor,
      );
      await widget.session.setAuth(token: token, userId: me.id);
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _step = 2; // back to the credentials step, where this is most likely to matter
          _error = e.message;
          _submitting = false;
        });
      }
      return;
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = AppLocalizations.of(context)!.genericNetworkError;
          _submitting = false;
        });
      }
      return;
    }

    // The account now exists and is signed in — the photo and location are
    // both nice-to-haves from here on, so neither failing may strand the
    // user back on the credentials step (retrying registration there would
    // just fail with "email already exists", since the account already
    // exists above).
    final bytes = _photoBytes;
    if (bytes != null) {
      try {
        await api.uploadPhoto(bytes, _photoName ?? 'photo.jpg');
      } catch (_) {
        // Ignore — the user can add a photo later from the profile screen.
      }
    }
    final position = _position;
    if (position != null) {
      try {
        await api.updateLocation(lat: position.latitude, lng: position.longitude);
      } catch (_) {
        // Ignore — distance/filtering just stays unavailable until they
        // share it later (e.g. from Filters).
      }
    }
    if (mounted) widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: CrushapColors.surfaceApp,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: switch (_step) {
            0 => _WelcomeStep(onGetStarted: () => setState(() => _step = 1), onLogin: widget.onLogin),
            1 => _NameStep(
                controller: _nameController,
                onBack: () => setState(() => _step = 0),
                onContinue: () => setState(() => _step = 2),
              ),
            2 => _CredentialsStep(
                emailController: _emailController,
                passwordController: _passwordController,
                error: _error,
                onBack: () => setState(() {
                  _error = null;
                  _step = 1;
                }),
                onContinue: () => setState(() {
                  _error = null;
                  _step = 3;
                }),
              ),
            3 => _AgeStep(
                controller: _ageController,
                onBack: () => setState(() => _step = 2),
                onContinue: () => setState(() => _step = 4),
              ),
            4 => _GenderStep(
                selected: _gender,
                onSelect: (g) => setState(() => _gender = g),
                onBack: () => setState(() => _step = 3),
                onContinue: () => setState(() => _step = 5),
              ),
            5 => _LookingForStep(
                selected: _lookingFor,
                onSelect: (v) => setState(() => _lookingFor = v),
                onBack: () => setState(() => _step = 4),
                onContinue: () => setState(() => _step = 6),
              ),
            6 => _InterestsStep(
                selected: _interests,
                onToggle: _toggleInterest,
                onBack: () => setState(() => _step = 5),
                onContinue: () => setState(() => _step = 7),
              ),
            7 => _PhotoStep(
                photoBytes: _photoBytes,
                onPick: _pickPhoto,
                onBack: () => setState(() => _step = 6),
                onContinue: () => setState(() => _step = 8),
              ),
            _ => _LocationStep(
                shared: _position != null,
                locating: _locating,
                busy: _submitting,
                onShare: _shareLocation,
                onBack: () => setState(() => _step = 7),
                onFinish: _submit,
              ),
          },
        ),
      ),
    );
  }
}

class _BackRow extends StatelessWidget {
  const _BackRow({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: CrushapButton(
        label: AppLocalizations.of(context)!.backWithArrow,
        icon: const CrushapIcon('arrow-left', size: 16),
        variant: CrushapButtonVariant.ghost,
        onPressed: onBack,
      ),
    );
  }
}

class _WelcomeSlideData {
  const _WelcomeSlideData({required this.icon, required this.title, required this.body});
  final String icon;
  final String title;
  final String body;
}

/// An animated multi-slide intro (auto-advancing PageView + a pulsing
/// glow behind each slide's icon) in place of a single static screen —
/// the first thing a new user sees, so it carries the "premium" first
/// impression the rest of the design system goes for.
class _WelcomeStep extends StatefulWidget {
  const _WelcomeStep({required this.onGetStarted, required this.onLogin});

  final VoidCallback onGetStarted;
  final VoidCallback onLogin;

  @override
  State<_WelcomeStep> createState() => _WelcomeStepState();
}

class _WelcomeStepState extends State<_WelcomeStep> {
  final _pageController = PageController();
  Timer? _autoAdvance;
  int _page = 0;

  void _scheduleAutoAdvance(int slideCount) {
    _autoAdvance?.cancel();
    _autoAdvance = Timer(const Duration(seconds: 4), () {
      if (!mounted || !_pageController.hasClients) return;
      _pageController.animateToPage(
        (_page + 1) % slideCount,
        duration: CrushapEffects.durSlow,
        curve: CrushapEffects.easeStandard,
      );
    });
  }

  @override
  void dispose() {
    _autoAdvance?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final slides = [
      _WelcomeSlideData(icon: 'flame', title: 'crushap', body: t.onboardingHeadline),
      _WelcomeSlideData(icon: 'heart', title: t.onboardingSlide2Title, body: t.onboardingSlide2Body),
      _WelcomeSlideData(icon: 'message-circle', title: t.onboardingSlide3Title, body: t.onboardingSlide3Body),
    ];
    _scheduleAutoAdvance(slides.length);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _page = i),
            children: [for (final s in slides) _WelcomeSlide(data: s)],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final (i, _) in slides.indexed) ...[
              if (i > 0) const SizedBox(width: 6),
              AnimatedContainer(
                duration: CrushapEffects.durNormal,
                curve: CrushapEffects.easeStandard,
                width: i == _page ? 22 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: i == _page ? CrushapColors.accentPrimary : CrushapColors.borderStrong,
                  borderRadius: BorderRadius.circular(CrushapRadii.pill),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 28),
        CrushapButton(label: t.getStarted, size: CrushapButtonSize.lg, expand: true, onPressed: widget.onGetStarted),
        const SizedBox(height: 20),
        CrushapButton(
          label: t.alreadyHaveAccount,
          variant: CrushapButtonVariant.ghost,
          expand: true,
          onPressed: widget.onLogin,
        ),
      ],
    );
  }
}

class _WelcomeSlide extends StatefulWidget {
  const _WelcomeSlide({required this.data});
  final _WelcomeSlideData data;

  @override
  State<_WelcomeSlide> createState() => _WelcomeSlideState();
}

class _WelcomeSlideState extends State<_WelcomeSlide> with SingleTickerProviderStateMixin {
  late final _pulse = AnimationController(vsync: this, duration: const Duration(seconds: 2))
    ..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedBuilder(
          animation: _pulse,
          builder: (context, child) {
            final t = Curves.easeInOut.transform(_pulse.value);
            return Transform.scale(
              scale: 1 + t * 0.06,
              child: Container(
                width: 96,
                height: 96,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: CrushapColors.gradientPrimary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: CrushapColors.accentGlow, blurRadius: 24 + t * 24, spreadRadius: t * 4),
                  ],
                ),
                child: child,
              ),
            );
          },
          child: CrushapIcon(widget.data.icon, size: 40, color: CrushapColors.textPrimary),
        ),
        const SizedBox(height: 28),
        Text(widget.data.title, style: CrushapText.displayXl),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Text(
            widget.data.body,
            style: CrushapText.bodyLg.copyWith(color: CrushapColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _NameStep extends StatelessWidget {
  const _NameStep({required this.controller, required this.onBack, required this.onContinue});

  final TextEditingController controller;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BackRow(onBack: onBack),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(t.nameStepTitle, style: CrushapText.title),
                const SizedBox(height: 16),
                CrushapInput(placeholder: t.firstNamePlaceholder, controller: controller),
              ],
            ),
          ),
        ),
        ListenableBuilder(
          listenable: controller,
          builder: (context, _) => CrushapButton(
            label: t.continueLabel,
            size: CrushapButtonSize.lg,
            expand: true,
            onPressed: controller.text.trim().isEmpty ? null : onContinue,
          ),
        ),
      ],
    );
  }
}

class _CredentialsStep extends StatelessWidget {
  const _CredentialsStep({
    required this.emailController,
    required this.passwordController,
    required this.error,
    required this.onBack,
    required this.onContinue,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? error;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BackRow(onBack: onBack),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(t.credentialsStepTitle, style: CrushapText.title),
                const SizedBox(height: 16),
                CrushapInput(placeholder: t.emailPlaceholder, controller: emailController, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 12),
                CrushapInput(placeholder: t.passwordMinPlaceholder, controller: passwordController, obscureText: true),
                if (error != null) ...[
                  const SizedBox(height: 10),
                  Text(error!, style: CrushapText.bodySm.copyWith(color: CrushapColors.actionPass)),
                ],
              ],
            ),
          ),
        ),
        ListenableBuilder(
          listenable: Listenable.merge([emailController, passwordController]),
          builder: (context, _) => CrushapButton(
            label: t.continueLabel,
            size: CrushapButtonSize.lg,
            expand: true,
            onPressed: emailController.text.trim().contains('@') && passwordController.text.length >= 6
                ? onContinue
                : null,
          ),
        ),
      ],
    );
  }
}

class _AgeStep extends StatelessWidget {
  const _AgeStep({required this.controller, required this.onBack, required this.onContinue});

  final TextEditingController controller;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BackRow(onBack: onBack),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(t.ageStepTitle, style: CrushapText.title),
                const SizedBox(height: 16),
                CrushapInput(placeholder: t.agePlaceholder, controller: controller, keyboardType: TextInputType.number),
              ],
            ),
          ),
        ),
        ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final age = int.tryParse(controller.text.trim());
            return CrushapButton(
              label: t.continueLabel,
              size: CrushapButtonSize.lg,
              expand: true,
              onPressed: (age != null && age >= 18 && age <= 100) ? onContinue : null,
            );
          },
        ),
      ],
    );
  }
}

class _GenderStep extends StatelessWidget {
  const _GenderStep({
    required this.selected,
    required this.onSelect,
    required this.onBack,
    required this.onContinue,
  });

  final String? selected;
  final ValueChanged<String> onSelect;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final options = [
      ('woman', t.genderIdentityWoman),
      ('man', t.genderIdentityMan),
      ('nonbinary', t.genderIdentityNonBinary),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BackRow(onBack: onBack),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(t.genderStepTitle, style: CrushapText.title),
                const SizedBox(height: 16),
                for (final (value, label) in options) ...[
                  _SelectableOption(label: label, selected: selected == value, onTap: () => onSelect(value)),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ),
        CrushapButton(
          label: t.continueLabel,
          size: CrushapButtonSize.lg,
          expand: true,
          onPressed: selected == null ? null : onContinue,
        ),
      ],
    );
  }
}

class _LookingForStep extends StatelessWidget {
  const _LookingForStep({
    required this.selected,
    required this.onSelect,
    required this.onBack,
    required this.onContinue,
  });

  final String? selected;
  final ValueChanged<String> onSelect;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final options = [
      ('relationship', t.lookingForRelationship),
      ('casual', t.lookingForCasual),
      ('friends', t.lookingForFriends),
      ('unsure', t.lookingForUnsure),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BackRow(onBack: onBack),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(t.lookingForStepTitle, style: CrushapText.title),
                const SizedBox(height: 16),
                for (final (value, label) in options) ...[
                  _SelectableOption(label: label, selected: selected == value, onTap: () => onSelect(value)),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ),
        CrushapButton(
          label: t.continueLabel,
          size: CrushapButtonSize.lg,
          expand: true,
          onPressed: selected == null ? null : onContinue,
        ),
      ],
    );
  }
}

class _SelectableOption extends StatelessWidget {
  const _SelectableOption({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: CrushapEffects.durFast,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? CrushapColors.accentGlow : CrushapColors.surfaceElevated,
          borderRadius: BorderRadius.circular(CrushapRadii.lg),
          border: Border.all(color: selected ? CrushapColors.accentPrimary : CrushapColors.borderSubtle),
        ),
        child: Row(
          children: [
            Expanded(child: Text(label, style: CrushapText.body)),
            if (selected) const CrushapIcon('check', size: 18, color: CrushapColors.accentPrimary),
          ],
        ),
      ),
    );
  }
}

class _InterestsStep extends StatelessWidget {
  const _InterestsStep({
    required this.selected,
    required this.onToggle,
    required this.onBack,
    required this.onContinue,
  });

  final Set<String> selected;
  final ValueChanged<String> onToggle;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BackRow(onBack: onBack),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(t.interestsStepTitle, style: CrushapText.title),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    // Interest values stay in English as canonical data (they're
                    // also used for tag matching in search) — only the chrome
                    // around them is localized. See DEPLOYMENT.md/README for
                    // this trade-off if it ever needs revisiting.
                    for (final tag in kInterestOptions)
                      CrushapChip(label: tag, selected: selected.contains(tag), onTap: () => onToggle(tag)),
                  ],
                ),
              ],
            ),
          ),
        ),
        CrushapButton(
          label: t.continueLabel,
          size: CrushapButtonSize.lg,
          expand: true,
          onPressed: selected.isEmpty ? null : onContinue,
        ),
      ],
    );
  }
}

class _PhotoStep extends StatelessWidget {
  const _PhotoStep({
    required this.photoBytes,
    required this.onPick,
    required this.onBack,
    required this.onContinue,
  });

  final Uint8List? photoBytes;
  final VoidCallback onPick;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final bytes = photoBytes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BackRow(onBack: onBack),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(t.photoStepTitle, style: CrushapText.title),
              const SizedBox(height: 8),
              Text(
                t.photoStepSubtitle,
                textAlign: TextAlign.center,
                style: CrushapText.bodySm.copyWith(color: CrushapColors.textSecondary),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: onPick,
                child: Container(
                  width: 140,
                  height: 140,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CrushapColors.surfaceCard,
                    border: Border.all(color: CrushapColors.borderSubtle),
                    image: bytes == null ? null : DecorationImage(image: MemoryImage(bytes), fit: BoxFit.cover),
                  ),
                  child: bytes == null
                      ? const CrushapIcon('camera', size: 32, color: CrushapColors.textTertiary)
                      : null,
                ),
              ),
            ],
          ),
        ),
        CrushapButton(
          label: bytes == null ? t.skipForNow : t.continueLabel,
          variant: bytes == null ? CrushapButtonVariant.ghost : CrushapButtonVariant.primary,
          size: CrushapButtonSize.lg,
          expand: true,
          onPressed: onContinue,
        ),
      ],
    );
  }
}

class _LocationStep extends StatelessWidget {
  const _LocationStep({
    required this.shared,
    required this.locating,
    required this.busy,
    required this.onShare,
    required this.onBack,
    required this.onFinish,
  });

  final bool shared;
  final bool locating;
  final bool busy;
  final VoidCallback onShare;
  final VoidCallback onBack;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BackRow(onBack: onBack),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: shared ? CrushapColors.accentGlow : CrushapColors.surfaceCard,
                  border: Border.all(color: shared ? CrushapColors.accentPrimary : CrushapColors.borderSubtle),
                ),
                child: CrushapIcon(
                  'map-pin',
                  size: 32,
                  color: shared ? CrushapColors.accentPrimary : CrushapColors.textTertiary,
                ),
              ),
              const SizedBox(height: 24),
              Text(t.locationStepTitle, style: CrushapText.title, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                shared ? t.locationSharedConfirmation : t.locationStepSubtitle,
                textAlign: TextAlign.center,
                style: CrushapText.bodySm.copyWith(color: CrushapColors.textSecondary),
              ),
            ],
          ),
        ),
        if (!shared) ...[
          CrushapButton(
            label: locating ? t.locatingLabel : t.shareMyLocation,
            size: CrushapButtonSize.lg,
            expand: true,
            onPressed: locating ? null : onShare,
          ),
          const SizedBox(height: 12),
        ],
        CrushapButton(
          label: busy ? t.settingUpAccount : (shared ? t.startSwiping : t.skipForNow),
          variant: shared ? CrushapButtonVariant.primary : CrushapButtonVariant.ghost,
          size: CrushapButtonSize.lg,
          expand: true,
          onPressed: busy || locating ? null : onFinish,
        ),
      ],
    );
  }
}
