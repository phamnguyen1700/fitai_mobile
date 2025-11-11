import 'dart:math' as math;
import 'package:flutter/material.dart';

class CaloCount extends StatelessWidget {
  const CaloCount({
    super.key,
    required this.goal, // Mục tiêu calo/ngày (kcal)
    required this.consumed, // Đã nạp (kcal)
    this.size = 96, // Kích thước vòng tròn
    this.thickness = 10, // Độ dày vòng
    this.onTap,
  });

  final double goal;
  final double consumed;
  final double size;
  final double thickness;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final remaining = (goal - consumed).clamp(0, goal);
    final progress = (consumed / goal).clamp(0, 1);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment(-1, -1),
            end: Alignment(1, 1),
            colors: [
              Color(0xFF2D2B6B), // tím đậm
              Color(0xFF15213C), // xanh đêm
            ],
          ),
        ),
        child: Stack(
          children: [
            // pattern chấm nhẹ ở góc phải
            const Positioned.fill(child: _HalftonePattern()),
            Row(
              children: [
                Expanded(
                  child: Text(
                    remaining > 0
                        ? 'Bạn chỉ còn ${remaining.round()} calo để đạt mục tiêu hôm nay!'
                        : 'Tuyệt! Bạn đã đạt mục tiêu hôm nay 🎉',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Ring % bên phải
                _AnimatedRing(
                  size: size,
                  thickness: thickness,
                  progress: progress.toDouble(),
                  trackColor: Colors.white.withOpacity(0.15),
                  progressColor: cs.primary, // màu chủ đạo của app
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Vòng tròn % có animation
class _AnimatedRing extends StatelessWidget {
  const _AnimatedRing({
    required this.size,
    required this.thickness,
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    this.labelStyle,
  });

  final double size;
  final double thickness;
  final double progress; // 0..1
  final Color trackColor;
  final Color progressColor;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (_, value, __) {
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size.square(size),
                painter: _RingPainter(
                  progress: value,
                  thickness: thickness,
                  trackColor: trackColor,
                  progressColor: progressColor,
                ),
              ),
              // Nhãn %
              Text(
                '${(value * 100).round()}%',
                style:
                    (Theme.of(context).textTheme.titleMedium ??
                            const TextStyle())
                        .merge(labelStyle),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Vẽ vòng tròn % với đầu bo tròn
class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.thickness,
    required this.trackColor,
    required this.progressColor,
  });

  final double progress; // 0..1
  final double thickness;
  final Color trackColor;
  final Color progressColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = (math.min(size.width, size.height) - thickness) / 2;

    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    final fg = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    // track
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.5, // bắt đầu từ đỉnh
      math.pi * 2,
      false,
      track,
    );

    // progress
    final sweep = progress * math.pi * 2;
    if (sweep > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi * 0.5,
        sweep,
        false,
        fg,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress ||
      old.thickness != thickness ||
      old.trackColor != trackColor ||
      old.progressColor != progressColor;
}

/// Pattern chấm mờ góc phải
class _HalftonePattern extends StatelessWidget {
  const _HalftonePattern();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _DotsPainter());
  }
}

class _DotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.08);
    const spacing = 8.0;
    const dot = 2.0;

    // Vẽ chấm ở nửa phải trên để giống mẫu
    final startX = size.width * 0.55;
    final endY = size.height * 0.55;

    for (double y = 8; y < endY; y += spacing) {
      for (double x = startX; x < size.width - 8; x += spacing) {
        canvas.drawCircle(Offset(x, y), dot, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotsPainter oldDelegate) => false;
}
