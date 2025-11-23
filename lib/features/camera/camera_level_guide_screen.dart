// lib/features/camera/camera_level_guide_screen.dart
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'body_cam_screen.dart';

class CameraLevelGuideScreen extends StatefulWidget {
  const CameraLevelGuideScreen({super.key});

  @override
  State<CameraLevelGuideScreen> createState() => _CameraLevelGuideScreenState();
}

class _CameraLevelGuideScreenState extends State<CameraLevelGuideScreen>
    with SingleTickerProviderStateMixin {
  StreamSubscription<AccelerometerEvent>? _accelSub;

  bool _isAligned = false;
  int _countdown = 5;
  Timer? _timer;
  bool _openingCamera = false;

  // Dot position (normalized -1..1)
  double _dotX = 0;
  double _dotY = 0;

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _shakeAnimation =
        CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut)
          ..addListener(() {
            if (mounted) setState(() {});
          });

    _accelSub = accelerometerEvents.listen(_onAccel);
  }

  @override
  void dispose() {
    _accelSub?.cancel();
    _timer?.cancel();
    _shakeController.dispose();
    super.dispose();
  }

  void _onAccel(AccelerometerEvent e) {
    // Góc để check "đứng thẳng"
    final pitch = atan2(e.x, sqrt(e.y * e.y + e.z * e.z)) * 180 / pi;
    final roll = atan2(e.y, e.z) * 180 / pi;
    final centeredRoll = roll - 90; // đứng thẳng => ~0°

    // ================== DOT EASING ==================
    // map trực tiếp từ gia tốc:
    //  - e.x: nghiêng trái/phải
    //  - e.z: ngả trước/sau
    const maxGX = 4.0; // biên độ tối đa để clamp
    const maxGZ = 4.0;

    // nghiêng phải (e.x > 0) -> dotX dương -> đi sang phải
    final targetX = (e.x / maxGX).clamp(-1.0, 1.0);
    // ngả ra sau (e.z > 0) -> dotY dương -> đi xuống (đổi dấu nếu muốn lên)
    final targetY = (e.z / maxGZ).clamp(-1.0, 1.0);

    const alpha = 0.15; // smoothing
    setState(() {
      _dotX = _dotX + (targetX - _dotX) * alpha;
      _dotY = _dotY + (targetY - _dotY) * alpha;
    });

    // ================== CHECK ALIGNED ==================
    const thresholdDeg = 4.0;
    final aligned =
        pitch.abs() < thresholdDeg && centeredRoll.abs() < thresholdDeg;

    if (aligned == _isAligned) return;

    final wasAligned = _isAligned;
    setState(() => _isAligned = aligned);

    if (aligned) {
      _startCountdown();
      if (!wasAligned) {
        _shakeController.forward(from: 0);
      }
    } else {
      _cancelCountdown();
      _shakeController.stop();
    }
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _countdown = 5);

    _timer = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (!_isAligned) {
        _cancelCountdown();
        return;
      }

      if (_countdown <= 1) {
        _cancelCountdown();
        if (!_openingCamera) {
          _openingCamera = true;
          await _openBodyCamera();
        }
      } else {
        setState(() => _countdown--);
      }
    });
  }

  void _cancelCountdown() {
    _timer?.cancel();
    _timer = null;
    if (mounted) {
      setState(() => _countdown = 5);
    }
  }

  Future<void> _openBodyCamera() async {
    // mở BodyCameraScreen, chờ kết quả 2 ảnh
    final result = await Navigator.of(context).push<Map<String, dynamic>?>(
      MaterialPageRoute(
        builder: (_) => const BodyCameraScreen(),
        fullscreenDialog: true,
      ),
    );

    if (!mounted) return;

    // pop màn căn máy và trả kết quả ra ngoài
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return WillPopScope(
      onWillPop: () async =>
          false, // ❌ chặn back cứng (nút back Android / gesture)
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'Kê điện thoại thẳng đứng',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Căn dấu chấm vào hồng tâm.\n'
                  'Khi chuyển xanh sẽ tự động mở camera.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 40),

                // HỒNG TÂM + DOT
                SizedBox(
                  width: 180,
                  height: 180,
                  child: CustomPaint(
                    painter: _ReticlePainter(
                      active: _isAligned,
                      dotX: _dotX,
                      dotY: _dotY,
                      pulse: _shakeAnimation.value,
                      colorInactive: Colors.white.withOpacity(0.4),
                      colorActive: cs.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Đếm ngược
                AnimatedOpacity(
                  opacity: _isAligned ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    _isAligned ? '$_countdown' : '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
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

/// Vẽ hồng tâm + dot:
/// - 3 vòng tròn + crosshair
/// - Dot di chuyển theo dotX/dotY
/// - Khi active, dot rung nhẹ (pulse) + đổi màu
class _ReticlePainter extends CustomPainter {
  final bool active;
  final double dotX; // -1..1 (trái/phải)
  final double dotY; // -1..1 (lên/xuống)
  final double pulse; // 0..1 từ animation
  final Color colorInactive;
  final Color colorActive;

  _ReticlePainter({
    required this.active,
    required this.dotX,
    required this.dotY,
    required this.pulse,
    required this.colorInactive,
    required this.colorActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 4;

    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = colorInactive;

    // 3 vòng tròn
    canvas.drawCircle(center, radius, basePaint);
    canvas.drawCircle(center, radius * 0.66, basePaint);
    canvas.drawCircle(center, radius * 0.33, basePaint);

    // dấu cộng
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      basePaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      basePaint,
    );

    // -------- DOT di chuyển + rung --------
    final dotBaseRadius = 7.0;
    final scale = active ? (1.0 + 0.25 * pulse) : 1.0;
    final wobble = active ? sin(pulse * pi * 4) * 2.0 : 0.0;

    final dotOffset = Offset(
      center.dx + dotX * radius + wobble, // dotX > 0 -> sang phải
      center.dy + dotY * radius, // dotY > 0 -> xuống
    );

    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = active ? colorActive : Colors.white;

    canvas.drawCircle(dotOffset, dotBaseRadius * scale, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _ReticlePainter oldDelegate) {
    return oldDelegate.active != active ||
        oldDelegate.dotX != dotX ||
        oldDelegate.dotY != dotY ||
        oldDelegate.pulse != pulse ||
        oldDelegate.colorInactive != colorInactive ||
        oldDelegate.colorActive != colorActive;
  }
}
