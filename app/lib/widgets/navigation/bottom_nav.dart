import 'dart:ui';
import 'package:flutter/widgets.dart';
import '../../theme/colors.dart';
import '../../theme/effects.dart';
import '../../theme/typography.dart';
import '../core/app_icon.dart';

enum CrushapNavTab { discover, search, matches, chat, profile }

const _tabs = [
  (tab: CrushapNavTab.discover, icon: 'flame', label: 'Discover'),
  (tab: CrushapNavTab.search, icon: 'search', label: 'Search'),
  (tab: CrushapNavTab.matches, icon: 'heart', label: 'Matches'),
  (tab: CrushapNavTab.chat, icon: 'message-circle', label: 'Chat'),
  (tab: CrushapNavTab.profile, icon: 'user', label: 'Profile'),
];

/// Ported from components/navigation/BottomNav.jsx.
class CrushapBottomNav extends StatelessWidget {
  const CrushapBottomNav({super.key, required this.active, this.onChanged});

  final CrushapNavTab active;
  final ValueChanged<CrushapNavTab>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: CrushapEffects.blurGlassSigma,
          sigmaY: CrushapEffects.blurGlassSigma,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 14, 8, 14),
          decoration: const BoxDecoration(
            color: Color(0xB8130D17), // rgba(19,13,23,.72)
            border: Border(top: BorderSide(color: CrushapColors.borderSubtle)),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (final t in _tabs) _NavItem(entry: t, active: active == t.tab, onChanged: onChanged),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.entry, required this.active, this.onChanged});

  final ({CrushapNavTab tab, String icon, String label}) entry;
  final bool active;
  final ValueChanged<CrushapNavTab>? onChanged;

  @override
  Widget build(BuildContext context) {
    final color = active ? CrushapColors.accentPrimary : CrushapColors.textTertiary;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onChanged == null ? null : () => onChanged!(entry.tab),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 44),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CrushapIcon(entry.icon, size: 22, color: color),
            const SizedBox(height: 4),
            Text(entry.label, style: CrushapText.caption.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
