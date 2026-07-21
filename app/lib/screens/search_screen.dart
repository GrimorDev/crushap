import 'dart:async';
import 'package:flutter/widgets.dart';
import '../l10n/gen/app_localizations.dart';
import '../models/profile.dart';
import '../services/api_client.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../widgets/core/app_avatar.dart';
import '../widgets/core/app_chip.dart';
import '../widgets/core/app_icon.dart';
import '../widgets/forms/app_input.dart';
import '../widgets/navigation/bottom_nav.dart';

/// The "Search" bottom-nav tab — search over every registered user
/// (`GET /api/search`) by name or interest tag.
class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.api,
    required this.onOpenProfile,
    required this.activeTab,
    required this.onTabChanged,
  });

  final ApiClient api;
  final ValueChanged<Profile> onOpenProfile;
  final CrushapNavTab activeTab;
  final ValueChanged<CrushapNavTab> onTabChanged;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  List<Profile> _results = [];
  bool _loading = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _runSearch('');
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () => _runSearch(value),
    );
  }

  Future<void> _runSearch(String query) async {
    setState(() => _loading = true);
    try {
      final results = await widget.api.search(query);
      if (mounted) setState(() => _results = results);
    } catch (_) {
      if (mounted) setState(() => _results = []);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return ColoredBox(
      color: CrushapColors.surfaceApp,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: CrushapInput(
                controller: _controller,
                placeholder: t.searchPlaceholder,
                icon: const CrushapIcon(
                  'search',
                  size: 18,
                  color: CrushapColors.textTertiary,
                ),
                onChanged: _onChanged,
              ),
            ),
            Expanded(
              child: _loading
                  ? const SizedBox.shrink()
                  : _results.isEmpty
                  ? Center(
                      child: Text(
                        t.noSearchResults,
                        style: CrushapText.body.copyWith(
                          color: CrushapColors.textSecondary,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      itemCount: _results.length,
                      separatorBuilder: (context, i) =>
                          const SizedBox(height: 2),
                      itemBuilder: (context, i) {
                        final p = _results[i];
                        final photoUrl = widget.api.mediaUrl(
                          p.photos.isNotEmpty ? p.photos.first : null,
                        );
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => widget.onOpenProfile(p),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 10,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CrushapAvatar(
                                  name: p.name,
                                  size: CrushapAvatarSize.md,
                                  image: photoUrl == null
                                      ? null
                                      : NetworkImage(photoUrl),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${p.name}, ${p.age}',
                                            style: CrushapText.body.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          if (p.distanceValue != null) ...[
                                            const SizedBox(width: 6),
                                            Text(
                                              t.distanceAwayKm(
                                                p.distanceValue!,
                                              ),
                                              style: CrushapText.bodySm
                                                  .copyWith(
                                                    color: CrushapColors
                                                        .textTertiary,
                                                  ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: [
                                          for (final t in p.tags)
                                            CrushapChip(label: t),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            CrushapBottomNav(
              active: widget.activeTab,
              onChanged: widget.onTabChanged,
            ),
          ],
        ),
      ),
    );
  }
}
