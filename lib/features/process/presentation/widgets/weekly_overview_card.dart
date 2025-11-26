// lib/features/process/presentation/widgets/weekly_overview_card.dart
import 'package:flutter/material.dart';

class WeeklyOverviewCard extends StatelessWidget {
  const WeeklyOverviewCard({
    super.key,
    this.weekEndDate,
    this.expectedWeightChangeKg,
    this.startWeightKg,
    this.targetWeightKg,
    this.goalText,
    this.targetCaloriesPerDay,
    this.nutritionText,
  });

  /// Ngày kết thúc tuần / ngày checkpoint tiếp theo (hiển thị góc phải)
  final DateTime? weekEndDate;

  /// Mục tiêu thay đổi cân nặng (ví dụ: -0.8kg)
  final double? expectedWeightChangeKg;

  /// Cân nặng bắt đầu & mục tiêu, để hiển thị (68.5 → 67.7kg)
  final double? startWeightKg;
  final double? targetWeightKg;

  /// Text mô tả mục tiêu (nếu backend trả về)
  final String? goalText;

  /// Mục tiêu kcal/ngày
  final double? targetCaloriesPerDay;

  /// Text mô tả nutrition (nếu backend trả về)
  final String? nutritionText;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final hasWeightInfo =
        expectedWeightChangeKg != null ||
        (startWeightKg != null && targetWeightKg != null);

    final hasNutritionInfo =
        targetCaloriesPerDay != null || nutritionText != null;

    final allNull = !hasWeightInfo && !hasNutritionInfo && goalText == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),

        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant.withOpacity(.35)),
          ),
          child: allNull
              ? _buildEmptyState(context)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==== Header row ====
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tổng kết tuần mới',
                                style: tt.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (goalText != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  goalText!,
                                  style: tt.bodySmall?.copyWith(
                                    color: cs.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (weekEndDate != null)
                          Text(
                            _fmtDate(weekEndDate!),
                            style: tt.labelSmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    if (hasWeightInfo) ...[
                      _rowLabelValue(
                        context,
                        label: 'Mục tiêu:',
                        value: _buildWeightLine(),
                        highlight: true,
                      ),
                      const SizedBox(height: 4),
                    ],

                    if (hasNutritionInfo)
                      _rowLabelValue(
                        context,
                        label: 'Nutrition:',
                        value: _buildNutritionLine(),
                        highlight: true,
                      ),
                  ],
                ),
        ),
      ],
    );
  }

  /// Khi chưa có dữ liệu từ API (tất cả null)
  Widget _buildEmptyState(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Tổng kết tuần mới',
                style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            if (weekEndDate != null)
              Text(
                _fmtDate(weekEndDate!),
                style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Khi kế hoạch tuần mới được tạo, mục tiêu và gợi ý dinh dưỡng sẽ xuất hiện tại đây.',
          style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
        ),
      ],
    );
  }

  /// Dòng text mục tiêu cân nặng, ví dụ:
  /// "-0.8kg (68.5 → 67.7kg)"
  String _buildWeightLine() {
    final change = expectedWeightChangeKg;
    final start = startWeightKg;
    final target = targetWeightKg;

    final parts = <String>[];

    if (change != null && change != 0) {
      final sign = change > 0 ? '+' : '';
      parts.add('$sign${change.toStringAsFixed(1)}kg');
    }

    if (start != null && target != null) {
      parts.add(
        '(${start.toStringAsFixed(1)} → ${target.toStringAsFixed(1)}kg)',
      );
    }

    if (parts.isEmpty) return 'Đang cập nhật...';

    return parts.join(' ');
  }

  /// Dòng text nutrition, ví dụ:
  /// "~1,900 kcal/ngày" + nutritionText nếu có
  String _buildNutritionLine() {
    final kcal = targetCaloriesPerDay;
    final nutri = nutritionText;

    final parts = <String>[];

    if (kcal != null) {
      // Làm tròn đẹp hơn: ví dụ 1897 -> 1,900 kcal/ngày
      final rounded = kcal.round();
      parts.add('~$rounded kcal/ngày');
    }

    if (nutri != null && nutri.trim().isNotEmpty) {
      parts.add(nutri.trim());
    }

    if (parts.isEmpty) return 'Đang cập nhật...';

    return parts.join(' – ');
  }

  Widget _rowLabelValue(
    BuildContext context, {
    required String label,
    required String value,
    bool highlight = false,
  }) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: tt.bodySmall),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: tt.bodySmall?.copyWith(
              color: highlight ? cs.primary : cs.onSurfaceVariant,
              fontWeight: highlight ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}
