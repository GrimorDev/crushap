import 'package:flutter/widgets.dart';
import '../../theme/colors.dart';
import '../../theme/effects.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../core/app_icon.dart';

/// Ported from components/dating/SwipeCard.jsx.
///
/// Shows the candidate's uploaded photos (`photoUrls`), cycled via tap zones
/// (left third = previous, right two-thirds = next — same convention as
/// Instagram Stories/Tinder) when there's more than one; falls back to the
/// same placeholder tile the original design system used when no
/// photography was available at all.
class CrushapSwipeCard extends StatelessWidget {
  const CrushapSwipeCard({
    super.key,
    required this.name,
    required this.age,
    this.distance,
    this.verified = false,
    this.verifiedLabel = 'Verified',
    this.statusLabel,
    this.statusIcon,
    this.bio,
    this.tags = const [],
    this.photoUrls = const [],
    this.photoIndex = 0,
    this.onTapPhoto,
    this.width = 340,
    this.height = 460,
  });

  final String name;
  final int age;
  final String? distance;
  final bool verified;
  final String verifiedLabel;
  /// The "Ready for relationship"-style status pill, top-left of the
  /// photo — null hides it (e.g. lookingFor unset).
  final String? statusLabel;
  final String? statusIcon;
  final String? bio;
  final List<String> tags;
  final List<String> photoUrls;
  final int photoIndex;
  /// `true` to advance forward, `false` to go back — only called when
  /// there's more than one photo to cycle through.
  final ValueChanged<bool>? onTapPhoto;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final index = photoIndex.clamp(0, photoUrls.isEmpty ? 0 : photoUrls.length - 1);
    final photoUrl = photoUrls.isEmpty ? null : photoUrls[index];
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(CrushapRadii.xl),
        boxShadow: CrushapEffects.shadowElevated,
        border: Border.all(color: CrushapColors.borderSubtle),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (photoUrl != null)
            Image.network(
              photoUrl,
              key: ValueKey(photoUrl),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => const _PhotoPlaceholder(),
              loadingBuilder: (context, child, progress) => progress == null ? child : const _PhotoPlaceholder(),
            )
          else
            const _PhotoPlaceholder(),
          if (photoUrls.length > 1)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: (d) => onTapPhoto?.call(d.localPosition.dx > width / 3),
            ),
          // Bottom scrim for text legibility.
          const DecoratedBox(
            decoration: BoxDecoration(gradient: CrushapColors.gradientScrimBottom),
          ),
          if (photoUrls.length > 1)
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Row(
                children: [
                  for (final (i, _) in photoUrls.indexed) ...[
                    if (i > 0) const SizedBox(width: 4),
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: i <= index ? const Color(0xFFFFFFFF) : const Color(0x4DFFFFFF),
                          borderRadius: BorderRadius.circular(CrushapRadii.pill),
                        ),
                        child: const SizedBox(height: 3),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          if (statusLabel != null)
            Positioned(
              top: photoUrls.length > 1 ? 28 : 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0x99000000), // rgba(0,0,0,.6)
                  borderRadius: BorderRadius.circular(CrushapRadii.pill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (statusIcon != null) ...[
                      CrushapIcon(statusIcon!, size: 13, color: CrushapColors.accentPrimary),
                      const SizedBox(width: 6),
                    ],
                    Text(statusLabel!, style: CrushapText.caption.copyWith(color: CrushapColors.textPrimary)),
                  ],
                ),
              ),
            ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(name, style: CrushapText.displayMd),
                    const SizedBox(width: 8),
                    Text('$age', style: CrushapText.title.copyWith(color: CrushapColors.textSecondary)),
                    if (verified) ...[
                      const SizedBox(width: 6),
                      Semantics(
                        label: verifiedLabel,
                        child: const CrushapIcon('shield-check', size: 18, color: CrushapColors.accentPrimary),
                      ),
                    ],
                  ],
                ),
                if (distance != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CrushapIcon('map-pin', size: 14, color: CrushapColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(distance!, style: CrushapText.bodySm.copyWith(color: CrushapColors.textSecondary)),
                    ],
                  ),
                ],
                if (bio != null) ...[
                  const SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: Text(
                      bio!,
                      style: CrushapText.bodySm.copyWith(color: CrushapColors.textSecondary),
                    ),
                  ),
                ],
                if (tags.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final t in tags)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0x1AFFFFFF), // rgba(255,255,255,.1)
                            borderRadius: BorderRadius.circular(CrushapRadii.pill),
                          ),
                          child: Text(t, style: CrushapText.caption.copyWith(color: CrushapColors.textPrimary)),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.64, -0.94), // ~160deg
          end: Alignment(0.64, 0.94),
          colors: [CrushapColors.black4, CrushapColors.black2],
        ),
      ),
      alignment: Alignment.center,
      child: CrushapIcon('image', size: 40, color: CrushapColors.textTertiary.withValues(alpha: 0.4)),
    );
  }
}
