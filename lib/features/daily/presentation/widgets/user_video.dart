// lib/features/daily/presentation/widgets/user_video.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:fitai_mobile/core/widgets/network_thumb_video.dart';

class UserExerciseVideoSection extends StatefulWidget {
  final String title;

  /// Video local user vừa chọn (nếu có)
  final String? localVideoPath;

  /// Video log từ server (exercise.videoLogUrl)
  final String? existingVideoUrl;
  final bool isCompleted;
  final int? completionPercent;

  const UserExerciseVideoSection({
    super.key,
    required this.title,
    this.localVideoPath,
    this.existingVideoUrl,
    this.isCompleted = false,
    this.completionPercent,
  });

  @override
  State<UserExerciseVideoSection> createState() =>
      _UserExerciseVideoSectionState();
}

class _UserExerciseVideoSectionState extends State<UserExerciseVideoSection> {
  String? get _videoSource {
    if (widget.localVideoPath != null && widget.localVideoPath!.isNotEmpty) {
      return widget.localVideoPath;
    }
    if (widget.existingVideoUrl != null &&
        widget.existingVideoUrl!.isNotEmpty) {
      return widget.existingVideoUrl;
    }
    return null;
  }

  bool get _isLocal =>
      widget.localVideoPath != null && widget.localVideoPath!.isNotEmpty;

  Future<void> _openFullScreen(BuildContext context) async {
    final src = _videoSource;
    if (src == null || src.isEmpty) return;

    late final VideoPlayerController controller;
    if (_isLocal) {
      controller = VideoPlayerController.file(File(src));
    } else {
      final uri = Uri.tryParse(src);
      if (uri == null) return;
      controller = VideoPlayerController.networkUrl(uri);
    }

    await controller.initialize();

    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => _UserVideoFullScreenPage(
          controller: controller,
          title: widget.title,
        ),
      ),
    );

    await controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final src = _videoSource;

    if (src == null) return const SizedBox.shrink();

    final percentLabel = widget.completionPercent?.round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ====== HEADER: "Video bài tập của bạn" + % / check ======
        Row(
          children: [
            Expanded(
              child: Text(
                'Video bài tập của bạn',
                style: t.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
            ),
            if (percentLabel != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$percentLabel%',
                  style: t.labelSmall?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            else if (widget.isCompleted)
              Icon(Icons.check_circle, color: cs.primary, size: 18),
          ],
        ),
        const SizedBox(height: 6),

        // ====== VIDEO PREVIEW (style giống video chính) ======
        GestureDetector(
          onTap: () => _openFullScreen(context),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Nền: thumbnail hoặc placeholder
                  if (_isLocal)
                    // Local video: dùng nền tối + icon (tránh dùng NetworkVideoThumbnail)
                    Container(
                      color: cs.surfaceVariant,
                      child: const Center(
                        child: Icon(
                          Icons.videocam,
                          color: Colors.white70,
                          size: 40,
                        ),
                      ),
                    )
                  else
                    NetworkVideoThumbnail(videoUrl: src),

                  // Overlay gradient cho giống video chính
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),

                  // Icon play ở giữa
                  const Center(
                    child: Icon(
                      Icons.play_arrow,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),

                  // Badge "Video của bạn" góc trên trái
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Video của bạn',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _UserVideoFullScreenPage extends StatefulWidget {
  final VideoPlayerController controller;
  final String title;

  const _UserVideoFullScreenPage({
    required this.controller,
    required this.title,
  });

  @override
  State<_UserVideoFullScreenPage> createState() =>
      _UserVideoFullScreenPageState();
}

class _UserVideoFullScreenPageState extends State<_UserVideoFullScreenPage> {
  @override
  void initState() {
    super.initState();
    _enterFullscreen();
  }

  Future<void> _enterFullscreen() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    await SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _exitFullscreen() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    _exitFullscreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: widget.controller.value.aspectRatio,
          child: Stack(
            fit: StackFit.expand,
            children: [
              VideoPlayer(widget.controller),
              Align(
                alignment: Alignment.bottomCenter,
                child: VideoProgressIndicator(
                  widget.controller,
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
