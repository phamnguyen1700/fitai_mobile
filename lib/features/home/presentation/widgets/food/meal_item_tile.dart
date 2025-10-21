import 'package:flutter/material.dart';
import 'meal_day_card.dart';

/// Hiển thị 1 nhóm bữa ăn (Meal 1, Meal 2,...)
class MealGroupTile extends StatelessWidget {
  final MealGroup group;
  final int index;
  const MealGroupTile({super.key, required this.group, required this.index});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header "Meal 1 – Sáng"
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Meal $index',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 8),
            Text(group.title, style: TextStyle(color: cs.onSurfaceVariant)),
          ],
        ),
        const SizedBox(height: 8),

        // danh sách món trong bữa
        for (final item in group.items) MealItemTile(item: item),
      ],
    );
  }
}

/// 1 món ăn: tên + các thành phần/định lượng (không có ảnh)
class MealItemTile extends StatelessWidget {
  final MealItem item;
  const MealItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          ...item.portions.entries.map(
            (e) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(e.key, style: TextStyle(color: cs.onSurface)),
                Text(e.value, style: TextStyle(color: cs.onSurface)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
