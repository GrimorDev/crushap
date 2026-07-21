import 'package:flutter/widgets.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../services/session.dart';
import '../../widgets/core/settings_scaffold.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key, required this.session, required this.onBack});

  final Session session;
  final VoidCallback onBack;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const _kMatches = 'notify_matches';
  static const _kMessages = 'notify_messages';
  static const _kLikes = 'notify_likes';
  static const _kAppUpdates = 'notify_app_updates';

  late bool _matches = widget.session.getFlag(_kMatches);
  late bool _messages = widget.session.getFlag(_kMessages);
  late bool _likes = widget.session.getFlag(_kLikes);
  late bool _appUpdates = widget.session.getFlag(_kAppUpdates, defaultValue: false);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return SettingsScaffold(
      title: t.notificationsTitle,
      backLabel: t.backLabel,
      onBack: widget.onBack,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SettingsToggleRow(
              icon: 'heart',
              label: t.notificationsNewMatches,
              description: t.notificationsNewMatchesDesc,
              value: _matches,
              onChanged: (v) {
                setState(() => _matches = v);
                widget.session.setFlag(_kMatches, v);
              },
            ),
            SettingsToggleRow(
              icon: 'message-circle',
              label: t.notificationsNewMessages,
              description: t.notificationsNewMessagesDesc,
              value: _messages,
              onChanged: (v) {
                setState(() => _messages = v);
                widget.session.setFlag(_kMessages, v);
              },
            ),
            SettingsToggleRow(
              icon: 'star',
              label: t.notificationsLikes,
              description: t.notificationsLikesDesc,
              value: _likes,
              onChanged: (v) {
                setState(() => _likes = v);
                widget.session.setFlag(_kLikes, v);
              },
            ),
            SettingsToggleRow(
              icon: 'sparkles',
              label: t.notificationsAppUpdates,
              description: t.notificationsAppUpdatesDesc,
              value: _appUpdates,
              onChanged: (v) {
                setState(() => _appUpdates = v);
                widget.session.setFlag(_kAppUpdates, v);
              },
            ),
          ],
        ),
      ),
    );
  }
}
