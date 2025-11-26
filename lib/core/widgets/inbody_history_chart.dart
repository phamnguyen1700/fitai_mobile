// lib/core/widgets/inbody_history_chart.dart
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class InbodyRecord {
  final int checkpointNumber;
  final DateTime? measuredAt;

  final double weight;
  final double smm;
  final double pbf;

  /// URL ảnh chính diện (front)
  final String? frontImageUrl;

  /// URL ảnh bên hông (right)
  final String? rightImageUrl;

  InbodyRecord({
    required this.checkpointNumber,
    this.measuredAt,
    required this.weight,
    required this.smm,
    required this.pbf,
    this.frontImageUrl,
    this.rightImageUrl,
  });
}

class InbodyHistoryChart extends StatelessWidget {
  final List<InbodyRecord> data;

  const InbodyHistoryChart({super.key, required this.data});

  bool get hasData => data.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    if (!hasData) {
      return const Center(child: Text('Chưa có dữ liệu InBody'));
    }

    // X = checkpointNumber (CP1, CP2, ...)
    final widthPerPoint = 40.0;
    final minWidth = MediaQuery.of(context).size.width - 32; // trừ padding
    final chartWidth = max(minWidth, data.length * widthPerPoint);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lịch sử cơ thể',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: chartWidth,
              child: Column(
                children: [
                  _MetricLineChart(
                    label: 'Cân nặng',
                    unit: 'kg',
                    data: data,
                    selector: (r) => r.weight,
                    minY: _min(data.map((e) => e.weight)) - 1,
                    maxY: _max(data.map((e) => e.weight)) + 1,
                    showCheckpointLabels: false,
                  ),
                  const SizedBox(height: 8),
                  _MetricLineChart(
                    label: 'SMM',
                    unit: 'kg',
                    data: data,
                    selector: (r) => r.smm,
                    minY: _min(data.map((e) => e.smm)) - 1,
                    maxY: _max(data.map((e) => e.smm)) + 1,
                    showCheckpointLabels: false,
                  ),
                  const SizedBox(height: 8),
                  _MetricLineChart(
                    label: 'PBF',
                    unit: '%',
                    data: data,
                    selector: (r) => r.pbf,
                    minY: _min(data.map((e) => e.pbf)) - 1,
                    maxY: _max(data.map((e) => e.pbf)) + 1,
                    // Hàng cuối cùng hiển thị checkpoint dưới các dots
                    showCheckpointLabels: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static double _min(Iterable<double> values) =>
      values.reduce((a, b) => a < b ? a : b);

  static double _max(Iterable<double> values) =>
      values.reduce((a, b) => a > b ? a : b);
}

class _MetricLineChart extends StatelessWidget {
  final String label;
  final String unit;
  final List<InbodyRecord> data;
  final double Function(InbodyRecord) selector;
  final double minY;
  final double maxY;
  final bool showCheckpointLabels;

  const _MetricLineChart({
    required this.label,
    required this.unit,
    required this.data,
    required this.selector,
    required this.minY,
    required this.maxY,
    this.showCheckpointLabels = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    // X = checkpointNumber, Y = selector(record)
    final spots = data
        .map((r) => FlSpot(r.checkpointNumber.toDouble(), selector(r)))
        .toList();

    // Lấy min/max checkpoint để fit trục X
    final minCP = data
        .map((e) => e.checkpointNumber)
        .reduce((a, b) => a < b ? a : b)
        .toDouble();
    final maxCP = data
        .map((e) => e.checkpointNumber)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    String formatValue(double v) {
      if (label == 'PBF') {
        return v.toStringAsFixed(1); // %
      }
      return v.toStringAsFixed(1); // Cân nặng, SMM
    }

    return SizedBox(
      height: 95,
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: t.bodyMedium),
                  if (unit.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        '($unit)',
                        style: t.labelSmall?.copyWith(color: cs.primary),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: LineChart(
                LineChartData(
                  minX: minCP,
                  maxX: maxCP,
                  minY: minY,
                  maxY: maxY,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: (maxY - minY) / 2,
                    // Không set verticalInterval để tránh tự động tạo grid line cho tất cả số nguyên
                    // Thay vào đó dùng getDrawingVerticalLine để chỉ vẽ tại checkpoint
                    getDrawingVerticalLine: (value) {
                      // Chỉ vẽ grid line tại đúng vị trí checkpoint (số nguyên)
                      if (value % 1 != 0) {
                        return FlLine(
                          color: Colors.transparent,
                          strokeWidth: 0,
                        );
                      }
                      final cp = value.toInt();
                      final exists = data.any((r) => r.checkpointNumber == cp);
                      return FlLine(
                        color: exists
                            ? cs.outlineVariant.withOpacity(0.3)
                            : Colors.transparent,
                        strokeWidth: exists ? 1 : 0,
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: showCheckpointLabels,
                        reservedSize: showCheckpointLabels ? 22 : 0,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          // Chỉ hiển thị nếu giá trị là số nguyên chính xác
                          if (value % 1 != 0) {
                            return const SizedBox.shrink();
                          }

                          final cp = value.toInt();

                          // Chỉ hiển thị nếu checkpoint thực sự tồn tại trong data
                          final exists = data.any(
                            (r) => r.checkpointNumber == cp,
                          );
                          if (!exists) return const SizedBox.shrink();

                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'CP$cp',
                              style:
                                  t.labelSmall?.copyWith(
                                    fontSize: 9,
                                    color: cs.onSurfaceVariant,
                                  ) ??
                                  TextStyle(
                                    fontSize: 9,
                                    color: cs.onSurfaceVariant,
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: false,
                      barWidth: 2,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) {
                          final valueText = formatValue(spot.y);
                          return ValueDotPainter(
                            value: valueText,
                            textStyle:
                                t.labelSmall?.copyWith(
                                  fontSize: 9,
                                  color: cs.primary,
                                ) ??
                                TextStyle(fontSize: 9, color: cs.primary),
                            radius: 3,
                            color: cs.primary,
                            strokeWidth: 1,
                            strokeColor: cs.primary,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(show: false),
                      color: cs.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dot cam như cũ nhưng có thêm số nằm trên dot
class ValueDotPainter extends FlDotCirclePainter {
  final String value;
  final TextStyle textStyle;

  ValueDotPainter({
    required this.value,
    required this.textStyle,
    required double radius,
    required Color color,
    required double strokeWidth,
    required Color strokeColor,
  }) : super(
         radius: radius,
         color: color,
         strokeWidth: strokeWidth,
         strokeColor: strokeColor,
       );

  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    // vẽ dot gốc
    super.draw(canvas, spot, offsetInCanvas);

    // vẽ text phía trên dot
    final tp = TextPainter(
      text: TextSpan(text: value, style: textStyle),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();

    final textOffset = Offset(
      offsetInCanvas.dx - tp.width / 2,
      offsetInCanvas.dy - radius - 4 - tp.height,
    );

    tp.paint(canvas, textOffset);
  }

  @override
  Size getSize(FlSpot spot) {
    final base = super.getSize(spot);
    // tăng thêm chút chiều cao để đủ chỗ text
    return Size(base.width, base.height + 14);
  }
}
