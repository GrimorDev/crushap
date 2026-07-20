import 'package:flutter/material.dart' show TextField, InputDecoration, InputBorder, TextInputAction;
import 'package:flutter/widgets.dart';
import '../l10n/gen/app_localizations.dart';
import '../models/chat_message.dart';
import '../services/api_client.dart';
import '../services/chat_socket.dart';
import '../services/session.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';
import '../widgets/core/app_avatar.dart';
import '../widgets/core/app_icon.dart';
import '../widgets/core/app_icon_button.dart';

/// A single conversation thread, reached from ChatInboxScreen or
/// MatchOverlay's "Send a Message" (pushed as a route, like FiltersScreen —
/// hence the back arrow instead of the bottom nav). History loads over
/// REST; new messages arrive live over a dedicated WebSocket connection
/// (see server/README.md).
class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.session,
    required this.api,
    required this.matchId,
    required this.matchName,
    required this.matchPhotoUrl,
    required this.onBack,
  });

  final Session session;
  final ApiClient api;
  final String matchId;
  final String matchName;
  final String? matchPhotoUrl;
  final VoidCallback onBack;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatMessage>? _messages;
  ChatSocket? _socket;
  final _draftController = TextEditingController();
  final _scrollController = ScrollController();

  String get _myId => widget.session.userId!;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final history = await widget.api.chatHistory(widget.matchId);
      if (!mounted) return;
      setState(() => _messages = history);
    } catch (_) {
      if (mounted) setState(() => _messages = const []);
    }
    final socket = ChatSocket.connect(widget.session, matchId: widget.matchId);
    socket.messages.listen((m) {
      if (!mounted) return;
      setState(() => _messages = [...?_messages, m]);
      _scrollToBottom();
    });
    _socket = socket;
  }

  @override
  void dispose() {
    _draftController.dispose();
    _scrollController.dispose();
    _socket?.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  void _send() {
    final text = _draftController.text.trim();
    if (text.isEmpty) return;
    _socket?.send(text);
    _draftController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final messages = _messages;
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
                    label: t.backLabel,
                    variant: CrushapIconButtonVariant.ghost,
                    onPressed: widget.onBack,
                  ),
                  const SizedBox(width: 4),
                  CrushapAvatar(
                    name: widget.matchName,
                    size: CrushapAvatarSize.sm,
                    online: true,
                    image: widget.matchPhotoUrl == null ? null : NetworkImage(widget.matchPhotoUrl!),
                  ),
                  const SizedBox(width: 12),
                  Text(widget.matchName, style: CrushapText.title),
                ],
              ),
            ),
            Expanded(
              child: messages == null
                  ? const SizedBox.shrink()
                  : messages.isEmpty
                      ? _EmptyThread(matchName: widget.matchName, t: t)
                      : ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(20),
                          itemCount: messages.length,
                          separatorBuilder: (context, i) => const SizedBox(height: 10),
                          itemBuilder: (context, i) {
                            final m = messages[i];
                            final mine = m.isFromMe(_myId);
                            return Align(
                              alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    gradient: mine ? CrushapColors.gradientPrimary : null,
                                    color: mine ? null : CrushapColors.surfaceCard,
                                    borderRadius: BorderRadius.circular(CrushapRadii.lg),
                                  ),
                                  child: Text(
                                    m.text,
                                    style: CrushapText.body.copyWith(
                                      color: mine ? const Color(0xFFFFFFFF) : CrushapColors.textPrimary,
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
                          hintText: t.sendMessagePlaceholder,
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
                    label: t.sendLabel,
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
  const _EmptyThread({required this.matchName, required this.t});
  final String matchName;
  final AppLocalizations t;

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
              t.matchedEmptyState(matchName),
              textAlign: TextAlign.center,
              style: CrushapText.body.copyWith(color: CrushapColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
