// lib/features/daily/presentation/widgets/exercise_video_log_tile.dart
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

// Widget tạo thumbnail từ local path / network url
import 'package:fitai_mobile/core/widgets/network_thumb_video.dart';
import 'package:fitai_mobile/features/daily/presentation/widgets/user_video.dart';

/// Tile bài tập: phát video hướng dẫn + cho phép chọn video tự quay để log
class ExerciseVideoLogTile extends StatefulWidget {
  final String title;

  /// Ví dụ: "Cardio", "Strength"
  final String category;

  /// Thời lượng (phút) hoặc sets / reps
  final int? sets;
  final int? reps;
  final int? minutes;

  /// Ghi chú thêm từ API (exercise.note)
  final String? note;

  /// Video hướng dẫn (từ API: exercise.videoUrl)
  final String? demoVideoUrl;

  /// Video log đã có sẵn từ server (exercise.videoLogUrl), nếu có
  final String? existingLogVideoUrl;

  /// Callback khi user chọn video mới: [localFilePath]
  final void Function(String localFilePath)? onVideoPicked;

  const ExerciseVideoLogTile({
    super.key,
    required this.title,
    required this.category,
    this.sets,
    this.reps,
    this.minutes,
    this.note,
    this.demoVideoUrl,
    this.existingLogVideoUrl,
    this.onVideoPicked,
  });

  /// Meta: "30 phút" hoặc "3 sets × 12 reps"
  String get meta {
    if (minutes != null && minutes! > 0) return '$minutes phút';
    if (sets != null && reps != null) return '$sets sets × $reps reps';
    return '';
  }

  @override
  State<ExerciseVideoLogTile> createState() => _ExerciseVideoLogTileState();
}

