import 'package:flutter/widgets.dart';
import 'colors.dart';

/// Shadow / motion / blur tokens — ported from tokens/effects.css.
class CrushapEffects {
  CrushapEffects._();

  static const shadowCard = [
    BoxShadow(color: Color(0x73000000), blurRadius: 24, offset: Offset(0, 8)),
  ];

  static const shadowElevated = [
    BoxShadow(color: Color(0x8C000000), blurRadius: 48, offset: Offset(0, 20)),
  ];

  static const shadowGlowPrimary = [
    BoxShadow(color: CrushapColors.accentGlow, blurRadius: 32, spreadRadius: 0),
  ];

  static const shadowModal = [
    BoxShadow(color: Color(0x99000000), blurRadius: 64, offset: Offset(0, 24)),
  ];

  /// CSS `blur(20px)` frosted-glass backdrop, used only on the bottom nav
  /// and the match overlay scrim.
  static const blurGlassSigma = 20.0;

  static const easeStandard = Cubic(0.22, 1, 0.36, 1);
  static const easeSpring = Cubic(0.34, 1.56, 0.64, 1);

  static const durFast = Duration(milliseconds: 120);
  static const durNormal = Duration(milliseconds: 220);
  static const durSlow = Duration(milliseconds: 400);
}
