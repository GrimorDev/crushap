import 'package:flutter/widgets.dart';
import '../models/chat_message.dart';
import '../models/profile.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../widgets/core/app_avatar.dart';
import '../widgets/core/app_icon.dart';
import '../widgets/navigation/bottom_nav.dart';

/// New — the "Chat" bottom-nav tab. The design system only specified one
/// hardcoded conversation; a real dating app needs a conversation list
/// before you can open one, so this lists every current match with a
/// last-message preview.
class ChatInboxScreen extends StatelessWidget {
  const ChatInboxScreen({
    super.key,
    required this.matches,
    required this.threads,
    required this.onOpenThread,
    required this.activeTab,
    required this.onTabChanged,
  });

  final List<Profile> matches;
  final Map<String, List<ChatMessage>> threads;
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
              child: Center(child: Text('Chat', style: CrushapText.title)),
            ),
            Expanded(
              child: matches.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CrushapIcon('message-circle', size: 32, color: CrushapColors.textTertiary),
                            const SizedBox(height: 12),
                            Text(
                              'No conversations yet. Match with someone on Discover to start chatting.',
                              textAlign: TextAlign.center,
                              style: CrushapText.body.copyWith(color: CrushapColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      itemCount: matches.length,
                      separatorBuilder: (context, i) => const SizedBox(height: 2),
                      itemBuilder: (context, i) {
                        final profile = matches[matches.length - 1 - i];
                        final thread = threads[profile.id] ?? const [];
                        final preview = thread.isEmpty ? 'Say hi 👋' : thread.last.text;
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onOpenThread(profile),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            child: Row(
                              children: [
                                CrushapAvatar(name: profile.name, size: CrushapAvatarSize.md, online: true),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(profile.name, style: CrushapText.body.copyWith(fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 2),
                                      Text(
                                        preview,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: CrushapText.bodySm.copyWith(color: CrushapColors.textTertiary),
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
            CrushapBottomNav(active: activeTab, onChanged: onTabChanged),
          ],
        ),
      ),
    );
  }
}
