import 'package:flutter/widgets.dart';

/// Crushap color tokens — ported 1:1 from tokens/colors.css.
class CrushapColors {
  CrushapColors._();

  // Base
  static const black1 = Color(0xFF0B0710);
  static const black2 = Color(0xFF130D17);
  static const black3 = Color(0xFF1B131F);
  static const black4 = Color(0xFF241A29);

  static const white1 = Color(0xFFFBF6F8);
  static const white2 = Color(0xFFEFE6EC);

  static const grey1 = Color(0xFFC9BDC8);
  static const grey2 = Color(0xFF948A96);
  static const grey3 = Color(0xFF5E5563);

  static const pink1 = Color(0xFFFF2E63);
  static const pink2 = Color(0xFFFF4778);
  static const pink3 = Color(0xFFE0184C);
  static const pinkGlow = Color(0x73FF2E63); // rgba(255,46,99,.45)

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

  static const accentPrimary = pink1;
  static const accentPrimaryHover = pink2;
  static const accentPrimaryPress = pink3;
  static const accentSecondary = gold1;
  static const accentGlow = pinkGlow;

  static const actionLike = green1;
  static const actionPass = red1;
  static const actionSuperlike = gold1;

  static const overlayScrim = Color(0xD10B0710); // rgba(11,7,16,.82)

  static const gradientPrimary = LinearGradient(
    begin: Alignment(-0.71, -0.71), // ~135deg
    end: Alignment(0.71, 0.71),
    colors: [pink1, pink3],
  );

  static const gradientScrimBottom = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    // to top, rgba(11,7,16,.92) -> rgba(11,7,16,0) at 60%
    colors: [Color(0xEB0B0710), Color(0x000B0710), Color(0x000B0710)],
    stops: [0.0, 0.6, 1.0],
  );
}
