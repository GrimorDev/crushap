import 'package:flutter/widgets.dart';

/// Crushap color tokens. Deliberately not the red/pink "flame" look most
/// dating apps default to — this is a violet-to-burgundy dark palette
/// (fiolet/bordo), including the base surfaces themselves carrying a
/// visible violet tint rather than a neutral near-black.
class CrushapColors {
  CrushapColors._();

  // Base — violet-tinted dark scale (not neutral grey/black).
  static const black1 = Color(0xFF120A18);
  static const black2 = Color(0xFF1B0F24);
  static const black3 = Color(0xFF241531);
  static const black4 = Color(0xFF301C40);

  static const white1 = Color(0xFFFBF6F8);
  static const white2 = Color(0xFFEFE6EC);

  static const grey1 = Color(0xFFC9BDC8);
  static const grey2 = Color(0xFF948A96);
  static const grey3 = Color(0xFF5E5563);

  // Brand duo: a vivid violet paired with a deep burgundy/wine, not two
  // shades of the same hue — that two-hue blend is what actually reads as
  // "fiolet bordo" rather than just "purple Tinder."
  static const violet1 = Color(0xFFA83AF0);
  static const violet2 = Color(0xFFC26EFF);
  static const burgundy1 = Color(0xFF7A1030);
  static const burgundy2 = Color(0xFF5C0C24);
  static const violetGlow = Color(0x73A83AF0); // rgba(168,58,240,.45)

  static const gold1 = Color(0xFFFFC145);
  static const gold2 = Color(0xFFFFD37A);

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
  static const textOnAccent = black1;

  static const accentPrimary = violet1;
  static const accentPrimaryHover = violet2;
  static const accentPrimaryPress = burgundy1;
  static const accentSecondary = gold1;
  static const accentGlow = violetGlow;

  static const actionLike = green1;
  static const actionPass = red1;
  static const actionSuperlike = gold1;

  static const overlayScrim = Color(0xD1120A18); // rgba(18,10,24,.82)

  static const gradientPrimary = LinearGradient(
    begin: Alignment(-0.71, -0.71), // ~135deg
    end: Alignment(0.71, 0.71),
    colors: [violet1, burgundy1],
  );

  static const gradientScrimBottom = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    // to top, rgba(18,10,24,.92) -> rgba(18,10,24,0) at 60%
    colors: [Color(0xEB120A18), Color(0x00120A18), Color(0x00120A18)],
    stops: [0.0, 0.6, 1.0],
  );
}
