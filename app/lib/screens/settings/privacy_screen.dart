import 'package:flutter/widgets.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../models/profile.dart';
import '../../services/api_client.dart';
import '../../services/session.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/core/app_avatar.dart';
import '../../widgets/core/app_icon.dart';
import '../../widgets/core/app_loading.dart';
import '../../widgets/core/settings_scaffold.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key, required this.session, required this.api, required this.onBack});

  final Session session;
  final ApiClient api;
  final VoidCallback onBack;

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  static const _kShowDistance = 'privacy_show_distance';
  static const _kShowOnline = 'privacy_show_online';
  static const _kReadReceipts = 'privacy_read_receipts';

  late bool _showDistance = widget.session.getFlag(_kShowDistance);
  late bool _showOnline = widget.session.getFlag(_kShowOnline);
  late bool _readReceipts = widget.session.getFlag(_kReadReceipts);

  List<Profile>? _blocked;
  final Set<String> _unblocking = {};

  @override
  void initState() {
    super.initState();
    _loadBlocked();
  }

  Future<void> _loadBlocked() async {
    try {
      final blocked = await widget.api.blockedUsers();
      if (mounted) setState(() => _blocked = blocked);
    } catch (_) {
      if (mounted) setState(() => _blocked = const []);
    }
  }

  Future<void> _setShowOnline(bool v) async {
    setState(() => _showOnline = v);
    widget.session.setFlag(_kShowOnline, v);
    try {
      await widget.api.updateMe(showOnlineStatus: v);
    } catch (_) {
      // Best-effort — the local flag still reflects the choice even if the
      // server round-trip failed; toggling again will retry it.
    }
  }

  Future<void> _unblock(String id) async {
    setState(() => _unblocking.add(id));
    try {
      await widget.api.unblockUser(id);
      if (mounted) setState(() => _blocked = _blocked?.where((p) => p.id != id).toList());
    } catch (_) {
      // Leave them listed so the user can retry.
    } finally {
      if (mounted) setState(() => _unblocking.remove(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return SettingsScaffold(
      title: t.privacyTitle,
      backLabel: t.backLabel,
      onBack: widget.onBack,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SettingsToggleRow(
              icon: 'map-pin',
              label: t.privacyShowDistance,
              description: t.privacyShowDistanceDesc,
              value: _showDistance,
              onChanged: (v) {
                setState(() => _showDistance = v);
                widget.session.setFlag(_kShowDistance, v);
              },
            ),
            SettingsToggleRow(
              icon: 'zap',
              label: t.privacyShowOnlineStatus,
              description: t.privacyShowOnlineStatusDesc,
              value: _showOnline,
              onChanged: _setShowOnline,
            ),
            SettingsToggleRow(
              icon: 'check',
              label: t.privacyReadReceipts,
              description: t.privacyReadReceiptsDesc,
              value: _readReceipts,
              onChanged: (v) {
                setState(() => _readReceipts = v);
                widget.session.setFlag(_kReadReceipts, v);
              },
            ),
            const SizedBox(height: 24),
            Text(
              t.privacyBlockedSection.toUpperCase(),
              style: CrushapText.bodySm.copyWith(
                color: CrushapColors.textTertiary,
                letterSpacing: CrushapText.trackingWide * 14,
              ),
            ),
            const SizedBox(height: 12),
            if (_blocked == null)
              const CrushapLoading()
            else if (_blocked!.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: CrushapColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(CrushapRadii.lg),
                  border: Border.all(color: CrushapColors.borderSubtle),
                ),
                child: Row(
                  children: [
                    const CrushapIcon('shield-check', size: 18, color: CrushapColors.textTertiary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        t.privacyNoBlockedUsers,
                        style: CrushapText.bodySm.copyWith(color: CrushapColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: CrushapColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(CrushapRadii.lg),
                  border: Border.all(color: CrushapColors.borderSubtle),
                ),
                child: Column(
                  children: [
                    for (final (i, p) in _blocked!.indexed) ...[
                      if (i > 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(height: 1, color: CrushapColors.borderSubtle),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            CrushapAvatar(
                              name: p.name,
                              size: CrushapAvatarSize.sm,
                              image: widget.api.mediaUrl(p.photos.isNotEmpty ? p.photos.first : null) == null
                                  ? null
                                  : NetworkImage(widget.api.mediaUrl(p.photos.first)!),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(p.name, style: CrushapText.body)),
                            GestureDetector(
                              onTap: _unblocking.contains(p.id) ? null : () => _unblock(p.id),
                              child: Text(
                                t.unblockLabel,
                                style: CrushapText.bodySm.copyWith(color: CrushapColors.accentPrimary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
