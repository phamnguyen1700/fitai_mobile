import 'package:flutter/material.dart';
import 'meal_item_tile.dart';

class MealDayCard extends StatelessWidget {
  final String dayTitle;
  final List<MealGroup> meals; // mỗi bữa (Meal 1, 2, 3,...)

  const MealDayCard({super.key, required this.dayTitle, required this.meals});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outlineVariant.withOpacity(0.5)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                dayTitle,
                style: t.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                  color: cs.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // các bữa trong ngày
            for (int i = 0; i < meals.length; i++) ...[
              MealGroupTile(group: meals[i], index: i + 1),
              if (i != meals.length - 1) Divider(height: 22, color: cs.outline),
            ],
          ],
        ),
      ),
    );
  }
}

/// Bữa ăn trong ngày (Meal 1, Meal 2,...)
class MealGroup {
  final String title; // ví dụ: "Sáng" / "Trưa" / "Tối"
  final List<MealItem> items; // danh sách món trong bữa
  MealGroup(this.title, this.items);
}

/// 1 món ăn (KHÔNG có hình)
class MealItem {
  final String name; // tên món
  final Map<String, String> portions; // thành phần -> định lượng
  MealItem(this.name, this.portions);
}
