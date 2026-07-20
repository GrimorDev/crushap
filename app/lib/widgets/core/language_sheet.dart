import 'package:flutter/widgets.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/colors.dart';
import '../../theme/effects.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import 'app_icon.dart';

/// null means "follow the device language" (the same meaning as
/// Session.localeOverride).
class LanguageChoice {
  const LanguageChoice(this.locale);
  final Locale? locale;
}

/// Same visual pattern as photo_source_sheet.dart's picker.
Future<LanguageChoice?> showLanguageSheet(BuildContext context, Locale? current) {
  return showGeneralDialog<LanguageChoice>(
    context: context,
    barrierLabel: 'Choose language',
    barrierDismissible: true,
    barrierColor: CrushapColors.overlayScrim,
    transitionDuration: CrushapEffects.durNormal,
    pageBuilder: (context, animation, secondaryAnimation) => const SizedBox.shrink(),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: CrushapEffects.easeStandard);
      return Align(
        alignment: Alignment.bottomCenter,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(curved),
          child: _LanguageSheet(current: current),
        ),
      );
    },
  );
}

class _LanguageSheet extends StatelessWidget {
  const _LanguageSheet({required this.current});
  final Locale? current;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: CrushapColors.surfaceElevated,
          borderRadius: BorderRadius.circular(CrushapRadii.lg),
          border: Border.all(color: CrushapColors.borderSubtle),
          boxShadow: CrushapEffects.shadowModal,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Option(
              label: t.languageSystem,
              selected: current == null,
              onTap: () => Navigator.of(context).pop(const LanguageChoice(null)),
            ),
            const _Divider(),
            _Option(
              label: t.languageEnglish,
              selected: current?.languageCode == 'en',
              onTap: () => Navigator.of(context).pop(const LanguageChoice(Locale('en'))),
            ),
            const _Divider(),
            _Option(
              label: t.languagePolish,
              selected: current?.languageCode == 'pl',
              onTap: () => Navigator.of(context).pop(const LanguageChoice(Locale('pl'))),
            ),
          ],
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 1, child: ColoredBox(color: CrushapColors.borderSubtle));
  }
}
