import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

/// Autoplaying, muted, looping preview for a profile's intro video — the
/// same "silent looping clip" convention most dating apps use, so it reads
/// like a richer photo rather than something that needs a tap and blasts
/// sound out mid-swipe.
class CrushapVideoPreview extends StatefulWidget {
  const CrushapVideoPreview({super.key, required this.url, this.fit = BoxFit.cover});

  final String url;
  final BoxFit fit;

  @override
  State<CrushapVideoPreview> createState() => _CrushapVideoPreviewState();
}

class _CrushapVideoPreviewState extends State<CrushapVideoPreview> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    try {
      await controller.initialize();
      await controller.setVolume(0);
      await controller.setLooping(true);
      await controller.play();
      if (mounted) {
        setState(() => _controller = controller);
      } else {
        controller.dispose();
      }
    } catch (_) {
      controller.dispose();
    }
  }

  @override
  void didUpdateWidget(covariant CrushapVideoPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _controller?.dispose();
      _controller = null;
      _init();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const ColoredBox(color: Color(0x1AFFFFFF));
    }
    return ClipRect(
      child: FittedBox(
        fit: widget.fit,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: controller.value.size.width,
          height: controller.value.size.height,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}
