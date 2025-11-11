import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BodyCompositionDonut extends StatelessWidget {
  const BodyCompositionDonut({
    super.key,
    required this.fatPercent,
    required this.musclePercent,
    required this.bonePercent,
    this.size = 150, // ✅ giảm từ 180 → 150
    this.sectionSpace = 2,
    this.centerHole = 38, // ✅ tăng lỗ giữa để donut mỏng hơn
    this.showLegend = true,
  });

  final double fatPercent;
  final double musclePercent;
  final double bonePercent;

  final double size;
  final double sectionSpace;
  final double centerHole;
  final bool showLegend;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final total = (fatPercent + musclePercent + bonePercent).clamp(0, 100);
    final valid = total > 0;

    final fatColor = cs.tertiary;
    final muscleColor = cs.primary;
    final boneColor = cs.secondary;

    List<PieChartSectionData> sections() {
      if (!valid) {
        return [
          PieChartSectionData(
            value: 1,
            color: cs.surfaceVariant,
            showTitle: false,
          ),
        ];
      }
      return [
        _slice(
          value: fatPercent,
          color: fatColor,
          label: '${fatPercent.toStringAsFixed(1)}%',
        ),
        _slice(
          value: musclePercent,
          color: muscleColor,
          label: '${musclePercent.toStringAsFixed(1)}%',
        ),
        _slice(
          value: bonePercent,
          color: boneColor,
          label: '${bonePercent.toStringAsFixed(1)}%',
        ),
      ];
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: PieChart(
            PieChartData(
              sections: sections(),
              sectionsSpace: sectionSpace,
              centerSpaceRadius: centerHole,
              startDegreeOffset: -90,
              borderData: FlBorderData(show: false),
              pieTouchData: PieTouchData(enabled: false),
            ),
          ),
        ),
        if (showLegend) const SizedBox(height: 12), // ✅ tăng khoảng cách legend
        if (showLegend)
          Wrap(
            spacing: 16,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: [
              _legendDot(
                cs: cs,
                color: fatColor,
                label: 'Mỡ cơ thể',
                value: fatPercent,
              ),
              _legendDot(
                cs: cs,
                color: muscleColor,
                label: 'Khối cơ',
                value: musclePercent,
              ),
              _legendDot(
                cs: cs,
                color: boneColor,
                label: 'Khối xương',
                value: bonePercent,
              ),
            ],
          ),
        const SizedBox(height: 6),
        if (valid)
          Text(
            'Tổng: ${total.toStringAsFixed(1)}%',
            style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
          ),
      ],
    );
  }

  PieChartSectionData _slice({
    required double value,
    required Color color,
    required String label,
  }) {
    return PieChartSectionData(
      value: value <= 0 ? 0.0001 : value,
      color: color,
      showTitle: true,
      title: label,
      titleStyle: const TextStyle(
        fontSize: 10, // ✅ nhỏ hơn
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titlePositionPercentageOffset: 0.7, // ✅ đẩy text ra xa tâm
      radius: 45, // ✅ nhỏ hơn, vừa với size 150
    );
  }

  Widget _legendDot({
    required ColorScheme cs,
    required Color color,
    required String label,
    required double value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          '$label • ${value.toStringAsFixed(1)}%',
          style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
        ),
      ],
    );
  }
}
