import 'package:flutter/widgets.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/colors.dart';
import '../../theme/effects.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../widgets/core/app_button.dart';
import '../../widgets/core/app_icon.dart';
import '../../widgets/core/settings_scaffold.dart';

/// Deliberately honest: there's no payment backend behind this yet, so it's
/// framed as a waitlist/preview rather than a working purchase flow — see
/// subscriptionComingSoon copy. Swap in a real paywall once billing exists.
class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _notifyMeRequested = false;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final features = [
      t.subscriptionFeatureUnlimitedLikes,
      t.subscriptionFeatureSeeWhoLikesYou,
      t.subscriptionFeatureRewind,
      t.subscriptionFeatureBoost,
    ];

    return SettingsScaffold(
      title: t.subscriptionTitle,
      backLabel: t.backLabel,
      onBack: widget.onBack,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 72,
                height: 72,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-0.71, -0.71),
                    end: Alignment(0.71, 0.71),
                    colors: [CrushapColors.gold1, CrushapColors.gold2],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Color(0x59FFC145), blurRadius: 32)],
                ),
                child: const CrushapIcon('sparkles', size: 32, color: CrushapColors.black1),
              ),
            ),
            const SizedBox(height: 20),
            Text(t.subscriptionHeadline, textAlign: TextAlign.center, style: CrushapText.displayMd),
            const SizedBox(height: 8),
            Text(
              t.subscriptionSubtitle,
              textAlign: TextAlign.center,
              style: CrushapText.body.copyWith(color: CrushapColors.textSecondary),
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CrushapColors.surfaceElevated,
                borderRadius: BorderRadius.circular(CrushapRadii.lg),
                border: Border.all(color: CrushapColors.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final (i, feature) in features.indexed) ...[
                    if (i > 0) const SizedBox(height: 14),
                    Row(
                      children: [
                        const CrushapIcon('check', size: 16, color: CrushapColors.gold1),
                        const SizedBox(width: 10),
                        Expanded(child: Text(feature, style: CrushapText.body)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              t.subscriptionPrice,
              textAlign: TextAlign.center,
              style: CrushapText.title.copyWith(color: CrushapColors.gold1),
            ),
            const SizedBox(height: 20),
            AnimatedSwitcher(
              duration: CrushapEffects.durNormal,
              child: _notifyMeRequested
                  ? Container(
                      key: const ValueKey('confirmed'),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: CrushapColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(CrushapRadii.pill),
                        border: Border.all(color: CrushapColors.borderSubtle),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CrushapIcon('check', size: 16, color: CrushapColors.green1),
                          const SizedBox(width: 8),
                          Text(t.subscriptionNotifyConfirmed, style: CrushapText.body),
                        ],
                      ),
                    )
                  : CrushapButton(
                      key: const ValueKey('cta'),
                      label: t.subscriptionCta,
                      size: CrushapButtonSize.lg,
                      expand: true,
                      onPressed: () => setState(() => _notifyMeRequested = true),
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              t.subscriptionComingSoon,
              textAlign: TextAlign.center,
              style: CrushapText.bodySm.copyWith(color: CrushapColors.textTertiary),
            ),
          ],
        ),
      ),
    );
  }
}
