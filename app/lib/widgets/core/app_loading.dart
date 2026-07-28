import 'package:flutter/material.dart' show CircularProgressIndicator;
import 'package:flutter/widgets.dart';
import '../../theme/colors.dart';

/// The app's one loading indicator. No screen showed any feedback during
/// its first fetch before this — a blank `SizedBox.shrink()` while the
/// network round-trip is in flight reads as "the app is broken", not
/// "the app is loading". Centered by default since every call site so far
/// fills the space where a list/card would otherwise be.
class CrushapLoading extends StatelessWidget {
  const CrushapLoading({super.key, this.size = 28});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation(CrushapColors.accentPrimary),
        ),
      ),
    );
  }
}
