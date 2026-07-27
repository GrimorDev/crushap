import 'package:flutter/widgets.dart';
import '../../theme/colors.dart';

/// The concentric-ring + floating-dot motif from the Destined reference —
/// used as a decorative backdrop behind hero moments (match celebration,
/// onboarding welcome). Purely visual and non-interactive; stack it behind
/// real content in a `Stack`.
class CrushapOrbitBackground extends StatelessWidget {
  const CrushapOrbitBackground({super.key, this.size = 320});

  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _ring(size, CrushapColors.pink1.withValues(alpha: 0.35)),
            _ring(size * 0.76, CrushapColors.purple1.withValues(alpha: 0.4)),
            _ring(size * 0.54, CrushapColors.white1.withValues(alpha: 0.15)),
            Positioned(top: size * 0.02, left: size * 0.06, child: _dot(size * 0.16, CrushapColors.purple1)),
            Positioned(top: size * 0.2, right: 0, child: _dot(size * 0.09, CrushapColors.green1)),
            Positioned(bottom: size * 0.08, right: size * 0.16, child: _dot(size * 0.07, const Color(0xFFFF8A3D))),
            Positioned(bottom: size * 0.16, left: 0, child: _dot(size * 0.1, const Color(0xFF3D8BFF))),
            Positioned(bottom: 0, right: size * 0.34, child: _dot(size * 0.05, CrushapColors.pink1)),
          ],
        ),
      ),
    );
  }

  Widget _ring(double diameter, Color color) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: color, width: 1.5)),
    );
  }

  Widget _dot(double diameter, Color color) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
