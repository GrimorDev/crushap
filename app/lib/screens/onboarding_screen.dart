import 'package:flutter/widgets.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../widgets/core/app_button.dart';
import '../widgets/core/app_chip.dart';
import '../widgets/forms/app_input.dart';

const _allInterests = [
  'Hiking', 'Coffee', 'Live music', 'Foodie', 'Dogs', 'Travel', 'Yoga', 'Gaming',
];

/// Ported from ui_kits/dating-app/Onboarding.jsx — welcome -> name -> interests.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;
  final _nameController = TextEditingController();
  final Set<String> _interests = {};

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _toggleInterest(String t) {
    setState(() => _interests.contains(t) ? _interests.remove(t) : _interests.add(t));
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: CrushapColors.surfaceApp,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: switch (_step) {
            0 => _WelcomeStep(onGetStarted: () => setState(() => _step = 1)),
            1 => _NameStep(
                controller: _nameController,
                onContinue: () => setState(() => _step = 2),
              ),
            _ => _InterestsStep(
                selected: _interests,
                onToggle: _toggleInterest,
                onStartSwiping: widget.onDone,
              ),
          },
        ),
      ),
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep({required this.onGetStarted});

  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
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
                  'Find your spark tonight. No games, just genuine matches.',
                  style: CrushapText.bodyLg.copyWith(color: CrushapColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
        CrushapButton(label: 'Get Started', size: CrushapButtonSize.lg, expand: true, onPressed: onGetStarted),
        const SizedBox(height: 20),
        CrushapButton(
          label: 'I already have an account',
          variant: CrushapButtonVariant.ghost,
          expand: true,
          onPressed: () {},
        ),
      ],
    );
  }
}

class _NameStep extends StatelessWidget {
  const _NameStep({required this.controller, required this.onContinue});

  final TextEditingController controller;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("What's your name?", style: CrushapText.title),
                const SizedBox(height: 16),
                CrushapInput(placeholder: 'First name', controller: controller),
              ],
            ),
          ),
        ),
        ListenableBuilder(
          listenable: controller,
          builder: (context, _) => CrushapButton(
            label: 'Continue',
            size: CrushapButtonSize.lg,
            expand: true,
            onPressed: controller.text.trim().isEmpty ? null : onContinue,
          ),
        ),
      ],
    );
  }
}

class _InterestsStep extends StatelessWidget {
  const _InterestsStep({
    required this.selected,
    required this.onToggle,
    required this.onStartSwiping,
  });

  final Set<String> selected;
  final ValueChanged<String> onToggle;
  final VoidCallback onStartSwiping;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Pick a few interests', style: CrushapText.title),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final t in _allInterests)
                      CrushapChip(label: t, selected: selected.contains(t), onTap: () => onToggle(t)),
                  ],
                ),
              ],
            ),
          ),
        ),
        CrushapButton(
          label: 'Start swiping',
          size: CrushapButtonSize.lg,
          expand: true,
          onPressed: selected.isEmpty ? null : onStartSwiping,
        ),
      ],
    );
  }
}
