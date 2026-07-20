import 'package:flutter/material.dart' show TextField, InputDecoration, InputBorder, TextInputAction;
import 'package:flutter/widgets.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';
import '../widgets/core/app_avatar.dart';
import '../widgets/core/app_icon_button.dart';
import '../widgets/navigation/bottom_nav.dart';

class _Message {
  const _Message(this.fromMe, this.text);
  final bool fromMe;
  final String text;
}

/// Ported from ui_kits/dating-app/ChatScreen.jsx.
class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.matchName,
    required this.activeTab,
    required this.onTabChanged,
  });

  final String matchName;
  final CrushapNavTab activeTab;
  final ValueChanged<CrushapNavTab> onTabChanged;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messages = [
    const _Message(false, 'Hey! Your hiking photos are amazing 😄'),
    const _Message(true, "Ha thanks! That was Half Dome, brutal but worth it"),
    const _Message(false, "Ok that's officially a date idea"),
  ];
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
    setState(() {
      _messages.add(_Message(true, text));
      _draftController.clear();
    });
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: CrushapColors.borderSubtle)),
              ),
              child: Row(
                children: [
                  CrushapAvatar(name: widget.matchName, size: CrushapAvatarSize.sm, online: true),
                  const SizedBox(width: 12),
                  Text(widget.matchName, style: CrushapText.title),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
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
            CrushapBottomNav(active: widget.activeTab, onChanged: widget.onTabChanged),
          ],
        ),
      ),
    );
  }
}
