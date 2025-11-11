import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PosePainterMirror extends CustomPainter {
  PosePainterMirror(this.poses, this.imageSize, {this.isFrontCamera = false});

  final List<Pose> poses;
  final Size imageSize;
  final bool isFrontCamera;

  @override
  void paint(Canvas canvas, Size size) {
    if (poses.isEmpty) return;
    final pose = poses.first;
    debugPrint('imageSize=$imageSize, canvasSize=$size');

    // Nếu là camera trước thì phải lật lại cho khớp với preview
    if (isFrontCamera) {
      canvas.translate(size.width, 0);
      canvas.scale(-1, 1);
    }

    Offset _scale(double x, double y) {
      // Tính tỷ lệ khung hình
      final previewRatio = size.width / size.height;
      final imageRatio = imageSize.width / imageSize.height;

      double scaleX, scaleY, dx = 0, dy = 0;

      if (previewRatio > imageRatio) {
        // Preview rộng hơn ảnh → crop trên/dưới
        scaleX = size.width / imageSize.width;
        scaleY = scaleX;
        dy = (size.height - imageSize.height * scaleY) / 2;
      } else {
        // Preview cao hơn ảnh → crop 2 bên
        scaleY = size.height / imageSize.height;
        scaleX = scaleY;
        dx = (size.width - imageSize.width * scaleX) / 2;
      }

      return Offset(x * scaleX + dx, y * scaleY + dy);
    }

    final jointPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final bonePaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..strokeWidth = 3;

    for (final lm in pose.landmarks.values) {
      final o = _scale(lm.x, lm.y);
      canvas.drawCircle(o, 4, jointPaint);
    }

    void drawBone(PoseLandmarkType a, PoseLandmarkType b) {
      final la = pose.landmarks[a];
      final lb = pose.landmarks[b];
      if (la == null || lb == null) return;
      canvas.drawLine(_scale(la.x, la.y), _scale(lb.x, lb.y), bonePaint);
    }

    // ... các drawBone giữ nguyên như của bạn ...
    drawBone(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder);
    drawBone(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip);
    drawBone(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip);
    drawBone(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip);
    drawBone(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow);
    drawBone(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist);
    drawBone(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow);
    drawBone(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist);
    drawBone(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee);
    drawBone(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle);
    drawBone(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee);
    drawBone(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle);
  }

  @override
  bool shouldRepaint(covariant PosePainterMirror oldDelegate) =>
      oldDelegate.poses != poses || oldDelegate.imageSize != imageSize;
}
