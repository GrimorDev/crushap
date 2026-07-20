import 'package:flutter/material.dart' show TextField, InputDecoration, InputBorder, TextInputAction;
import 'package:flutter/widgets.dart';
import '../models/chat_message.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';
import '../widgets/core/app_avatar.dart';
import '../widgets/core/app_icon.dart';
import '../widgets/core/app_icon_button.dart';

/// Ported from ui_kits/dating-app/ChatScreen.jsx, now a single conversation
/// thread reached from ChatInboxScreen or MatchOverlay's "Send a Message"
/// (pushed as a route, like FiltersScreen — hence the back arrow instead of
/// the bottom nav). Message history is per-match: seeded from whatever the
/// caller already has stored, and mirrored back up via [onSend] so the
/// inbox's last-message preview and re-opening the thread stay in sync.
class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.matchName,
    required this.initialMessages,
    required this.onSend,
    required this.onBack,
  });

  final String matchName;
  final List<ChatMessage> initialMessages;
  final ValueChanged<ChatMessage> onSend;
  final VoidCallback onBack;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final List<ChatMessage> _messages = List.of(widget.initialMessages);
  final _draftController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _draftController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _draftController.text.trim();
    if (text.isEmpty) return;
    final message = ChatMessage(fromMe: true, text: text);
    setState(() {
      _messages.add(message);
      _draftController.clear();
    });
    widget.onSend(message);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: CrushapColors.surfaceApp,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: CrushapColors.borderSubtle)),
              ),
              child: Row(
                children: [
                  CrushapIconButton(
                    icon: 'arrow-left',
                    label: 'Back',
                    variant: CrushapIconButtonVariant.ghost,
                    onPressed: widget.onBack,
                  ),
                  const SizedBox(width: 4),
                  CrushapAvatar(name: widget.matchName, size: CrushapAvatarSize.sm, online: true),
                  const SizedBox(width: 12),
                  Text(widget.matchName, style: CrushapText.title),
                ],
              ),
            ),
            Expanded(
              child: _messages.isEmpty
                  ? _EmptyThread(matchName: widget.matchName)
                  : ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(20),
                      itemCount: _messages.length,
                      separatorBuilder: (context, i) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final m = _messages[i];
                        return Align(
                          alignment: m.fromMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                gradient: m.fromMe ? CrushapColors.gradientPrimary : null,
                                color: m.fromMe ? null : CrushapColors.surfaceCard,
                                borderRadius: BorderRadius.circular(CrushapRadii.lg),
                              ),
                              child: Text(
                                m.text,
                                style: CrushapText.body.copyWith(
                                  color: m.fromMe ? const Color(0xFFFFFFFF) : CrushapColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: CrushapColors.borderSubtle)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      decoration: BoxDecoration(
                        color: CrushapColors.surfaceElevated,
                        border: Border.all(color: CrushapColors.borderSubtle),
                        borderRadius: BorderRadius.circular(CrushapRadii.pill),
                      ),
                      child: TextField(
                        controller: _draftController,
                        style: CrushapText.body.copyWith(color: CrushapColors.textPrimary),
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: 'Send a message',
                          hintStyle: CrushapText.body.copyWith(color: CrushapColors.textTertiary),
                        ),
                        onSubmitted: (_) => _send(),
                        textInputAction: TextInputAction.send,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CrushapIconButton(
                    icon: 'send',
                    label: 'Send',
                    variant: CrushapIconButtonVariant.filled,
                    onPressed: _send,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyThread extends StatelessWidget {
  const _EmptyThread({required this.matchName});
  final String matchName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CrushapIcon('message-circle', size: 32, color: CrushapColors.textTertiary),
            const SizedBox(height: 12),
            Text(
              'You matched with $matchName. Say hi 👋',
              textAlign: TextAlign.center,
              style: CrushapText.body.copyWith(color: CrushapColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
