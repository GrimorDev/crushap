import 'package:flutter/widgets.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

enum CrushapBadgeVariant { neutral, verified, premium, accent }

/// Ported from components/core/Badge.jsx.
class CrushapBadge extends StatelessWidget {
  const CrushapBadge({
    super.key,
    required this.label,
    this.variant = CrushapBadgeVariant.neutral,
    this.icon,
  });

  final String label;
  final CrushapBadgeVariant variant;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    late final Color bg;
    late final Color fg;
    Border? border;
    Gradient? gradient;
    switch (variant) {
      case CrushapBadgeVariant.neutral:
        bg = CrushapColors.surfaceCard;
        fg = CrushapColors.textSecondary;
        border = Border.all(color: CrushapColors.borderSubtle);
      case CrushapBadgeVariant.verified:
        bg = const Color(0x243DDC84); // rgba(61,220,132,.14)
        fg = CrushapColors.green1;
        border = Border.all(color: const Color(0x4D3DDC84)); // .3
      case CrushapBadgeVariant.premium:
        bg = const Color(0x24FFC145); // rgba(255,193,69,.14)
        fg = CrushapColors.gold1;
        border = Border.all(color: const Color(0x4DFFC145));
      case CrushapBadgeVariant.accent:
        bg = const Color(0x00000000);
        fg = const Color(0xFFFFFFFF);
        gradient = CrushapColors.gradientPrimary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: gradient == null ? bg : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(CrushapRadii.pill),
        border: border,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            IconTheme(data: IconThemeData(color: fg), child: icon!),
            const SizedBox(width: 4),
          ],
          Text(
            label.toUpperCase(),
            style: CrushapText.caption.copyWith(color: fg, letterSpacing: CrushapText.trackingWide * 12),
          ),
        ],
      ),
    );
  }
}
