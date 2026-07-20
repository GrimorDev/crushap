import 'package:flutter/material.dart' show TextField, InputDecoration, InputBorder, TextInputAction;
import 'package:flutter/widgets.dart';
import '../../theme/colors.dart';
import '../../theme/effects.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

/// Ported from components/forms/Input.jsx.
class CrushapInput extends StatefulWidget {
  const CrushapInput({
    super.key,
    this.placeholder,
    this.controller,
    this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
  });

  final String? placeholder;
  final TextEditingController? controller;
  final Widget? icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;

  @override
  State<CrushapInput> createState() => _CrushapInputState();
}

class _CrushapInputState extends State<CrushapInput> {
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() => _focused = _focusNode.hasFocus));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: CrushapEffects.durNormal,
      curve: CrushapEffects.easeStandard,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: CrushapColors.surfaceElevated,
        borderRadius: BorderRadius.circular(CrushapRadii.md),
        border: Border.all(
          color: _focused ? CrushapColors.accentPrimary : CrushapColors.borderSubtle,
        ),
        boxShadow: _focused
            ? [BoxShadow(color: CrushapColors.accentGlow, blurRadius: 0, spreadRadius: 4)]
            : null,
      ),
      child: Row(
        children: [
          if (widget.icon != null) ...[
            IconTheme(
              data: const IconThemeData(color: CrushapColors.textTertiary),
              child: widget.icon!,
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              style: CrushapText.body.copyWith(color: CrushapColors.textPrimary),
              cursorColor: CrushapColors.accentPrimary,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              textInputAction: widget.textInputAction,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: widget.placeholder,
                hintStyle: CrushapText.body.copyWith(color: CrushapColors.textTertiary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
