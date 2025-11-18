import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ExerciseVideoTile extends StatefulWidget {
  final String title;
  final String thumbUrl; // hiện tại KHÔNG dùng, nhưng giữ field để khỏi sửa API
  final String category;
  final int? sets;
  final int? reps;
  final int? minutes;
  final String? videoUrl; // URL video thực tế (mp4 / HLS / ...)

  const ExerciseVideoTile({
    super.key,
    required this.title,
    required this.thumbUrl,
    required this.category,
    this.sets,
    this.reps,
    this.minutes,
    this.videoUrl,
  });

  /// Meta: "5 phút" hoặc "3 sets × 12 reps"
  String get meta {
    if (minutes != null && minutes! > 0) return '$minutes phút';
    if (sets != null && reps != null) return '$sets sets × $reps reps';
    return '';
  }

  @override
  State<ExerciseVideoTile> createState() => _ExerciseVideoTileState();
}

class _ExerciseVideoTileState extends State<ExerciseVideoTile> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _isPlaying = false;
  bool _isMuted = true;
  bool _isLoading = false;
  bool _hasError = false;

  bool get _inlineSupported {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initAndPlay() async {
    if (!_inlineSupported ||
        widget.videoUrl == null ||
        widget.videoUrl!.isEmpty)
      return;

    final uri = Uri.tryParse(widget.videoUrl!);
    if (uri == null) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    _controller = VideoPlayerController.networkUrl(uri);
    try {
      await _controller!.initialize();
      _controller!
        ..setLooping(false)
        ..setVolume(0);
      await _controller!.play();

      if (!mounted) return;
      setState(() {
        _initialized = true;
        _isPlaying = true;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _onTapVideo() {
    if (_controller == null) {
      _initAndPlay();
    } else {
      _togglePlay();
    }
  }

  void _togglePlay() {
    if (_controller == null || !_initialized) return;
    final v = _controller!.value;

    if (v.isPlaying) {
      _controller!.pause();
      setState(() => _isPlaying = false);
    } else {
      if (v.position >= v.duration) {
        _controller!.seekTo(Duration.zero);
      }
      _controller!.play();
      _controller!.setVolume(_isMuted ? 0 : 1);
      setState(() => _isPlaying = true);
    }
  }

  void _openFullScreen() {
    if (_controller == null || !_initialized) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            _FullScreenVideoPage(controller: _controller!, title: widget.title),
      ),
    );
  }

  void _toggleMute() {
    if (_controller == null || !_initialized) return;

    setState(() {
      _isMuted = !_isMuted;
    });

    _controller!.setVolume(_isMuted ? 0 : 1); // 1 = max volume
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bodySmall = Theme.of(context).textTheme.bodySmall;

    final description = widget.meta.isEmpty
        ? widget.category
        : "${widget.category} • ${widget.meta}";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: _initialized && _controller != null
                  ? _controller!.value.aspectRatio
                  : 16 / 9,
              child: GestureDetector(
                onTap: _controller == null ? _initAndPlay : _togglePlay,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (_initialized && _controller != null)
                      VideoPlayer(_controller!)
                    else if (_hasError)
                      Container(
                        color: cs.surfaceVariant,
                        child: const Center(
                          child: Text(
                            'Không phát được video',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    else if (_isLoading)
                      Container(
                        color: cs.surfaceVariant,
                        child: const Center(child: CircularProgressIndicator()),
                      )
                    else
                      Container(
                        color: cs.surfaceVariant,
                        child: const Center(
                          child: Icon(
                            Icons.play_arrow,
                            size: 52,
                            color: Colors.white,
                          ),
                        ),
                      ),

                    if (_controller != null && _initialized && !_hasError)
                      Positioned(
                        right: 8,
                        bottom: 48,
                        child: IconButton(
                          icon: Icon(
                            _isMuted ? Icons.volume_off : Icons.volume_up,
                            color: Colors.white,
                          ),
                          onPressed: _toggleMute,
                        ),
                      ),
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: IconButton(
                        icon: const Icon(Icons.fullscreen, color: Colors.white),
                        onPressed: _openFullScreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // text info
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Trang full-screen video đơn giản
class _FullScreenVideoPage extends StatelessWidget {
  final VideoPlayerController controller;
  final String title;

  const _FullScreenVideoPage({required this.controller, required this.title});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(title, style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: Stack(
            fit: StackFit.expand,
            children: [
              VideoPlayer(controller),
              Align(
                alignment: Alignment.bottomCenter,
                child: VideoProgressIndicator(
                  controller,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                    playedColor: cs.primary,
                    bufferedColor: Colors.white30,
                    backgroundColor: Colors.white10,
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
