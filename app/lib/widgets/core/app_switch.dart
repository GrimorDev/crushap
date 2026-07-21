import 'package:flutter/widgets.dart';
import '../../theme/colors.dart';
import '../../theme/effects.dart';
import '../../theme/spacing.dart';

/// Shared toggle switch, factored out of filters_screen.dart's private
/// _CrushapSwitch so Notifications/Privacy settings can use the same look.
class CrushapSwitch extends StatelessWidget {
  const CrushapSwitch({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: CrushapEffects.durFast,
        width: 46,
        height: 28,
        padding: const EdgeInsets.all(2),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        decoration: BoxDecoration(
          gradient: value ? CrushapColors.gradientPrimary : null,
          color: value ? null : CrushapColors.surfaceCard,
          borderRadius: BorderRadius.circular(CrushapRadii.pill),
          border: Border.all(color: CrushapColors.borderSubtle),
        ),
        child: AnimatedContainer(
          duration: CrushapEffects.durFast,
          curve: CrushapEffects.easeSpring,
          width: 22,
          height: 22,
          decoration: const BoxDecoration(color: Color(0xFFFFFFFF), shape: BoxShape.circle),
        ),
      ),
    );
  }
}
