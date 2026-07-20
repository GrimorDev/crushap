import 'package:flutter/widgets.dart';
import '../models/profile.dart';
import '../theme/colors.dart';
import '../theme/effects.dart';
import '../theme/typography.dart';
import '../widgets/core/app_icon_button.dart';
import '../widgets/dating/swipe_card.dart';
import '../widgets/navigation/bottom_nav.dart';

enum _SwipeAction { pass, superlike, like }

/// Ported from ui_kits/dating-app/DiscoverScreen.jsx.
///
/// The prototype only advanced cards via the pass/superlike/like buttons;
/// this adds a matching drag-to-swipe gesture on the card itself (the
/// component is literally named SwipeCard) while keeping the same visuals,
/// button set, and per-action outcomes (superlike also opens the match
/// overlay, since gold is the app's "premium/superlike" semantic).
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({
    super.key,
    required this.onMatch,
    required this.onOpenFilters,
    required this.activeTab,
    required this.onTabChanged,
  });

  final ValueChanged<Profile> onMatch;
  final VoidCallback onOpenFilters;
  final CrushapNavTab activeTab;
  final ValueChanged<CrushapNavTab> onTabChanged;

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  int _idx = 0;
  Offset _drag = Offset.zero;
  Duration _animDuration = Duration.zero;
  VoidCallback? _pendingAfterAnim;

  Profile get _current => sampleProfiles[_idx % sampleProfiles.length];

  void _advance(bool matched) {
    if (matched) widget.onMatch(_current);
    setState(() {
      _idx++;
      _drag = Offset.zero;
      _animDuration = Duration.zero;
    });
  }

  void _fly(_SwipeAction action) {
    final matched = action != _SwipeAction.pass;
    late final Offset target;
    switch (action) {
      case _SwipeAction.pass:
        target = const Offset(-560, 0);
      case _SwipeAction.like:
        target = const Offset(560, 0);
      case _SwipeAction.superlike:
        target = const Offset(0, -640);
    }
    setState(() {
      _animDuration = CrushapEffects.durSlow;
      _drag = target;
      _pendingAfterAnim = () => _advance(matched);
    });
  }

  void _onPanUpdate(DragUpdateDetails d) {
    setState(() {
      _animDuration = Duration.zero;
      _drag += d.delta;
    });
  }

  void _onPanEnd(DragEndDetails d) {
    const threshold = 110.0;
    if (_drag.dx.abs() > threshold) {
      _fly(_drag.dx > 0 ? _SwipeAction.like : _SwipeAction.pass);
    } else {
      setState(() {
        _animDuration = CrushapEffects.durNormal;
        _drag = Offset.zero;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final angle = (_drag.dx / 300).clamp(-0.5, 0.5);
    return ColoredBox(
      color: CrushapColors.surfaceApp,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 52,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text('Discover', style: CrushapText.title),
                  Positioned(
                    right: 8,
                    child: CrushapIconButton(
                      icon: 'sliders-horizontal',
                      label: 'Filters',
                      size: CrushapIconButtonSize.sm,
                      variant: CrushapIconButtonVariant.ghost,
                      onPressed: widget.onOpenFilters,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: AnimatedContainer(
                    duration: _animDuration,
                    curve: CrushapEffects.easeStandard,
                    transformAlignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..translateByDouble(_drag.dx, _drag.dy, 0, 1)
                      ..rotateZ(angle),
                    onEnd: () {
                      final cb = _pendingAfterAnim;
                      _pendingAfterAnim = null;
                      cb?.call();
                    },
                    child: CrushapSwipeCard(
                      key: ValueKey(_idx),
                      name: _current.name,
                      age: _current.age,
                      distance: _current.distance,
                      verified: _current.verified,
                      bio: _current.bio,
                      tags: _current.tags,
                      width: 340,
                      height: 440,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CrushapIconButton(
                    icon: 'x',
                    label: 'Pass',
                    variant: CrushapIconButtonVariant.outline,
                    size: CrushapIconButtonSize.lg,
                    onPressed: () => _fly(_SwipeAction.pass),
                  ),
                  const SizedBox(width: 20),
                  CrushapIconButton(
                    icon: 'star',
                    label: 'Superlike',
                    variant: CrushapIconButtonVariant.surface,
                    onPressed: () => _fly(_SwipeAction.superlike),
                  ),
                  const SizedBox(width: 20),
                  CrushapIconButton(
                    icon: 'heart',
                    label: 'Like',
                    variant: CrushapIconButtonVariant.filled,
                    size: CrushapIconButtonSize.lg,
                    onPressed: () => _fly(_SwipeAction.like),
                  ),
                ],
              ),
            ),
            CrushapBottomNav(active: widget.activeTab, onChanged: widget.onTabChanged),
          ],
        ),
      ),
    );
  }
}
