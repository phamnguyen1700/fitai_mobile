import 'package:flutter/material.dart';
import '../../../../daily/presentation/models/meal_models.dart';

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
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Meal',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 8),
            Text(group.title, style: TextStyle(color: cs.onSurfaceVariant)),
          ],
        ),
        const SizedBox(height: 8),
        for (final item in group.items) MealItemTile(item: item),
      ],
    );
  }
}

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
