import 'package:flutter/widgets.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import 'app_icon.dart';
import 'app_icon_button.dart';
import 'app_switch.dart';

/// Shared "pushed settings sub-screen" chrome — back button + title bar,
/// used by Notifications/Privacy/Subscription so they read as one family
/// instead of each hand-rolling the header.
class SettingsScaffold extends StatelessWidget {
  const SettingsScaffold({
    super.key,
    required this.title,
    required this.backLabel,
    required this.onBack,
    required this.child,
  });

  final String title;
  final String backLabel;
  final VoidCallback onBack;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: CrushapColors.surfaceApp,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: CrushapColors.borderSubtle)),
              ),
              child: Row(
                children: [
                  CrushapIconButton(
                    icon: 'arrow-left',
                    label: backLabel,
                    variant: CrushapIconButtonVariant.ghost,
                    onPressed: onBack,
                  ),
                  const SizedBox(width: 12),
                  Text(title, style: CrushapText.title),
                ],
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

/// A labeled row with a switch — the notification/privacy toggle pattern.
class SettingsToggleRow extends StatelessWidget {
  const SettingsToggleRow({
    super.key,
    required this.icon,
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  final String icon;
  final String label;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: CrushapColors.surfaceCard,
              shape: BoxShape.circle,
              border: Border.all(color: CrushapColors.borderSubtle),
            ),
            child: CrushapIcon(icon, size: 18, color: CrushapColors.textSecondary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: CrushapText.body),
                const SizedBox(height: 4),
                Text(description, style: CrushapText.bodySm.copyWith(color: CrushapColors.textTertiary)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          CrushapSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
