import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class NetworkVideoThumbnail extends StatefulWidget {
  final String videoUrl;

  const NetworkVideoThumbnail({super.key, required this.videoUrl});

  @override
  State<NetworkVideoThumbnail> createState() => _NetworkVideoThumbnailState();
}

class _NetworkVideoThumbnailState extends State<NetworkVideoThumbnail> {
  Uint8List? _thumbBytes;

  @override
  void initState() {
    super.initState();
    _loadThumb();
  }

  Future<void> _loadThumb() async {
    try {
      Uint8List? bytes;

      if (_isLocal(widget.videoUrl)) {
        // video local user quay
        bytes = await _createThumbFromLocal(widget.videoUrl);
      } else {
        // video remote (Firebase Storage)
        bytes = await _createThumbFromNetwork(widget.videoUrl);
      }

      if (!mounted) return;
      setState(() => _thumbBytes = bytes);
    } catch (_) {
      if (!mounted) return;
      setState(() => _thumbBytes = null);
    }
  }

  bool _isLocal(String path) {
    return path.startsWith('/') ||
        path.startsWith('file://') ||
        File(path).existsSync();
  }

  Future<Uint8List?> _createThumbFromLocal(String path) async {
    return VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 640,
      quality: 75,
    );
  }

  Future<Uint8List?> _createThumbFromNetwork(String url) async {
    try {
      final dir = await getTemporaryDirectory();
      final filePath =
          '${dir.path}/thumb_src_${DateTime.now().millisecondsSinceEpoch}.mp4';

      // download file về local
      final resp = await http.get(Uri.parse(url));
      if (resp.statusCode != 200) return null;

      final file = File(filePath);
      await file.writeAsBytes(resp.bodyBytes);

      return VideoThumbnail.thumbnailData(
        video: file.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 640,
        quality: 75,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_thumbBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(_thumbBytes!, fit: BoxFit.cover),
      );
    }

    // fallback UI
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF4B3A32),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(Icons.play_arrow_rounded, size: 48, color: Colors.white),
      ),
    );
  }
}
