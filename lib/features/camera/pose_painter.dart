import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

/// Vẽ skeleton giống hình docs MLKit để debug.
class PosePainter extends CustomPainter {
  PosePainter(this.poses, this.imageSize);

  final List<Pose> poses;
  final Size imageSize;

  @override
  void paint(Canvas canvas, Size size) {
    if (poses.isEmpty) return;

    final pose = poses.first;

    // scale toạ độ ảnh -> kích thước widget
    Offset _scale(double x, double y) {
      final sx = size.width / imageSize.width;
      final sy = size.height / imageSize.height;
      return Offset(x * sx, y * sy);
    }

    final jointPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final bonePaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // vẽ các điểm
    for (final lm in pose.landmarks.values) {
      final o = _scale(lm.x, lm.y);
      canvas.drawCircle(o, 4, jointPaint);
    }

    void drawBone(PoseLandmarkType a, PoseLandmarkType b) {
      final la = pose.landmarks[a];
      final lb = pose.landmarks[b];
      if (la == null || lb == null) return;
      final pa = _scale(la.x, la.y);
      final pb = _scale(lb.x, lb.y);
      canvas.drawLine(pa, pb, bonePaint);
    }

    // thân trên
    drawBone(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder);
    drawBone(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip);
    drawBone(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip);
    drawBone(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip);

    // tay trái
    drawBone(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow);
    drawBone(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist);
    drawBone(PoseLandmarkType.leftWrist, PoseLandmarkType.leftThumb);
    drawBone(PoseLandmarkType.leftWrist, PoseLandmarkType.leftIndex);
    drawBone(PoseLandmarkType.leftWrist, PoseLandmarkType.leftPinky);

    // tay phải
    drawBone(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow);
    drawBone(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist);
    drawBone(PoseLandmarkType.rightWrist, PoseLandmarkType.rightThumb);
    drawBone(PoseLandmarkType.rightWrist, PoseLandmarkType.rightIndex);
    drawBone(PoseLandmarkType.rightWrist, PoseLandmarkType.rightPinky);

    // chân trái
    drawBone(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee);
    drawBone(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle);
    drawBone(PoseLandmarkType.leftAnkle, PoseLandmarkType.leftHeel);
    drawBone(PoseLandmarkType.leftHeel, PoseLandmarkType.leftFootIndex);

    // chân phải
    drawBone(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee);
    drawBone(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle);
    drawBone(PoseLandmarkType.rightAnkle, PoseLandmarkType.rightHeel);
    drawBone(PoseLandmarkType.rightHeel, PoseLandmarkType.rightFootIndex);

    // mặt – vài đoạn cho dễ nhìn
    drawBone(PoseLandmarkType.leftEye, PoseLandmarkType.rightEye);
    drawBone(PoseLandmarkType.nose, PoseLandmarkType.leftEye);
    drawBone(PoseLandmarkType.nose, PoseLandmarkType.rightEye);
    drawBone(PoseLandmarkType.leftEar, PoseLandmarkType.leftEyeOuter);
    drawBone(PoseLandmarkType.rightEar, PoseLandmarkType.rightEyeOuter);
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.poses != poses || oldDelegate.imageSize != imageSize;
  }
}
