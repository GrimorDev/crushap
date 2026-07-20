import 'package:flutter/material.dart' show RefreshIndicator;
import 'package:flutter/widgets.dart';
import '../models/profile.dart';
import '../services/api_client.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../widgets/core/app_avatar.dart';
import '../widgets/core/app_icon.dart';
import '../widgets/navigation/bottom_nav.dart';

/// The "Chat" bottom-nav tab — a conversation inbox (one row per match,
/// last-message preview from `GET /api/matches`) rather than jumping
/// straight into a single fixed thread.
class ChatInboxScreen extends StatefulWidget {
  const ChatInboxScreen({
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
  State<ChatInboxScreen> createState() => _ChatInboxScreenState();
}

class _ChatInboxScreenState extends State<ChatInboxScreen> {
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
    final matches = _matches;
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
              child: matches == null
                  ? const SizedBox.shrink()
                  : matches.isEmpty
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
                      : RefreshIndicator(
                          onRefresh: _load,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            itemCount: matches.length,
                            separatorBuilder: (context, i) => const SizedBox(height: 2),
                            itemBuilder: (context, i) {
                              final entry = matches[i];
                              final profile = entry.profile;
                              final photoUrl = widget.api.mediaUrl(profile.photos.isNotEmpty ? profile.photos.first : null);
                              final preview = entry.lastMessageText ?? 'Say hi 👋';
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => widget.onOpenThread(profile),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                  child: Row(
                                    children: [
                                      CrushapAvatar(
                                        name: profile.name,
                                        size: CrushapAvatarSize.md,
                                        online: true,
                                        image: photoUrl == null ? null : NetworkImage(photoUrl),
                                      ),
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
            ),
            CrushapBottomNav(active: widget.activeTab, onChanged: widget.onTabChanged),
          ],
        ),
      ),
    );
  }
}
