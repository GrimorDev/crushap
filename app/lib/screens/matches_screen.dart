import 'package:flutter/widgets.dart';
import '../models/profile.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../widgets/core/app_avatar.dart';
import '../widgets/core/app_icon.dart';
import '../widgets/navigation/bottom_nav.dart';

/// New — the "Matches" bottom-nav tab. The design system's BottomNav
/// component always listed a Matches tab, but no screen was ever specified
/// for it (only a ComingSoon placeholder). This fills it in: a grid of
/// everyone you've matched with, using only existing components/tokens
/// (Avatar, Badge colors, spacing scale) — tapping a match opens its chat.
class MatchesScreen extends StatelessWidget {
  const MatchesScreen({
    super.key,
    required this.matches,
    required this.onOpenThread,
    required this.activeTab,
    required this.onTabChanged,
  });

  final List<Profile> matches;
  final ValueChanged<Profile> onOpenThread;
  final CrushapNavTab activeTab;
  final ValueChanged<CrushapNavTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: CrushapColors.surfaceApp,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 52,
              child: Center(child: Text('Matches', style: CrushapText.title)),
            ),
            Expanded(
              child: matches.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CrushapIcon('heart', size: 32, color: CrushapColors.textTertiary),
                            const SizedBox(height: 12),
                            Text(
                              "Your matches will show up here. Get swiping on Discover.",
                              textAlign: TextAlign.center,
                              style: CrushapText.body.copyWith(color: CrushapColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.78,
                      ),
                      itemCount: matches.length,
                      itemBuilder: (context, i) {
                        final profile = matches[matches.length - 1 - i];
                        return GestureDetector(
                          onTap: () => onOpenThread(profile),
                          child: Column(
                            children: [
                              CrushapAvatar(name: profile.name, size: CrushapAvatarSize.lg, online: true),
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
            CrushapBottomNav(active: activeTab, onChanged: onTabChanged),
          ],
        ),
      ),
    );
  }
}
