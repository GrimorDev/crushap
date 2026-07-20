import 'package:flutter/widgets.dart';
import 'colors.dart';

/// Type tokens — ported from tokens/typography.css + tokens/fonts.css.
/// Space Grotesk (display) / Manrope (body) — bundled as variable fonts
/// (assets/fonts/, declared in pubspec.yaml) rather than the web design
/// system's Google Fonts CDN `@import`, so the app has no runtime font
/// fetch dependency. See readme.md "Fonts note".
class CrushapText {
  CrushapText._();

  // Tracking (letter-spacing), expressed in em in the source; applied at
  // call sites (base text-* tokens below carry no tracking of their own).
  static const trackingTight = -0.02;
  static const trackingNormal = 0.0;
  static const trackingWide = 0.04;

  static TextStyle _display({
    required double size,
    required FontWeight weight,
    required double height,
  }) {
    return TextStyle(
      fontFamily: 'SpaceGrotesk',
      fontSize: size,
      fontWeight: weight,
      height: height,
      color: CrushapColors.textPrimary,
    );
  }

  static TextStyle _body({
    required double size,
    required FontWeight weight,
    required double height,
  }) {
    return TextStyle(
      fontFamily: 'Manrope',
      fontSize: size,
      fontWeight: weight,
      height: height,
      color: CrushapColors.textPrimary,
    );
  }

  static TextStyle get displayXl =>
      _display(size: 48, weight: FontWeight.w700, height: 1.08);
  static TextStyle get displayLg =>
      _display(size: 36, weight: FontWeight.w700, height: 1.08);
  static TextStyle get displayMd =>
      _display(size: 28, weight: FontWeight.w600, height: 1.25);
  static TextStyle get title =>
      _display(size: 22, weight: FontWeight.w600, height: 1.25);

  static TextStyle get bodyLg =>
      _body(size: 18, weight: FontWeight.w400, height: 1.45);
  static TextStyle get body =>
      _body(size: 16, weight: FontWeight.w400, height: 1.45);
  static TextStyle get bodySm =>
      _body(size: 14, weight: FontWeight.w500, height: 1.45);
  static TextStyle get caption =>
      _body(size: 12, weight: FontWeight.w600, height: 1.45);
}
