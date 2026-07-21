import 'package:flutter/widgets.dart';
import '../l10n/gen/app_localizations.dart';
import '../models/profile.dart';
import '../services/api_client.dart';
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

String _actionName(_SwipeAction a) => switch (a) {
      _SwipeAction.pass => 'pass',
      _SwipeAction.superlike => 'superlike',
      _SwipeAction.like => 'like',
    };

/// Ported from ui_kits/dating-app/DiscoverScreen.jsx, now driven by the
/// live `/api/discover` + `/api/swipes` endpoints instead of a static
/// sample deck. Keeps the drag-to-swipe gesture, the LIKE/NOPE/SUPER LIKE
/// stamp, and undo (now a real server-side undo — see
/// server/src/store/swipes.js — not just a local rewind).
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({
    super.key,
    required this.api,
    required this.onMatch,
    required this.onOpenFilters,
    required this.activeTab,
    required this.onTabChanged,
  });

  final ApiClient api;
  final ValueChanged<Profile> onMatch;
  final VoidCallback onOpenFilters;
  final CrushapNavTab activeTab;
  final ValueChanged<CrushapNavTab> onTabChanged;

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  List<Profile> _deck = [];
  int _idx = 0;
  bool _loading = true;
  String? _loadError;
  List<String> _relaxedFilters = const [];

  Profile? _lastSwiped;
  bool _lastMatched = false;

  Offset _drag = Offset.zero;
  Duration _animDuration = Duration.zero;
  VoidCallback? _pendingAfterAnim;
  bool _busy = false;
  int _photoIndex = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final session = widget.api.session;
      final result = await widget.api.discover(
        filters: DiscoverFilters(
          maxAge: session.filterMaxAge,
          maxDistanceKm: session.filterMaxDistanceKm,
          showMe: session.filterShowMe,
          verifiedOnly: session.filterVerifiedOnly,
          hasPhoto: session.filterHasPhoto,
          tags: session.filterTags,
        ),
      );
      setState(() {
        _deck = result.profiles;
        _relaxedFilters = result.relaxedFilters;
        _idx = 0;
        _photoIndex = 0;
        _loading = false;
      });
    } on ApiException catch (e) {
      setState(() {
        _loadError = e.message;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadError = AppLocalizations.of(context)!.genericNetworkError;
        _loading = false;
      });
    }
  }

  Profile? get _current => _idx < _deck.length ? _deck[_idx] : null;
  bool get _canUndo => _lastSwiped != null && !_lastMatched;

  Future<void> _advance(_SwipeAction action) async {
    final target = _current;
    if (target == null || _busy) return;
    setState(() => _busy = true);
    try {
      final result = await widget.api.swipe(target.id, _actionName(action));
      _lastSwiped = target;
      _lastMatched = result.matched;
      if (result.matched && result.profile != null) widget.onMatch(result.profile!);
    } catch (_) {
      // Network hiccup — still move on locally so the deck doesn't stall;
      // the server is the source of truth for anyone re-fetching /discover.
      _lastSwiped = target;
      _lastMatched = false;
    }
    if (!mounted) return;
    setState(() {
      _idx++;
      _photoIndex = 0;
      _drag = Offset.zero;
      _animDuration = Duration.zero;
      _busy = false;
    });
  }

  Future<void> _undo() async {
    final target = _lastSwiped;
    if (target == null || _lastMatched || _busy) return;
    setState(() => _busy = true);
    try {
      await widget.api.undoSwipe(target.id);
      setState(() {
        // _idx stays put — the undone profile is reinserted right at it.
        _deck.insert(_idx, target);
        _lastSwiped = null;
        _photoIndex = 0;
      });
    } catch (_) {
      // Nothing to undo server-side (already matched from the other angle,
      // etc.) — leave state as-is.
    }
    if (mounted) setState(() => _busy = false);
  }

  void _fly(_SwipeAction action) {
    if (_current == null || _busy) return;
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
      _pendingAfterAnim = () => _advance(action);
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

  ({String label, Color color, Alignment align})? _stamp(AppLocalizations t) {
    const start = 36.0;
    if (_drag.dy < -start && _drag.dy.abs() > _drag.dx.abs()) {
      return (label: t.stampSuperlike, color: CrushapColors.actionSuperlike, align: Alignment.topCenter);
    }
    if (_drag.dx > start) {
      return (label: t.stampLike, color: CrushapColors.actionLike, align: Alignment.topRight);
    }
    if (_drag.dx < -start) {
      return (label: t.stampNope, color: CrushapColors.actionPass, align: Alignment.topLeft);
    }
    return null;
  }

  double get _stampOpacity {
    final dist = _drag.dy.abs() > _drag.dx.abs() ? _drag.dy.abs() : _drag.dx.abs();
    return ((dist - 36) / 70).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final stamp = _stamp(t);
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
                  Text(t.discoverTitle, style: CrushapText.title),
                  Positioned(
                    right: 8,
                    child: CrushapIconButton(
                      icon: 'sliders-horizontal',
                      label: t.filtersLabel,
                      size: CrushapIconButtonSize.sm,
                      variant: CrushapIconButtonVariant.ghost,
                      onPressed: widget.onOpenFilters,
                    ),
                  ),
                ],
              ),
            ),
            if (_relaxedFilters.isNotEmpty && _current != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CrushapIcon('sparkles', size: 13, color: CrushapColors.textTertiary),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        t.filtersWidenedNotice,
                        textAlign: TextAlign.center,
                        style: CrushapText.caption.copyWith(color: CrushapColors.textTertiary),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(child: Center(child: _buildBody(t, stamp))),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: _canUndo ? 1 : 0.4,
                    child: CrushapIconButton(
                      icon: 'undo-2',
                      label: t.undoLabel,
                      variant: CrushapIconButtonVariant.ghost,
                      size: CrushapIconButtonSize.sm,
                      onPressed: _canUndo ? _undo : null,
                    ),
                  ),
                  const SizedBox(width: 14),
                  CrushapIconButton(
                    icon: 'x',
                    label: t.passLabel,
                    variant: CrushapIconButtonVariant.outline,
                    size: CrushapIconButtonSize.lg,
                    onPressed: _current == null ? null : () => _fly(_SwipeAction.pass),
                  ),
                  const SizedBox(width: 20),
                  CrushapIconButton(
                    icon: 'star',
                    label: t.superlikeLabel,
                    variant: CrushapIconButtonVariant.surface,
                    onPressed: _current == null ? null : () => _fly(_SwipeAction.superlike),
                  ),
                  const SizedBox(width: 20),
                  CrushapIconButton(
                    icon: 'heart',
                    label: t.likeLabel,
                    variant: CrushapIconButtonVariant.filled,
                    size: CrushapIconButtonSize.lg,
                    onPressed: _current == null ? null : () => _fly(_SwipeAction.like),
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

  Widget _buildBody(AppLocalizations t, ({String label, Color color, Alignment align})? stamp) {
    if (_loading) {
      return Text(t.findingPeopleNearby, style: CrushapText.body.copyWith(color: CrushapColors.textSecondary));
    }
    if (_loadError != null) {
      return _MessageCard(
        icon: 'zap',
        title: t.discoverLoadErrorTitle,
        message: _loadError!,
        actionLabel: t.tryAgain,
        onAction: _load,
      );
    }
    if (_current == null) {
      return _MessageCard(
        icon: 'sparkles',
        title: t.allCaughtUpTitle,
        message: t.allCaughtUpMessage,
        actionLabel: t.refresh,
        onAction: _load,
      );
    }
    return _buildCard(t, stamp);
  }

  Widget _buildCard(AppLocalizations t, ({String label, Color color, Alignment align})? stamp) {
    final angle = (_drag.dx / 300).clamp(-0.5, 0.5);
    final current = _current!;
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
                key: ValueKey('${current.id}-$_idx'),
                name: current.name,
                age: current.age,
                distance: current.distanceValue == null ? null : t.distanceAwayKm(current.distanceValue!),
                verified: current.verified,
                verifiedLabel: t.verifiedBadge,
                bio: current.bio,
                tags: current.tags,
                photoUrls: [for (final p in current.photos) widget.api.mediaUrl(p)!],
                photoIndex: _photoIndex,
                onTapPhoto: (forward) => setState(() {
                  final count = current.photos.length;
                  _photoIndex = (_photoIndex + (forward ? 1 : -1)).clamp(0, count - 1);
                }),
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

class _MessageCard extends StatelessWidget {
  const _MessageCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final String icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

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
              CrushapIcon(icon, size: 40, color: CrushapColors.accentSecondary),
              const SizedBox(height: 16),
              Text(title, textAlign: TextAlign.center, style: CrushapText.title),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: CrushapText.bodySm.copyWith(color: CrushapColors.textSecondary),
              ),
              const SizedBox(height: 24),
              CrushapButton(label: actionLabel, onPressed: onAction),
            ],
          ),
        ),
      ),
    );
  }
}
