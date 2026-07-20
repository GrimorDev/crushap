import 'package:flutter/widgets.dart';
import '../models/profile.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../widgets/core/app_avatar.dart';
import '../widgets/core/app_chip.dart';
import '../widgets/core/app_icon.dart';
import '../widgets/forms/app_input.dart';
import '../widgets/navigation/bottom_nav.dart';

/// New — the "Search" bottom-nav tab. No source screen existed for it
/// either (same gap as Matches), so this is a straightforward search over
/// the sample profile pool by name or interest, built only from existing
/// components (Input, Avatar, Chip).
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.activeTab, required this.onTabChanged});

  final CrushapNavTab activeTab;
  final ValueChanged<CrushapNavTab> onTabChanged;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final results = query.isEmpty
        ? sampleProfiles
        : sampleProfiles.where((p) {
            return p.name.toLowerCase().contains(query) ||
                p.tags.any((t) => t.toLowerCase().contains(query));
          }).toList();

    return ColoredBox(
      color: CrushapColors.surfaceApp,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: CrushapInput(
                controller: _controller,
                placeholder: 'Search by name or interest',
                icon: const CrushapIcon('search', size: 18, color: CrushapColors.textTertiary),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            Expanded(
              child: results.isEmpty
                  ? Center(
                      child: Text(
                        'No one matches "$query" yet.',
                        style: CrushapText.body.copyWith(color: CrushapColors.textSecondary),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      itemCount: results.length,
                      separatorBuilder: (context, i) => const SizedBox(height: 2),
                      itemBuilder: (context, i) {
                        final p = results[i];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CrushapAvatar(name: p.name, size: CrushapAvatarSize.md),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('${p.name}, ${p.age}', style: CrushapText.body.copyWith(fontWeight: FontWeight.w600)),
                                        const SizedBox(width: 6),
                                        Text(p.distance, style: CrushapText.bodySm.copyWith(color: CrushapColors.textTertiary)),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 6,
                                      children: [for (final t in p.tags) CrushapChip(label: t)],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            CrushapBottomNav(active: widget.activeTab, onChanged: widget.onTabChanged),
          ],
        ),
      ),
    );
  }
}
