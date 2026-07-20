import 'package:flutter/widgets.dart';
import '../../theme/colors.dart';
import '../../theme/effects.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../core/app_badge.dart';
import '../core/app_icon.dart';

/// Ported from components/dating/SwipeCard.jsx.
///
/// No real photography ships with this design system (see readme.md), so
/// the photo layer is a placeholder tile — same intent as the prototype's
/// `<image-slot>`, without inventing a photo.
class CrushapSwipeCard extends StatelessWidget {
  const CrushapSwipeCard({
    super.key,
    required this.name,
    required this.age,
    this.distance,
    this.verified = false,
    this.bio,
    this.tags = const [],
    this.width = 340,
    this.height = 460,
  });

  final String name;
  final int age;
  final String? distance;
  final bool verified;
  final String? bio;
  final List<String> tags;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
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
          // Photo placeholder (no bundled photography for this brand).
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.64, -0.94), // ~160deg
                end: Alignment(0.64, 0.94),
                colors: [CrushapColors.black4, CrushapColors.black2],
              ),
            ),
            alignment: Alignment.center,
            child: CrushapIcon('image', size: 40, color: CrushapColors.textTertiary.withValues(alpha: 0.4)),
          ),
          // Bottom scrim for text legibility.
          const DecoratedBox(
            decoration: BoxDecoration(gradient: CrushapColors.gradientScrimBottom),
          ),
          if (verified)
            Positioned(
              top: 16,
              right: 16,
              child: CrushapBadge(
                label: 'Verified',
                variant: CrushapBadgeVariant.verified,
                icon: const CrushapIcon('shield-check', size: 12),
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
