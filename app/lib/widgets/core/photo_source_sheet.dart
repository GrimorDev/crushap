import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/colors.dart';
import '../../theme/effects.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import 'app_icon.dart';

/// Camera vs. gallery picker, styled to match the rest of the app (no
/// Material bottom sheet chrome) — `showGeneralDialog` is the lower-level
/// API Material's own sheets/dialogs build on, so this stays dependency-free.
Future<ImageSource?> showPhotoSourceSheet(BuildContext context) {
  return showGeneralDialog<ImageSource>(
    context: context,
    barrierLabel: 'Choose photo source',
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
          child: const _PhotoSourceSheet(),
        ),
      );
    },
  );
}

class _PhotoSourceSheet extends StatelessWidget {
  const _PhotoSourceSheet();

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
              icon: 'camera',
              label: t.takeAPhoto,
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            const _Divider(height: 1, color: CrushapColors.borderSubtle),
            _Option(
              icon: 'image',
              label: t.chooseFromGallery,
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
            const _Divider(height: 1, color: CrushapColors.borderSubtle),
            _Option(
              icon: 'x',
              label: t.cancelLabel,
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({required this.icon, required this.label, required this.onTap});

  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            CrushapIcon(icon, size: 20, color: CrushapColors.textPrimary),
            const SizedBox(width: 14),
            Text(label, style: CrushapText.body),
          ],
        ),
      ),
    );
  }
}

// _Divider isn't part of flutter/widgets.dart; a one-line box is simpler
// than importing material.dart just for this.
class _Divider extends StatelessWidget {
  const _Divider({this.height = 16, this.color = CrushapColors.borderSubtle});
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height, child: Center(child: Container(height: 1, color: color)));
  }
}
