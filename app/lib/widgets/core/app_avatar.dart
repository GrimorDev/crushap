import 'package:flutter/widgets.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';

enum CrushapAvatarSize { sm, md, lg, xl }

/// Ported from components/core/Avatar.jsx. No real photography is bundled
/// with this design system, so `image` is left null in every UI kit usage —
/// the gradient + initial fallback is what actually renders.
class CrushapAvatar extends StatelessWidget {
  const CrushapAvatar({
    super.key,
    required this.name,
    this.image,
    this.size = CrushapAvatarSize.md,
    this.online = false,
  });

  final String name;
  final ImageProvider? image;
  final CrushapAvatarSize size;
  final bool online;

  double get _px => switch (size) {
        CrushapAvatarSize.sm => 32,
        CrushapAvatarSize.md => 48,
        CrushapAvatarSize.lg => 72,
        CrushapAvatarSize.xl => 112,
      };

  @override
  Widget build(BuildContext context) {
    final px = _px;
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';
    return SizedBox(
      width: px,
      height: px,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (image != null)
            Container(
              width: px,
              height: px,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: CrushapColors.borderSubtle, width: 2),
                image: DecorationImage(image: image!, fit: BoxFit.cover),
              ),
            )
          else
            Container(
              width: px,
              height: px,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                gradient: CrushapColors.gradientPrimary,
                shape: BoxShape.circle,
              ),
              child: Text(
                initial,
                style: _initialStyle(px * 0.4),
              ),
            ),
          if (online)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: px * 0.26,
                height: px * 0.26,
                decoration: BoxDecoration(
                  color: CrushapColors.actionLike,
                  shape: BoxShape.circle,
                  border: Border.all(color: CrushapColors.surfaceApp, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Bold Space Grotesk at an arbitrary (size-derived) px, for the initial
// fallback glyph — not one of the fixed type-scale tokens.
TextStyle _initialStyle(double size) {
  return CrushapText.displayXl.copyWith(fontSize: size, color: const Color(0xFFFFFFFF));
}
