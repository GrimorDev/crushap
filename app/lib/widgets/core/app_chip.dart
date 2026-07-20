import 'package:flutter/widgets.dart';
import '../../theme/colors.dart';
import '../../theme/effects.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

/// Ported from components/core/Chip.jsx.
class CrushapChip extends StatelessWidget {
  const CrushapChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: CrushapEffects.durFast,
        curve: CrushapEffects.easeStandard,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: selected ? CrushapColors.gradientPrimary : null,
          color: selected ? null : CrushapColors.surfaceCard,
          borderRadius: BorderRadius.circular(CrushapRadii.pill),
          border: Border.all(
            color: selected ? const Color(0x00000000) : CrushapColors.borderSubtle,
          ),
          boxShadow: selected ? CrushapEffects.shadowGlowPrimary : null,
        ),
        child: Text(
          label,
          style: CrushapText.bodySm.copyWith(
            color: selected ? CrushapColors.textPrimary : CrushapColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
