import 'package:flutter/widgets.dart';
import '../l10n/gen/app_localizations.dart';
import '../models/profile.dart';
import '../services/api_client.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';
import '../widgets/core/app_chip.dart';
import '../widgets/core/app_icon.dart';
import '../widgets/core/app_icon_button.dart';

/// The full-profile view the reference design's "About Me" screen implied
/// but the swipe card alone (name + one-line bio + a few tags) never had
/// room for — every photo at full size, the complete bio, and every
/// interest. Reachable by expanding a Discover card or tapping a row in
/// Search/Likes.
class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({
    super.key,
    required this.profile,
    required this.api,
    required this.onBack,
  });

  final Profile profile;
  final ApiClient api;
  final VoidCallback onBack;

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  int _photoIndex = 0;

  String _lookingForLabel(AppLocalizations t, String value) => switch (value) {
    'relationship' => t.lookingForRelationship,
    'casual' => t.lookingForCasual,
    'friends' => t.lookingForFriends,
    _ => t.lookingForUnsure,
  };

  String _lookingForIcon(String value) => switch (value) {
    'relationship' => 'heart',
    'casual' => 'zap',
    'friends' => 'users',
    _ => 'sparkles',
  };

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final p = widget.profile;
    final photoUrls = [
      for (final photo in p.photos) widget.api.mediaUrl(photo)!,
    ];
    final index = _photoIndex.clamp(
      0,
      photoUrls.isEmpty ? 0 : photoUrls.length - 1,
    );
    final photoUrl = photoUrls.isEmpty ? null : photoUrls[index];

    return ColoredBox(
      color: CrushapColors.surfaceApp,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AspectRatio(
                      aspectRatio: 340 / 440,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (photoUrl != null)
                            Image.network(
                              photoUrl,
                              key: ValueKey(photoUrl),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stack) =>
                                  const _PhotoPlaceholder(),
                            )
                          else
                            const _PhotoPlaceholder(),
                          if (photoUrls.length > 1)
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTapUp: (d) => setState(() {
                                final forward =
                                    d.localPosition.dx >
                                    context.size!.width / 3;
                                _photoIndex = (_photoIndex + (forward ? 1 : -1))
                                    .clamp(0, photoUrls.length - 1);
                              }),
                            ),
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: CrushapColors.gradientScrimBottom,
                            ),
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
                                          color: i <= index
                                              ? const Color(0xFFFFFFFF)
                                              : const Color(0x4DFFFFFF),
                                          borderRadius: BorderRadius.circular(
                                            CrushapRadii.pill,
                                          ),
                                        ),
                                        child: const SizedBox(height: 3),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          Positioned(
                            top: 12,
                            left: 12,
                            child: CrushapIconButton(
                              icon: 'arrow-left',
                              label: t.backLabel,
                              variant: CrushapIconButtonVariant.ghost,
                              size: CrushapIconButtonSize.sm,
                              onPressed: widget.onBack,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${p.name}, ${p.age}',
                                style: CrushapText.displayMd,
                              ),
                              if (p.verified) ...[
                                const SizedBox(width: 8),
                                Semantics(
                                  label: t.verifiedBadge,
                                  child: const CrushapIcon(
                                    'shield-check',
                                    size: 20,
                                    color: CrushapColors.accentPrimary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (p.distanceValue != null) ...[
                            const SizedBox(height: 6),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CrushapIcon(
                                  'map-pin',
                                  size: 14,
                                  color: CrushapColors.textTertiary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  t.distanceAwayKm(p.distanceValue!),
                                  style: CrushapText.bodySm.copyWith(
                                    color: CrushapColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (p.lookingFor != null) ...[
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: CrushapColors.surfaceElevated,
                                borderRadius: BorderRadius.circular(
                                  CrushapRadii.pill,
                                ),
                                border: Border.all(
                                  color: CrushapColors.borderSubtle,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CrushapIcon(
                                    _lookingForIcon(p.lookingFor!),
                                    size: 14,
                                    color: CrushapColors.accentPrimary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _lookingForLabel(t, p.lookingFor!),
                                    style: CrushapText.bodySm,
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),
                          Text(
                            t.aboutSection.toUpperCase(),
                            style: CrushapText.bodySm.copyWith(
                              color: CrushapColors.textTertiary,
                              letterSpacing: CrushapText.trackingWide * 14,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            p.bio.isEmpty ? t.addBioPrompt : p.bio,
                            style: CrushapText.body.copyWith(
                              color: CrushapColors.textSecondary,
                            ),
                          ),
                          if (p.tags.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            Text(
                              t.interestsSection.toUpperCase(),
                              style: CrushapText.bodySm.copyWith(
                                color: CrushapColors.textTertiary,
                                letterSpacing: CrushapText.trackingWide * 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final tag in p.tags)
                                  CrushapChip(label: tag, selected: true),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
          begin: Alignment(-0.64, -0.94),
          end: Alignment(0.64, 0.94),
          colors: [CrushapColors.black4, CrushapColors.black2],
        ),
      ),
      alignment: Alignment.center,
      child: CrushapIcon(
        'image',
        size: 48,
        color: CrushapColors.textTertiary.withValues(alpha: 0.4),
      ),
    );
  }
}
