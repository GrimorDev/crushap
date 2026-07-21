import 'package:flutter/widgets.dart';
import '../l10n/gen/app_localizations.dart';
import '../models/profile.dart';
import '../services/api_client.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';
import '../widgets/core/app_icon.dart';
import '../widgets/core/settings_scaffold.dart';

/// The "Likes" screen from the Badoo reference — everyone who's liked or
/// superliked you but you haven't matched with yet (`GET /api/likes`).
/// Tapping the heart on a card likes them back; since they already liked
/// you, that always completes the match immediately.
class LikesScreen extends StatefulWidget {
  const LikesScreen({super.key, required this.api, required this.onMatch, required this.onBack});

  final ApiClient api;
  final ValueChanged<Profile> onMatch;
  final VoidCallback onBack;

  @override
  State<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  List<LikeEntry>? _likes;
  bool _newOnly = false;
  final Set<String> _busyIds = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final likes = await widget.api.likes();
      if (mounted) setState(() => _likes = likes);
    } catch (_) {
      if (mounted) setState(() => _likes = const []);
    }
  }

  Future<void> _likeBack(LikeEntry entry) async {
    if (_busyIds.contains(entry.profile.id)) return;
    setState(() => _busyIds.add(entry.profile.id));
    try {
      final result = await widget.api.swipe(entry.profile.id, 'like');
      setState(() => _likes = _likes?.where((e) => e.profile.id != entry.profile.id).toList());
      if (result.matched && result.profile != null) {
        // Everyone here already liked us, so liking back is always mutual —
        // pop back to the main screen first so the match celebration
        // overlay (owned by the root route) is actually visible instead of
        // rendering behind this pushed screen.
        widget.onBack();
        widget.onMatch(result.profile!);
      }
    } catch (_) {
      // Leave the card in place so the user can retry.
    } finally {
      if (mounted) setState(() => _busyIds.remove(entry.profile.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final likes = _likes;
    final visible = likes == null ? null : (_newOnly ? likes.where((e) => e.isNew).toList() : likes);
    return SettingsScaffold(
      title: t.likesTitle,
      backLabel: t.backLabel,
      onBack: widget.onBack,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: _LikesTabBar(
              newOnly: _newOnly,
              allLabel: t.allLikesTab,
              newLabel: t.newLikesTab,
              onChanged: (v) => setState(() => _newOnly = v),
            ),
          ),
          Expanded(
            child: visible == null
                ? const SizedBox.shrink()
                : visible.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CrushapIcon('heart', size: 32, color: CrushapColors.textTertiary),
                              const SizedBox(height: 12),
                              Text(
                                t.noLikesYetTitle,
                                textAlign: TextAlign.center,
                                style: CrushapText.title,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                t.noLikesYetMessage,
                                textAlign: TextAlign.center,
                                style: CrushapText.bodySm.copyWith(color: CrushapColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.82,
                        ),
                        itemCount: visible.length,
                        itemBuilder: (context, i) {
                          final entry = visible[i];
                          final photoUrl = widget.api.mediaUrl(
                            entry.profile.photos.isNotEmpty ? entry.profile.photos.first : null,
                          );
                          return _LikeCard(
                            entry: entry,
                            photoUrl: photoUrl,
                            busy: _busyIds.contains(entry.profile.id),
                            onLikeBack: () => _likeBack(entry),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _LikesTabBar extends StatelessWidget {
  const _LikesTabBar({
    required this.newOnly,
    required this.allLabel,
    required this.newLabel,
    required this.onChanged,
  });

  final bool newOnly;
  final String allLabel;
  final String newLabel;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: CrushapColors.surfaceElevated,
        borderRadius: BorderRadius.circular(CrushapRadii.pill),
        border: Border.all(color: CrushapColors.borderSubtle),
      ),
      child: Row(
        children: [
          Expanded(child: _Tab(label: allLabel, selected: !newOnly, onTap: () => onChanged(false))),
          Expanded(child: _Tab(label: newLabel, selected: newOnly, onTap: () => onChanged(true))),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: selected ? CrushapColors.accentPrimary : null,
          borderRadius: BorderRadius.circular(CrushapRadii.pill),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: CrushapText.bodySm.copyWith(
            color: selected ? CrushapColors.textPrimary : CrushapColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _LikeCard extends StatelessWidget {
  const _LikeCard({required this.entry, required this.photoUrl, required this.busy, required this.onLikeBack});

  final LikeEntry entry;
  final String? photoUrl;
  final bool busy;
  final VoidCallback onLikeBack;

  @override
  Widget build(BuildContext context) {
    final profile = entry.profile;
    return ClipRRect(
      borderRadius: BorderRadius.circular(CrushapRadii.lg),
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: CrushapColors.surfaceCard,
              image: photoUrl == null ? null : DecorationImage(image: NetworkImage(photoUrl!), fit: BoxFit.cover),
            ),
            child: photoUrl == null
                ? Center(child: CrushapIcon('image', size: 28, color: CrushapColors.textTertiary.withValues(alpha: 0.4)))
                : null,
          ),
          const DecoratedBox(decoration: BoxDecoration(gradient: CrushapColors.gradientScrimBottom)),
          if (entry.isNew)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: CrushapColors.accentPrimary,
                  borderRadius: BorderRadius.circular(CrushapRadii.pill),
                ),
                child: Text('•', style: CrushapText.caption.copyWith(color: CrushapColors.textPrimary)),
              ),
            ),
          Positioned(
            left: 10,
            right: 10,
            bottom: 10,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${profile.name}, ${profile.age}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: CrushapText.bodySm.copyWith(color: CrushapColors.textPrimary, fontWeight: FontWeight.w600),
                  ),
                ),
                GestureDetector(
                  onTap: busy ? null : onLikeBack,
                  child: Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: CrushapColors.accentPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: const CrushapIcon('heart', size: 15, color: CrushapColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
