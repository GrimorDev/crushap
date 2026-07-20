import 'package:flutter/widgets.dart';
import '../models/profile.dart';
import '../theme/colors.dart';
import '../theme/effects.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';
import '../widgets/core/app_button.dart';
import '../widgets/core/app_icon.dart';
import '../widgets/core/app_icon_button.dart';
import '../widgets/dating/swipe_card.dart';
import '../widgets/navigation/bottom_nav.dart';

enum _SwipeAction { pass, superlike, like }

/// Ported from ui_kits/dating-app/DiscoverScreen.jsx.
///
/// The prototype only advanced cards via the pass/superlike/like buttons;
/// this adds a matching drag-to-swipe gesture on the card itself (the
/// component is literally named SwipeCard), a LIKE/NOPE/SUPER LIKE stamp
/// that fades in as you drag, an undo (the `undo-2` icon was already part
/// of the copied Lucide set but unused), and a reassuring end-of-deck state
/// once you've been through the whole sample pool once. Superlike also
/// opens the match overlay, since gold is the app's "premium/superlike"
/// semantic.
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
  int _seenCount = 0;
  bool _allSeen = false;
  Offset _drag = Offset.zero;
  Duration _animDuration = Duration.zero;
  VoidCallback? _pendingAfterAnim;

  Profile get _current => sampleProfiles[_idx % sampleProfiles.length];
  bool get _canUndo => _idx > 0;

  void _advance(bool matched) {
    if (matched) widget.onMatch(_current);
    setState(() {
      _idx++;
      _seenCount++;
      _drag = Offset.zero;
      _animDuration = Duration.zero;
      if (_seenCount >= sampleProfiles.length) _allSeen = true;
    });
  }

  void _undo() {
    if (!_canUndo) return;
    setState(() {
      _idx--;
      _seenCount = (_seenCount - 1).clamp(0, sampleProfiles.length);
      _allSeen = false;
      _drag = Offset.zero;
      _animDuration = Duration.zero;
    });
  }

  void _keepBrowsing() => setState(() {
        _seenCount = 0;
        _allSeen = false;
      });

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
    if (_drag.dy < -threshold && _drag.dy.abs() > _drag.dx.abs()) {
      _fly(_SwipeAction.superlike);
    } else if (_drag.dx.abs() > threshold) {
      _fly(_drag.dx > 0 ? _SwipeAction.like : _SwipeAction.pass);
    } else {
      setState(() {
        _animDuration = CrushapEffects.durNormal;
        _drag = Offset.zero;
      });
    }
  }

  ({String label, Color color, Alignment align})? get _stamp {
    const start = 36.0;
    if (_drag.dy < -start && _drag.dy.abs() > _drag.dx.abs()) {
      return (label: 'SUPER LIKE', color: CrushapColors.actionSuperlike, align: Alignment.topCenter);
    }
    if (_drag.dx > start) {
      return (label: 'LIKE', color: CrushapColors.actionLike, align: Alignment.topRight);
    }
    if (_drag.dx < -start) {
      return (label: 'NOPE', color: CrushapColors.actionPass, align: Alignment.topLeft);
    }
    return null;
  }

  double get _stampOpacity {
    final dist = _drag.dy.abs() > _drag.dx.abs() ? _drag.dy.abs() : _drag.dx.abs();
    return ((dist - 36) / 70).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final stamp = _stamp;
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
                child: _allSeen ? _AllSeenCard(onKeepBrowsing: _keepBrowsing) : _buildCard(stamp),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: _canUndo ? 1 : 0.4,
                    child: CrushapIconButton(
                      icon: 'undo-2',
                      label: 'Undo',
                      variant: CrushapIconButtonVariant.ghost,
                      size: CrushapIconButtonSize.sm,
                      onPressed: _canUndo ? _undo : null,
                    ),
                  ),
                  const SizedBox(width: 14),
                  CrushapIconButton(
                    icon: 'x',
                    label: 'Pass',
                    variant: CrushapIconButtonVariant.outline,
                    size: CrushapIconButtonSize.lg,
                    onPressed: _allSeen ? null : () => _fly(_SwipeAction.pass),
                  ),
                  const SizedBox(width: 20),
                  CrushapIconButton(
                    icon: 'star',
                    label: 'Superlike',
                    variant: CrushapIconButtonVariant.surface,
                    onPressed: _allSeen ? null : () => _fly(_SwipeAction.superlike),
                  ),
                  const SizedBox(width: 20),
                  CrushapIconButton(
                    icon: 'heart',
                    label: 'Like',
                    variant: CrushapIconButtonVariant.filled,
                    size: CrushapIconButtonSize.lg,
                    onPressed: _allSeen ? null : () => _fly(_SwipeAction.like),
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

  Widget _buildCard(({String label, Color color, Alignment align})? stamp) {
    final angle = (_drag.dx / 300).clamp(-0.5, 0.5);
    return GestureDetector(
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
        child: SizedBox(
          width: 340,
          height: 440,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CrushapSwipeCard(
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
              if (stamp != null)
                Positioned.fill(
                  child: Align(
                    alignment: stamp.align,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Opacity(
                        opacity: _stampOpacity,
                        child: Transform.rotate(
                          angle: stamp.align == Alignment.topRight
                              ? -0.22
                              : stamp.align == Alignment.topLeft
                                  ? 0.22
                                  : 0.0,
                          child: _Stamp(label: stamp.label, color: stamp.color),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stamp extends StatelessWidget {
  const _Stamp({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 3),
        borderRadius: BorderRadius.circular(CrushapRadii.sm),
        color: CrushapColors.surfaceApp.withValues(alpha: 0.35),
      ),
      child: Text(
        label,
        style: CrushapText.displayMd.copyWith(color: color, letterSpacing: CrushapText.trackingWide * 28),
      ),
    );
  }
}

class _AllSeenCard extends StatelessWidget {
  const _AllSeenCard({required this.onKeepBrowsing});

  final VoidCallback onKeepBrowsing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      height: 440,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(CrushapRadii.xl),
          gradient: const LinearGradient(
            begin: Alignment(-0.64, -0.94),
            end: Alignment(0.64, 0.94),
            colors: [CrushapColors.black4, CrushapColors.black2],
          ),
          border: Border.all(color: CrushapColors.borderSubtle),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CrushapIcon('sparkles', size: 40, color: CrushapColors.accentSecondary),
              const SizedBox(height: 16),
              Text(
                "You're all caught up",
                textAlign: TextAlign.center,
                style: CrushapText.title,
              ),
              const SizedBox(height: 10),
              Text(
                "That's everyone nearby for now. Check back soon, or start again from the top.",
                textAlign: TextAlign.center,
                style: CrushapText.bodySm.copyWith(color: CrushapColors.textSecondary),
              ),
              const SizedBox(height: 24),
              CrushapButton(label: 'Keep browsing', onPressed: onKeepBrowsing),
            ],
          ),
        ),
      ),
    );
  }
}
