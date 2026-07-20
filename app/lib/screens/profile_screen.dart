import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../widgets/core/app_badge.dart';
import '../widgets/core/app_chip.dart';
import '../widgets/core/app_icon.dart';
import '../widgets/core/app_icon_button.dart';
import '../widgets/navigation/bottom_nav.dart';

const _interests = ['Hiking', 'Coffee', 'Dogs', 'Travel'];
const _settingsRows = ['Edit profile', 'Notifications', 'Privacy & safety', 'Subscription'];

/// Ported from ui_kits/dating-app/ProfileScreen.jsx.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.activeTab, required this.onTabChanged});

  final CrushapNavTab activeTab;
  final ValueChanged<CrushapNavTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: CrushapColors.surfaceApp,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 112,
                          height: 112,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: CrushapColors.surfaceCard,
                            border: Border.all(color: CrushapColors.borderSubtle),
                          ),
                          child: CrushapIcon('image', size: 32, color: CrushapColors.textTertiary),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('You, 28', style: CrushapText.displayMd),
                            const SizedBox(width: 8),
                            const CrushapBadge(
                              label: 'Verified',
                              variant: CrushapBadgeVariant.verified,
                              icon: CrushapIcon('shield-check', size: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const CrushapIconButton(
                          icon: 'camera',
                          label: 'Edit photo',
                          variant: CrushapIconButtonVariant.surface,
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    _SectionLabel('About'),
                    const SizedBox(height: 10),
                    Text(
                      'Coffee snob, weekend hiker, professional dog-petter. '
                      'Looking for someone to explore new trails with.',
                      style: CrushapText.body.copyWith(color: CrushapColors.textSecondary),
                    ),
                    const SizedBox(height: 24),
                    _SectionLabel('Interests'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [for (final t in _interests) CrushapChip(label: t, selected: true)],
                    ),
                    const SizedBox(height: 24),
                    for (final t in _settingsRows) _SettingsRow(label: t, isLast: t == _settingsRows.last),
                  ],
                ),
              ),
            ),
            CrushapBottomNav(active: activeTab, onChanged: onTabChanged),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: CrushapText.bodySm.copyWith(
        color: CrushapColors.textTertiary,
        letterSpacing: CrushapText.trackingWide * 14,
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.label, required this.isLast});
  final String label;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: CrushapColors.borderSubtle)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: CrushapText.body),
          Transform.rotate(
            angle: math.pi,
            child: const CrushapIcon('chevron-left', size: 16, color: CrushapColors.textTertiary),
          ),
        ],
      ),
    );
  }
}
