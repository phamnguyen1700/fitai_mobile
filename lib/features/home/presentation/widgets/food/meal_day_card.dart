import 'package:flutter/material.dart';
import '../../../../daily/data/models/meal_models.dart'; // <-- model chung
import 'meal_item_tile.dart';

class MealDayCard extends StatelessWidget {
  final String dayTitle;
  final List<MealGroup> meals;

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
