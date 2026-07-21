import 'package:flutter/widgets.dart';
import 'colors.dart';

/// Type tokens. Poppins for both display and body — a single geometric,
/// rounded family (matching the reference design) rather than a
/// display/body pairing — bundled as static weight files (assets/fonts/,
/// declared in pubspec.yaml) so the app has no runtime font fetch
/// dependency.
class CrushapText {
  CrushapText._();

  // Tracking (letter-spacing), expressed in em in the source; applied at
  // call sites (base text-* tokens below carry no tracking of their own).
  static const trackingTight = -0.02;
  static const trackingNormal = 0.0;
  static const trackingWide = 0.04;

  static TextStyle _base({
    required double size,
    required FontWeight weight,
    required double height,
  }) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: size,
      fontWeight: weight,
      height: height,
      color: CrushapColors.textPrimary,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle get displayXl =>
      _base(size: 48, weight: FontWeight.w700, height: 1.08);
  static TextStyle get displayLg =>
      _base(size: 36, weight: FontWeight.w700, height: 1.08);
  static TextStyle get displayMd =>
      _base(size: 28, weight: FontWeight.w600, height: 1.25);
  static TextStyle get title =>
      _base(size: 22, weight: FontWeight.w600, height: 1.25);

  static TextStyle get bodyLg =>
      _base(size: 18, weight: FontWeight.w400, height: 1.45);
  static TextStyle get body =>
      _base(size: 16, weight: FontWeight.w400, height: 1.45);
  static TextStyle get bodySm =>
      _base(size: 14, weight: FontWeight.w500, height: 1.45);
  static TextStyle get caption =>
      _base(size: 12, weight: FontWeight.w600, height: 1.45);
}
