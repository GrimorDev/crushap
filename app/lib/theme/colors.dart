import 'package:flutter/widgets.dart';

/// Crushap color tokens — matched to the reference Badoo-style redesign:
/// a warm near-black canvas (not pure black), a hot pink/magenta primary
/// accent, and gold as the secondary/currency accent.
class CrushapColors {
  CrushapColors._();

  // Base — warm dark grey scale (not a cool neutral or tinted black).
  static const black1 = Color(0xFF19181E);
  static const black2 = Color(0xFF211F27);
  static const black3 = Color(0xFF2A2830);
  static const black4 = Color(0xFF35323C);

  static const white1 = Color(0xFFFFFFFF);
  static const white2 = Color(0xFFF2F1F3);

  static const grey1 = Color(0xFFD5D3D7);
  static const grey2 = Color(0xFF9C9AA1);
  static const grey3 = Color(0xFF636067);

  static const pink1 = Color(0xFFFF0066);
  static const pink2 = Color(0xFFFF3D8A);
  static const pink3 = Color(0xFFCC0052);
  static const pinkGlow = Color(0x73FF0066); // rgba(255,0,102,.45)

  static const gold1 = Color(0xFFFFDA07);
  static const gold2 = Color(0xFFFFE862);

  static const green1 = Color(0xFF3DDC84);
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

  static const accentPrimary = pink1;
  static const accentPrimaryHover = pink2;
  static const accentPrimaryPress = pink3;
  static const accentSecondary = gold1;
  static const accentGlow = pinkGlow;

  static const actionLike = green1;
  static const actionPass = red1;
  static const actionSuperlike = gold1;

  static const overlayScrim = Color(0xD119181E); // rgba(25,24,30,.82)

  static const gradientPrimary = LinearGradient(
    begin: Alignment(-0.71, -0.71), // ~135deg
    end: Alignment(0.71, 0.71),
    colors: [pink1, pink3],
  );

  static const gradientScrimBottom = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    // to top, rgba(25,24,30,.92) -> rgba(25,24,30,0) at 60%
    colors: [Color(0xEB19181E), Color(0x0019181E), Color(0x0019181E)],
    stops: [0.0, 0.6, 1.0],
  );
}
