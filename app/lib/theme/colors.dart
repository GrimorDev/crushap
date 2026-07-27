import 'package:flutter/widgets.dart';

/// Crushap color tokens — matched to the "Destined" reference redesign: a
/// deep purple/navy "cosmic" canvas, a solid violet accent for icons and
/// badges, and a pink→violet diagonal gradient reserved for primary CTAs
/// (buttons, glows) — gold stays as the sparing link/highlight accent.
class CrushapColors {
  CrushapColors._();

  // Base — deep purple/navy scale (not a neutral or warm-grey black).
  static const black1 = Color(0xFF170D2B);
  static const black2 = Color(0xFF211539);
  static const black3 = Color(0xFF2B1D4A);
  static const black4 = Color(0xFF372458);

  static const white1 = Color(0xFFFFFFFF);
  static const white2 = Color(0xFFF2F0F8);

  static const grey1 = Color(0xFFD9D0EC); // secondary text — lavender-tinted
  static const grey2 = Color(0xFF9E8FC2); // tertiary text / placeholders
  static const grey3 = Color(0xFF6B5D91);

  static const pink1 = Color(0xFFFF3D71); // gradient start (warm pink-red)
  static const pink2 = Color(0xFFFF6B93); // lighter pink — hover
  static const pinkGlow = Color(0x66FF3D71); // rgba(255,61,113,.4)

  static const purple1 = Color(0xFF7B5CFA); // solid accent + gradient end
  static const purple2 = Color(0xFF9B82FF); // lighter purple — hover
  static const purple3 = Color(0xFF5B3FD9); // darker purple — press

  static const gold1 = Color(0xFFFFC94A);
  static const gold2 = Color(0xFFFFDD8A);

  static const green1 = Color(0xFF3ED598);
  static const red1 = Color(0xFFFF5A5A);

  // Semantic
  static const surfaceApp = black1;
  static const surfaceElevated = black2;
  static const surfaceCard = black3;
  static const surfaceCardHover = black4;

  static const borderSubtle = Color(0x14FFFFFF); // rgba(255,255,255,.08)
  static const borderStrong = Color(0x29FFFFFF); // rgba(255,255,255,.16)

  static const textPrimary = white1;
  static const textSecondary = grey1;
  static const textTertiary = grey2;
  static const textOnAccent = white1;

  static const accentPrimary = purple1;
  static const accentPrimaryHover = purple2;
  static const accentPrimaryPress = purple3;
  static const accentSecondary = gold1;
  static const accentGlow = pinkGlow;

  static const actionLike = green1;
  static const actionPass = red1;
  static const actionSuperlike = gold1;

  static const overlayScrim = Color(0xD1170D2B); // rgba(23,13,43,.82)

  static const gradientPrimary = LinearGradient(
    begin: Alignment(-0.71, -0.71), // ~135deg
    end: Alignment(0.71, 0.71),
    colors: [pink1, purple1],
  );

  static const gradientScrimBottom = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    // to top, rgba(23,13,43,.92) -> rgba(23,13,43,0) at 60%
    colors: [Color(0xEB170D2B), Color(0x00170D2B), Color(0x00170D2B)],
    stops: [0.0, 0.6, 1.0],
  );
}
