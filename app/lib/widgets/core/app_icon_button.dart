import 'package:flutter/widgets.dart';
import '../../theme/colors.dart';
import '../../theme/effects.dart';
import 'app_icon.dart';

enum CrushapIconButtonVariant { filled, outline, ghost, surface }

enum CrushapIconButtonSize { sm, md, lg }

/// Ported from components/core/IconButton.jsx.
class CrushapIconButton extends StatefulWidget {
  const CrushapIconButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.size = CrushapIconButtonSize.md,
    this.variant = CrushapIconButtonVariant.outline,
  });

  final String icon;
  final String label;
  final VoidCallback? onPressed;
  final CrushapIconButtonSize size;
  final CrushapIconButtonVariant variant;

  @override
  State<CrushapIconButton> createState() => _CrushapIconButtonState();
}

class _CrushapIconButtonState extends State<CrushapIconButton> {
  bool _pressed = false;

  double get _px => switch (widget.size) {
        CrushapIconButtonSize.sm => 36,
        CrushapIconButtonSize.md => 44,
        CrushapIconButtonSize.lg => 56,
      };

  Color get _fg => switch (widget.variant) {
        CrushapIconButtonVariant.filled => const Color(0xFFFFFFFF),
        CrushapIconButtonVariant.outline => CrushapColors.textPrimary,
        CrushapIconButtonVariant.ghost => CrushapColors.textPrimary,
        CrushapIconButtonVariant.surface => CrushapColors.textPrimary,
      };

  BoxDecoration get _decoration {
    switch (widget.variant) {
      case CrushapIconButtonVariant.filled:
        return BoxDecoration(
          gradient: CrushapColors.gradientPrimary,
          shape: BoxShape.circle,
          boxShadow: CrushapEffects.shadowGlowPrimary,
        );
      case CrushapIconButtonVariant.outline:
        return BoxDecoration(
          color: CrushapColors.surfaceElevated,
          shape: BoxShape.circle,
          border: Border.all(color: CrushapColors.borderStrong),
        );
      case CrushapIconButtonVariant.ghost:
        return const BoxDecoration(
          color: Color(0x0FFFFFFF), // rgba(255,255,255,.06)
          shape: BoxShape.circle,
        );
      case CrushapIconButtonVariant.surface:
        return BoxDecoration(
          color: CrushapColors.surfaceCard,
          shape: BoxShape.circle,
          border: Border.all(color: CrushapColors.borderSubtle),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final px = _px;
    return Semantics(
      label: widget.label,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: widget.onPressed == null ? null : (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _pressed ? 0.94 : 1,
          duration: CrushapEffects.durFast,
          curve: CrushapEffects.easeSpring,
          child: Container(
            width: px,
            height: px,
            alignment: Alignment.center,
            decoration: _decoration,
            child: CrushapIcon(widget.icon, size: (px * 0.45).roundToDouble(), color: _fg),
          ),
        ),
      ),
    );
  }
}
