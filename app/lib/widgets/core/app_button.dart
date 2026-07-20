import 'package:flutter/widgets.dart';
import '../../theme/colors.dart';
import '../../theme/effects.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

enum CrushapButtonVariant { primary, secondary, ghost }

enum CrushapButtonSize { sm, md, lg }

/// Ported from components/core/Button.jsx.
class CrushapButton extends StatefulWidget {
  const CrushapButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = CrushapButtonVariant.primary,
    this.size = CrushapButtonSize.md,
    this.icon,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final CrushapButtonVariant variant;
  final CrushapButtonSize size;
  final Widget? icon;
  final bool expand;

  @override
  State<CrushapButton> createState() => _CrushapButtonState();
}

class _CrushapButtonState extends State<CrushapButton> {
  bool _pressed = false;

  bool get _disabled => widget.onPressed == null;

  EdgeInsets get _padding => switch (widget.size) {
        CrushapButtonSize.sm => const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        CrushapButtonSize.md => const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
        CrushapButtonSize.lg => const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
      };

  double get _gap => switch (widget.size) {
        CrushapButtonSize.sm => 6,
        CrushapButtonSize.md => 8,
        CrushapButtonSize.lg => 10,
      };

  TextStyle get _textStyle {
    final base = switch (widget.size) {
      CrushapButtonSize.sm => CrushapText.bodySm,
      CrushapButtonSize.md => CrushapText.body,
      CrushapButtonSize.lg => CrushapText.bodyLg,
    };
    return base.copyWith(fontWeight: FontWeight.w600, color: _fg);
  }

  Color get _fg => switch (widget.variant) {
        CrushapButtonVariant.primary => CrushapColors.textPrimary,
        CrushapButtonVariant.secondary => CrushapColors.textPrimary,
        CrushapButtonVariant.ghost => CrushapColors.textSecondary,
      };

  BoxDecoration get _decoration {
    switch (widget.variant) {
      case CrushapButtonVariant.primary:
        return BoxDecoration(
          gradient: CrushapColors.gradientPrimary,
          borderRadius: BorderRadius.circular(CrushapRadii.pill),
          boxShadow: _disabled ? null : CrushapEffects.shadowGlowPrimary,
        );
      case CrushapButtonVariant.secondary:
        return BoxDecoration(
          color: CrushapColors.surfaceElevated,
          borderRadius: BorderRadius.circular(CrushapRadii.pill),
          border: Border.all(color: CrushapColors.borderStrong),
        );
      case CrushapButtonVariant.ghost:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(CrushapRadii.pill),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[widget.icon!, SizedBox(width: _gap)],
        Flexible(
          child: Text(
            widget.label,
            style: _textStyle,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    return Opacity(
      opacity: _disabled ? 0.4 : 1,
      child: MouseRegion(
        cursor: _disabled ? MouseCursor.defer : SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _disabled ? null : (_) => setState(() => _pressed = true),
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: (_) => setState(() => _pressed = false),
          onTap: _disabled ? null : widget.onPressed,
          child: AnimatedScale(
            scale: _pressed ? 0.96 : 1,
            duration: CrushapEffects.durFast,
            curve: CrushapEffects.easeStandard,
            child: AnimatedContainer(
              duration: CrushapEffects.durNormal,
              curve: CrushapEffects.easeStandard,
              width: widget.expand ? double.infinity : null,
              padding: _padding,
              decoration: _decoration,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
