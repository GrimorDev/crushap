import 'package:flutter/widgets.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/colors.dart';
import '../../theme/effects.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import 'app_icon.dart';

enum ProfileAction { block, report }

/// The block/report menu opened from a profile's "more options" button —
/// styled to match the app's other bottom sheets (photo source, language),
/// not Material's.
Future<ProfileAction?> showProfileActionSheet(BuildContext context, {required String name}) {
  return showGeneralDialog<ProfileAction>(
    context: context,
    barrierLabel: 'Profile actions',
    barrierDismissible: true,
    barrierColor: CrushapColors.overlayScrim,
    transitionDuration: CrushapEffects.durNormal,
    pageBuilder: (context, animation, secondaryAnimation) => const SizedBox.shrink(),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: CrushapEffects.easeStandard);
      return Align(
        alignment: Alignment.bottomCenter,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(curved),
          child: _ProfileActionSheet(name: name),
        ),
      );
    },
  );
}

/// Reason picker shown after choosing "Report" — returns one of
/// 'spam' / 'inappropriate' / 'fake_profile' / 'other', or null if
/// dismissed.
Future<String?> showReportReasonSheet(BuildContext context) {
  return showGeneralDialog<String>(
    context: context,
    barrierLabel: 'Report reason',
    barrierDismissible: true,
    barrierColor: CrushapColors.overlayScrim,
    transitionDuration: CrushapEffects.durNormal,
    pageBuilder: (context, animation, secondaryAnimation) => const SizedBox.shrink(),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: CrushapEffects.easeStandard);
      return Align(
        alignment: Alignment.bottomCenter,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(curved),
          child: const _ReportReasonSheet(),
        ),
      );
    },
  );
}

class _ProfileActionSheet extends StatelessWidget {
  const _ProfileActionSheet({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: CrushapColors.surfaceElevated,
          borderRadius: BorderRadius.circular(CrushapRadii.lg),
          border: Border.all(color: CrushapColors.borderSubtle),
          boxShadow: CrushapEffects.shadowModal,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Option(
              icon: 'shield-check',
              label: t.reportUserAction(name),
              onTap: () => Navigator.of(context).pop(ProfileAction.report),
            ),
            const _Divider(height: 1, color: CrushapColors.borderSubtle),
            _Option(
              icon: 'x',
              label: t.blockUserAction(name),
              color: CrushapColors.red1,
              onTap: () => Navigator.of(context).pop(ProfileAction.block),
            ),
            const _Divider(height: 1, color: CrushapColors.borderSubtle),
            _Option(icon: 'x', label: t.cancelLabel, onTap: () => Navigator.of(context).pop()),
          ],
        ),
      ),
    );
  }
}

class _ReportReasonSheet extends StatelessWidget {
  const _ReportReasonSheet();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        decoration: BoxDecoration(
          color: CrushapColors.surfaceElevated,
          borderRadius: BorderRadius.circular(CrushapRadii.lg),
          border: Border.all(color: CrushapColors.borderSubtle),
          boxShadow: CrushapEffects.shadowModal,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.reportReasonTitle, style: CrushapText.title),
            const SizedBox(height: 4),
            for (final (reason, label) in [
              ('spam', t.reportReasonSpam),
              ('inappropriate', t.reportReasonInappropriate),
              ('fake_profile', t.reportReasonFakeProfile),
              ('other', t.reportReasonOther),
            ]) ...[
              const _Divider(height: 1, color: CrushapColors.borderSubtle),
              _Option(icon: 'sparkles', label: label, onTap: () => Navigator.of(context).pop(reason)),
            ],
            const _Divider(height: 1, color: CrushapColors.borderSubtle),
            _Option(icon: 'x', label: t.cancelLabel, onTap: () => Navigator.of(context).pop()),
          ],
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({required this.icon, required this.label, required this.onTap, this.color});

  final String icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final fg = color ?? CrushapColors.textPrimary;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            CrushapIcon(icon, size: 20, color: fg),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: CrushapText.body.copyWith(color: fg))),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({this.height = 16, this.color = CrushapColors.borderSubtle});
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height, child: Center(child: Container(height: 1, color: color)));
  }
}
