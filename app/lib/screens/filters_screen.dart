import 'package:flutter/widgets.dart';
import '../l10n/gen/app_localizations.dart';
import '../theme/colors.dart';
import '../theme/effects.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';
import '../widgets/core/app_button.dart';
import '../widgets/core/app_chip.dart';
import '../widgets/core/app_icon.dart';
import '../widgets/core/app_icon_button.dart';
import '../widgets/core/app_switch.dart';

/// Ported from ui_kits/dating-app/FiltersScreen.jsx. The distance/age
/// sliders and the verified-only toggle are hand-rolled in the source
/// (plain `<input type="range">` / a raw div), not shared design-system
/// components, so they stay private to this screen here too.
class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  double _maxAge = 35;
  double _distance = 25;
  int _showMe = 2; // 0 Women, 1 Men, 2 Everyone
  bool _verifiedOnly = true;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final genders = [t.genderWomen, t.genderMen, t.genderEveryone];
    return ColoredBox(
      color: CrushapColors.surfaceApp,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: CrushapColors.borderSubtle)),
              ),
              child: Row(
                children: [
                  CrushapIconButton(
                    icon: 'arrow-left',
                    label: t.backLabel,
                    variant: CrushapIconButtonVariant.ghost,
                    onPressed: widget.onClose,
                  ),
                  const SizedBox(width: 12),
                  Text(t.filtersLabel, style: CrushapText.title),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _FilterRow(
                      label: t.maximumDistance,
                      value: t.distanceValueKm(_distance.round()),
                      child: _CrushapSlider(
                        min: 1,
                        max: 100,
                        value: _distance,
                        onChanged: (v) => setState(() => _distance = v),
                      ),
                    ),
                    const SizedBox(height: 28),
                    _FilterRow(
                      label: t.ageRange,
                      value: t.ageRangeValue(_maxAge.round()),
                      child: _CrushapSlider(
                        min: 18,
                        max: 60,
                        value: _maxAge,
                        onChanged: (v) => setState(() => _maxAge = v),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(t.showMe, style: CrushapText.body),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        for (final (i, g) in genders.indexed) ...[
                          if (i > 0) const SizedBox(width: 8),
                          CrushapChip(label: g, selected: i == _showMe, onTap: () => setState(() => _showMe = i)),
                        ],
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CrushapIcon('shield-check', size: 18, color: CrushapColors.green1),
                            const SizedBox(width: 8),
                            Text(t.verifiedProfilesOnly, style: CrushapText.body),
                          ],
                        ),
                        CrushapSwitch(
                          value: _verifiedOnly,
                          onChanged: (v) => setState(() => _verifiedOnly = v),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: CrushapButton(
                label: t.applyFilters,
                size: CrushapButtonSize.lg,
                expand: true,
                onPressed: widget.onClose,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.label, required this.value, required this.child});
  final String label;
  final String value;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: CrushapText.body),
            Text(value, style: CrushapText.body.copyWith(color: CrushapColors.accentPrimary)),
          ],
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class _CrushapSlider extends StatelessWidget {
  const _CrushapSlider({
    required this.min,
    required this.max,
    required this.value,
    required this.onChanged,
  });

  final double min;
  final double max;
  final double value;
  final ValueChanged<double> onChanged;

  void _handle(BuildContext context, Offset local, double width) {
    final fraction = (local.dx / width).clamp(0.0, 1.0);
    onChanged(min + fraction * (max - min));
  }

  @override
  Widget build(BuildContext context) {
    final fraction = ((value - min) / (max - min)).clamp(0.0, 1.0);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (d) => _handle(context, d.localPosition, width),
          onHorizontalDragUpdate: (d) => _handle(context, d.localPosition, width),
          child: SizedBox(
            height: 24,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: CrushapColors.surfaceCard,
                    borderRadius: BorderRadius.circular(CrushapRadii.pill),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: fraction,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: CrushapColors.accentPrimary,
                      borderRadius: BorderRadius.circular(CrushapRadii.pill),
                    ),
                  ),
                ),
                Positioned(
                  left: (width - 20) * fraction,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      shape: BoxShape.circle,
                      boxShadow: CrushapEffects.shadowCard,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
