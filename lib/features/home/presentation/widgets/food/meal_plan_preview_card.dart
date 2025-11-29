import 'package:flutter/material.dart';
import 'package:fitai_mobile/features/home/data/models/chat_thread_models.dart';

class MealPlanPreviewCard extends StatelessWidget {
  const MealPlanPreviewCard({
    super.key,
    required this.meal,
    this.onSelect,
    this.isSelected = false,
  });

  /// 1 bữa ăn trong plan (Breakfast / Lunch / Dinner / Snack...)
  final MealItem meal;

  /// callback khi bấm "Chọn" – để sau này gọi API đổi món
  final void Function(MealItem meal)? onSelect;

  /// Nếu muốn highlight bữa đã chọn
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    final nutrition = meal.nutrition;

    final kcal = meal.calories.toString();
    final carbs = nutrition.carbs.toString();
    final protein = nutrition.protein.toString();
    final fat = nutrition.fat.toString();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? cs.primary : cs.outlineVariant,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Header: Tên bữa ăn + kcal =====
          Row(
            children: [
              Expanded(
                child: Text(
                  meal.type,
                  style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              _MacroDot(
                color: Colors.orangeAccent, // giống hình demo
                label: '$kcal kcal',
                textStyle: t.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 6),

          // ===== Macro bữa ăn: C/P/F (không còn kcal) =====
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              _MacroDot(
                color: Colors.orangeAccent,
                label: 'Carb: $carbs g',
                textStyle: t.bodySmall,
              ),
              _MacroDot(
                color: Colors.lightGreenAccent,
                label: 'Protein: $protein g',
                textStyle: t.bodySmall,
              ),
              _MacroDot(
                color: Colors.cyanAccent,
                label: 'Fat: $fat g',
                textStyle: t.bodySmall,
              ),
            ],
          ),

          const SizedBox(height: 10),
          Divider(color: cs.outlineVariant, height: 16),

          _MealFoodsTable(foods: meal.foods),
          const SizedBox(height: 12),

          // // ===== Nút Chọn =====
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: OutlinedButton(
          //     onPressed: onSelect == null ? null : () => onSelect!(meal),
          //     style: OutlinedButton.styleFrom(
          //       side: BorderSide(color: cs.primary),
          //       padding: const EdgeInsets.symmetric(
          //         horizontal: 12,
          //         vertical: 6,
          //       ),
          //       minimumSize: const Size(0, 0),
          //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //     ),
          //     child: Text(
          //       isSelected ? 'Đã chọn' : 'Chọn',
          //       style: t.bodySmall?.copyWith(
          //         color: cs.primary,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

/// Bảng món ăn trong bữa
class _MealFoodsTable extends StatelessWidget {
  const _MealFoodsTable({required this.foods});

  final List<MealFood> foods;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    if (foods.isEmpty) {
      return Text(
        'Chưa có món trong bữa này.',
        style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final food in foods)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                Expanded(child: Text(food.name, style: t.bodySmall)),
                Text(
                  food.quantity,
                  style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _MacroDot extends StatelessWidget {
  const _MacroDot({required this.color, required this.label, this.textStyle});

  final Color color;
  final String label;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: textStyle),
      ],
    );
  }
}
