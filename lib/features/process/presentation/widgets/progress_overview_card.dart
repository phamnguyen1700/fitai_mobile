// lib/features/profile/presentation/widgets/progress_overview_card.dart
import 'package:flutter/material.dart';

import '../../../../core/widgets/body_composition_donut.dart';
import '../../../../core/widgets/inbody_history_chart.dart'; // <-- line chart

class ProgressOverviewCard extends StatefulWidget {
  const ProgressOverviewCard({
    super.key,
    required this.lastUpdated,
    required this.currentWeightKg,
    required this.fatPercent,
    required this.musclePercent,
    required this.bonePercent,
    required this.inbodyHistory,
  });

  final DateTime lastUpdated;
  final double currentWeightKg;
  final double fatPercent;
  final double musclePercent;
  final double bonePercent;

  /// Dùng cho tab "Lịch sử tập luyện"
  final List<InbodyRecord> inbodyHistory;

  @override
  State<ProgressOverviewCard> createState() => _ProgressOverviewCardState();
}

class _ProgressOverviewCardState extends State<ProgressOverviewCard> {
  /// 0 = Thành phần cơ thể, 1 = Lịch sử tập luyện
  int _selectedTab = 0;

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
              'Cập nhật lần cuối: ${_fmt(widget.lastUpdated)}',
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 12),

            // 2 chỉ số nhanh
            Row(
              children: [
                Expanded(
                  child: _kv(
                    'Cân nặng hiện tại',
                    '${widget.currentWeightKg.toStringAsFixed(1)}kg',
                    cs.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _kv(
                    '% Mỡ cơ thể',
                    '${widget.fatPercent.toStringAsFixed(1)}%',
                    cs.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Tabs
            Container(
              decoration: BoxDecoration(
                color: cs.surfaceVariant.withOpacity(.35),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(6),
              child: Row(
                children: [
                  _pill(
                    context,
                    label: 'Thành phần cơ thể',
                    selected: _selectedTab == 0,
                    onTap: () => setState(() => _selectedTab = 0),
                  ),
                  const SizedBox(width: 8),
                  _pill(
                    context,
                    label: 'Lịch sử tập luyện',
                    selected: _selectedTab == 1,
                    onTap: () => setState(() => _selectedTab = 1),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Nội dung theo tab
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: _selectedTab == 0
                  ? Center(
                      key: const ValueKey('body-comp'),
                      child: BodyCompositionDonut(
                        fatPercent: widget.fatPercent,
                        musclePercent: widget.musclePercent,
                        bonePercent: widget.bonePercent,
                        size: 200,
                        centerHole: 52,
                      ),
                    )
                  : SizedBox(
                      key: const ValueKey('history'),
                      child: InbodyHistoryChart(data: widget.inbodyHistory),
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
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;
    final bg = selected ? cs.primary.withOpacity(.12) : Colors.transparent;
    final fg = selected ? cs.primary : cs.onSurfaceVariant;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: fg,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
