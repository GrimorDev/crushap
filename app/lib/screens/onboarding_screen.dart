import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/widgets.dart';
import '../constants.dart';
import '../l10n/gen/app_localizations.dart';
import '../services/api_client.dart';
import '../services/session.dart';
import '../theme/colors.dart';
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
  final Set<String> _interests = {};
  Uint8List? _photoBytes;
  String? _photoName;
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
      );
      await widget.session.setAuth(token: token, userId: me.id);
      final bytes = _photoBytes;
      if (bytes != null) {
        await api.uploadPhoto(bytes, _photoName ?? 'photo.jpg');
      }
      if (mounted) widget.onDone();
    } on ApiException catch (e) {
      setState(() {
        _step = 2; // back to the credentials step, where this is most likely to matter
        _error = e.message;
      });
    } catch (_) {
      if (mounted) setState(() => _error = AppLocalizations.of(context)!.genericNetworkError);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
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
            4 => _InterestsStep(
                selected: _interests,
                onToggle: _toggleInterest,
                onBack: () => setState(() => _step = 3),
                onContinue: () => setState(() => _step = 5),
              ),
            _ => _PhotoStep(
                photoBytes: _photoBytes,
                busy: _submitting,
                onPick: _pickPhoto,
                onBack: () => setState(() => _step = 4),
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
        variant: CrushapButtonVariant.ghost,
        onPressed: onBack,
      ),
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep({required this.onGetStarted, required this.onLogin});

  final VoidCallback onGetStarted;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('crushap', style: CrushapText.displayXl),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: Text(
                  t.onboardingHeadline,
                  style: CrushapText.bodyLg.copyWith(color: CrushapColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
        CrushapButton(label: t.getStarted, size: CrushapButtonSize.lg, expand: true, onPressed: onGetStarted),
        const SizedBox(height: 20),
        CrushapButton(
          label: t.alreadyHaveAccount,
          variant: CrushapButtonVariant.ghost,
          expand: true,
          onPressed: onLogin,
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
    required this.busy,
    required this.onPick,
    required this.onBack,
    required this.onFinish,
  });

  final Uint8List? photoBytes;
  final bool busy;
  final VoidCallback onPick;
  final VoidCallback onBack;
  final VoidCallback onFinish;

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
          label: busy ? t.settingUpAccount : (bytes == null ? t.skipForNow : t.startSwiping),
          variant: bytes == null ? CrushapButtonVariant.ghost : CrushapButtonVariant.primary,
          size: CrushapButtonSize.lg,
          expand: true,
          onPressed: busy ? null : onFinish,
        ),
      ],
    );
  }
}