class _ExerciseVideoLogTileState extends State<ExerciseVideoLogTile> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _isPlaying = false;
  bool _isMuted = true;
  bool _isLoading = false;
  bool _hasError = false;

  /// Khi video chạy tới cuối -> show nút replay
  bool _showReplay = false;

  /// File video user vừa chọn (local)
  String? _pickedVideoPath;

  /// volume 0–1 cho slider
  double _volume = 0.0;

  bool get _inlineSupported {
    // App này mobile only nên kIsWeb sẽ luôn false
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  /// URL/path dùng để làm thumbnail khi chưa play
  /// 👉 Giờ CHỈ dùng video hướng dẫn (demoVideoUrl), không dùng video user
  String? get _thumbSource {
    if (widget.demoVideoUrl?.isNotEmpty ?? false) {
      return widget.demoVideoUrl;
    }
    return null;
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoTick);
    _controller?.dispose();
    super.dispose();
  }

  void _onVideoTick() {
    if (!mounted || _controller == null || !_initialized) return;
    final v = _controller!.value;

    // Nếu đã tới cuối và dừng -> show replay
    if (!v.isPlaying && v.position >= v.duration && !_showReplay) {
      setState(() {
        _isPlaying = false;
        _showReplay = true;
      });
    }
  }

  /// 👉 Chỉ play video hướng dẫn (demoVideoUrl)
  Future<void> _initAndPlay() async {
    if (!_inlineSupported) return;

    final demo = widget.demoVideoUrl;
    if (demo == null || demo.isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
      _showReplay = false;
    });

    _controller?.removeListener(_onVideoTick);
    _controller?.dispose();
    _controller = null;

    try {
      final uri = Uri.tryParse(demo);
      if (uri == null) throw Exception('Invalid URL');
      _controller = VideoPlayerController.networkUrl(uri);

      await _controller!.initialize();
      _controller!
        ..setLooping(false)
        ..setVolume(_isMuted ? 0 : 1);
      _controller!.addListener(_onVideoTick);

      await _controller!.play();

      if (!mounted) return;
      setState(() {
        _initialized = true;
        _isPlaying = true;
        _isLoading = false;
        _volume = _isMuted ? 0.0 : 1.0;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
        _initialized = false;
      });
    }
  }

  void _togglePlay() {
    if (_controller == null || !_initialized) return;
    final v = _controller!.value;

    // Nếu đã hết -> replay từ đầu
    if (v.position >= v.duration) {
      _replay();
      return;
    }

    if (v.isPlaying) {
      _controller!.pause();
      setState(() => _isPlaying = false);
    } else {
      _controller!.setVolume(_isMuted ? 0 : 1);
      _controller!.play();
      setState(() {
        _isPlaying = true;
        _showReplay = false;
      });
    }
  }

  void _replay() {
    if (_controller == null || !_initialized) return;
    _controller!.seekTo(Duration.zero);
    _controller!.setVolume(_isMuted ? 0 : 1);
    _controller!.play();
    setState(() {
      _isPlaying = true;
      _showReplay = false;
    });
  }

  void _onTapVideo() {
    if (_controller == null) {
      _initAndPlay();
    } else {
      _togglePlay();
    }
  }

  void _openFullScreen() {
    if (_controller == null || !_initialized) return;

    Navigator.of(context, rootNavigator: true).push(
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
      _volume = _isMuted ? 0.0 : 1.0;
    });
    _controller!.setVolume(_isMuted ? 0 : 1);
  }

  void _onVolumeChanged(double v) {
    if (_controller == null || !_initialized) return;
    setState(() {
      _volume = v;
      _isMuted = v == 0.0;
    });
    _controller!.setVolume(v);
  }

  /// Mobile app nên không cần check kIsWeb nữa
  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 5),
    );
    if (picked == null) return;

    setState(() {
      _pickedVideoPath = picked.path;
    });

    widget.onVideoPicked?.call(picked.path);

    // ❌ Không auto play nữa, video chính luôn là demo
    // await _initAndPlay();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final bodySmall = t.bodySmall;

    final description = widget.meta;
    final note = widget.note;
    final hasMeta = description.isNotEmpty;
    final hasNote = note != null && note.trim().isNotEmpty;

    final hasUserVideo =
        _pickedVideoPath != null ||
        (widget.existingLogVideoUrl?.isNotEmpty ?? false);

    final thumbSource = _thumbSource;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====== VIDEO AREA (VIDEO HƯỚNG DẪN) ======
            AspectRatio(
              aspectRatio: _initialized && _controller != null
                  ? _controller!.value.aspectRatio
                  : 16 / 9,
              child: GestureDetector(
                onTap: _onTapVideo,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // ---- Lớp nền: video hoặc thumbnail ----
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
                    else if (thumbSource != null)
                      NetworkVideoThumbnail(videoUrl: thumbSource)
                    else
                      Container(color: cs.surfaceVariant),

                    // Icon play ở giữa khi chưa play (không lỗi, không loading)
                    if (!_initialized &&
                        !_isLoading &&
                        !_hasError &&
                        !_showReplay)
                      const Center(
                        child: Icon(
                          Icons.play_arrow,
                          size: 52,
                          color: Colors.white,
                        ),
                      ),

                    // ❌ BỎ badge "Video của bạn" khỏi video chính

                    // Nút replay ở giữa khi xem xong
                    if (_showReplay)
                      Center(
                        child: IconButton(
                          iconSize: 56,
                          onPressed: _replay,
                          icon: const Icon(Icons.replay, color: Colors.white),
                        ),
                      ),

                    // ====== BOTTOM CONTROLS (volume + fullscreen) ======
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black54],
                          ),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(
                                _isMuted ? Icons.volume_off : Icons.volume_up,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: _toggleMute,
                            ),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 2,
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 6,
                                  ),
                                ),
                                child: Slider(
                                  value: _volume,
                                  min: 0,
                                  max: 1,
                                  onChanged: _onVolumeChanged,
                                ),
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(
                                Icons.fullscreen,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: _openFullScreen,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ====== TEXT + BUTTON "Tải video bài tập" ======
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dòng 1: Tên bài tập (trái) + Category (phải)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: t.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (widget.category.isNotEmpty)
                        Text(
                          widget.category.toLowerCase(), // chữ thường
                          style: bodySmall?.copyWith(
                            // giảm 1 size chữ
                            fontSize: (bodySmall.fontSize ?? 12) - 1,
                            color: cs.primary, // dùng màu primary
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Dòng 2: meta (sets/reps hoặc phút) + note cùng hàng
                  if (hasMeta || hasNote)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hasMeta)
                          Text(
                            description,
                            style: bodySmall?.copyWith(
                              color: cs.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        if (hasMeta && hasNote) const SizedBox(width: 12),
                        if (hasNote)
                          Expanded(
                            child: Text(
                              note!,
                              style: bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                      ],
                    ),

                  const SizedBox(height: 10),

                  // Nút giống "Tải ảnh bữa ăn"
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: Size.zero,
                      ),
                      onPressed: _pickVideo,
                      icon: Icon(
                        Icons.videocam_outlined,
                        size: 18,
                        color: cs.primary,
                      ),
                      label: Text(
                        hasUserVideo
                            ? 'Đổi video bài tập'
                            : 'Tải video bài tập',
                        style: bodySmall?.copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  if (_pickedVideoPath != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Đã chọn video',
                        style: bodySmall?.copyWith(
                          color: cs.primary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  else if (widget.existingLogVideoUrl != null &&
                      widget.existingLogVideoUrl!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Đã có video log',
                        style: bodySmall?.copyWith(
                          color: cs.primary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                  // 🆕 VIDEO CỦA NGƯỜI DÙNG + COMMENT Ở DƯỚI
                  if (hasUserVideo)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: UserExerciseVideoSection(
                        title: widget.title,
                        localVideoPath: _pickedVideoPath,
                        existingVideoUrl: widget.existingLogVideoUrl,
                        // Sau này có thể truyền comments & onSubmitComment từ ngoài vào
                      ),
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

/// Full-screen page cho video, lock landscape + immersive
class _FullScreenVideoPage extends StatefulWidget {
  final VideoPlayerController controller;
  final String title;

  const _FullScreenVideoPage({required this.controller, required this.title});

  @override
  State<_FullScreenVideoPage> createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<_FullScreenVideoPage> {
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
