// lib/features/profile/presentation/widgets/progress_overview_card.dart
import 'package:flutter/material.dart';
import 'body_composition_donut.dart';

class ProgressOverviewCard extends StatelessWidget {
  const ProgressOverviewCard({
    super.key,
    required this.lastUpdated,
    required this.currentWeightKg,
    required this.fatPercent,
    required this.musclePercent,
    required this.bonePercent,
  });

  final DateTime lastUpdated;
  final double currentWeightKg;
  final double fatPercent;
  final double musclePercent;
  final double bonePercent;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tiến độ', style: tt.titleMedium),
            const SizedBox(height: 2),
            Text(
              'Cập nhật lần cuối: ${_fmt(lastUpdated)}',
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 12),

            // 2 chỉ số nhanh
            Row(
              children: [
                Expanded(
                  child: _kv(
                    'Cân nặng hiện tại',
                    '${currentWeightKg.toStringAsFixed(1)}kg',
                    cs.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _kv(
                    '% Mỡ cơ thể',
                    '${fatPercent.toStringAsFixed(1)}%',
                    cs.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Tab bar mô phỏng Figma (tuỳ chọn). Ở đây giữ đơn giản: “Cơ thể”
            Container(
              decoration: BoxDecoration(
                color: cs.surfaceVariant.withOpacity(.35),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(6),
              child: Row(
                children: [
                  _pill(context, label: 'Thành phần cơ thể', selected: true),
                  const SizedBox(width: 8),
                  _pill(
                    context,
                    label: 'Lịch sử tập luyện',
                    selected: false,
                    disabled: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Donut chart 3 thông số
            Center(
              child: BodyCompositionDonut(
                fatPercent: fatPercent,
                musclePercent: musclePercent,
                bonePercent: bonePercent,
                size: 200,
                centerHole: 52,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Widget _kv(String k, String v, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(k, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 6),
        Text(
          v,
          style: TextStyle(fontWeight: FontWeight.w700, color: color),
        ),
      ],
    );
  }

  Widget _pill(
    BuildContext context, {
    required String label,
    required bool selected,
    bool disabled = false,
  }) {
    final cs = Theme.of(context).colorScheme;
    final bg = selected ? cs.primary.withOpacity(.12) : Colors.transparent;
    final fg = selected
        ? cs.primary
        : cs.onSurfaceVariant.withOpacity(disabled ? .5 : 1);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, color: fg, fontWeight: FontWeight.w600),
      ),
    );
  }
}
