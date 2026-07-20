import 'package:flutter/material.dart' show RefreshIndicator;
import 'package:flutter/widgets.dart';
import '../l10n/gen/app_localizations.dart';
import '../models/profile.dart';
import '../services/api_client.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../widgets/core/app_avatar.dart';
import '../widgets/core/app_icon.dart';
import '../widgets/navigation/bottom_nav.dart';

/// New — the "Matches" bottom-nav tab. The design system's BottomNav
/// component always listed a Matches tab, but no screen was ever specified
/// for it. This fills it in: a grid of everyone you've matched with (from
/// `GET /api/matches`), using only existing components/tokens — tapping a
/// match opens its chat.
class MatchesScreen extends StatefulWidget {
  const MatchesScreen({
    super.key,
    required this.api,
    required this.onOpenThread,
    required this.activeTab,
    required this.onTabChanged,
  });

  final ApiClient api;
  final ValueChanged<Profile> onOpenThread;
  final CrushapNavTab activeTab;
  final ValueChanged<CrushapNavTab> onTabChanged;

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  List<MatchEntry>? _matches;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final matches = await widget.api.matches();
      if (mounted) setState(() => _matches = matches);
    } catch (_) {
      if (mounted) setState(() => _matches = const []);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final matches = _matches;
    return ColoredBox(
      color: CrushapColors.surfaceApp,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 52,
              child: Center(child: Text(t.matchesTitle, style: CrushapText.title)),
            ),
            Expanded(
              child: matches == null
                  ? const SizedBox.shrink()
                  : matches.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CrushapIcon('heart', size: 32, color: CrushapColors.textTertiary),
                                const SizedBox(height: 12),
                                Text(
                                  t.noMatchesYet,
                                  textAlign: TextAlign.center,
                                  style: CrushapText.body.copyWith(color: CrushapColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _load,
                          child: GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.78,
                            ),
                            itemCount: matches.length,
                            itemBuilder: (context, i) {
                              final profile = matches[i].profile;
                              final photoUrl = widget.api.mediaUrl(profile.photos.isNotEmpty ? profile.photos.first : null);
                              return GestureDetector(
                                onTap: () => widget.onOpenThread(profile),
                                child: Column(
                                  children: [
                                    CrushapAvatar(
                                      name: profile.name,
                                      size: CrushapAvatarSize.lg,
                                      online: true,
                                      image: photoUrl == null ? null : NetworkImage(photoUrl),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${profile.name}, ${profile.age}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: CrushapText.bodySm,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
            ),
            CrushapBottomNav(active: widget.activeTab, onChanged: widget.onTabChanged),
          ],
        ),
      ),
    );
  }
}
