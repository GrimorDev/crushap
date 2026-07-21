import 'package:flutter/widgets.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../services/session.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/core/app_icon.dart';
import '../../widgets/core/settings_scaffold.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key, required this.session, required this.onBack});

  final Session session;
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
              onChanged: (v) {
                setState(() => _showOnline = v);
                widget.session.setFlag(_kShowOnline, v);
              },
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
            ),
          ],
        ),
      ),
    );
  }
}
