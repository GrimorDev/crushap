import 'dart:ui';
import 'package:flutter/widgets.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/colors.dart';
import '../../theme/effects.dart';
import '../../theme/typography.dart';
import '../core/app_avatar.dart';
import '../core/app_button.dart';

/// Ported from components/dating/MatchOverlay.jsx.
class CrushapMatchOverlay extends StatelessWidget {
  const CrushapMatchOverlay({
    super.key,
    required this.matchName,
    this.youPhoto,
    this.matchPhoto,
    this.onMessage,
    this.onKeepSwiping,
  });

  final String matchName;
  final ImageProvider? youPhoto;
  final ImageProvider? matchPhoto;
  final VoidCallback? onMessage;
  final VoidCallback? onKeepSwiping;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Positioned.fill(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: CrushapEffects.blurGlassSigma,
            sigmaY: CrushapEffects.blurGlassSigma,
          ),
          child: Container(
            color: CrushapColors.overlayScrim,
            padding: const EdgeInsets.all(32),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => CrushapColors.gradientPrimary.createShader(bounds),
                  child: Text(
                    t.itsAMatch,
                    textAlign: TextAlign.center,
                    style: CrushapText.displayXl.copyWith(
                      color: const Color(0xFFFFFFFF),
                      letterSpacing: CrushapText.trackingTight * 48,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 280),
                  child: Text(
                    t.matchedWithMessage(matchName),
                    textAlign: TextAlign.center,
                    style: CrushapText.body.copyWith(color: CrushapColors.textSecondary),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  // Two 112px avatars overlapping by 20px, per the source's
                  // `marginRight: -20` on the first.
                  width: 204,
                  height: 112,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: CrushapEffects.shadowGlowPrimary,
                          ),
                          child: CrushapAvatar(name: 'You', size: CrushapAvatarSize.xl, image: youPhoto),
                        ),
                      ),
                      Positioned(
                        left: 92,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: CrushapEffects.shadowGlowPrimary,
                          ),
                          child: CrushapAvatar(name: matchName, size: CrushapAvatarSize.xl, image: matchPhoto),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 280),
                  child: Column(
                    children: [
                      CrushapButton(
                        label: t.sendAMessage,
                        size: CrushapButtonSize.lg,
                        expand: true,
                        onPressed: onMessage,
                      ),
                      const SizedBox(height: 12),
                      CrushapButton(
                        label: t.keepSwiping,
                        variant: CrushapButtonVariant.ghost,
                        expand: true,
                        onPressed: onKeepSwiping,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
