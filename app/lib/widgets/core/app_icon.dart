import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Ported from components/core/Icon.jsx — masks a Lucide SVG (assets/icons/)
/// with a solid color, mirroring the CSS `mask-image` + `background-color`
/// technique used in the web design system.
class CrushapIcon extends StatelessWidget {
  const CrushapIcon(this.name, {super.key, this.size = 20, this.color});

  final String name;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tint = color ?? DefaultTextStyle.of(context).style.color ?? const Color(0xFFFFFFFF);
    return SvgPicture.asset(
      'assets/icons/$name.svg',
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(tint, BlendMode.srcIn),
    );
  }
}
