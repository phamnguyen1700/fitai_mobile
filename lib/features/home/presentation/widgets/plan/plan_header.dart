import 'package:flutter/material.dart';

/// Header: gồm 2 phần — Workout selector & Meal selector (mỗi phần có title riêng)
class PlanHeader extends StatelessWidget {
  final int workoutIndex; // 0 = 3 buổi, 1 = 4 buổi
  final ValueChanged<int> onWorkoutChanged;

  final int mealIndex; // 0 = Nam, 1 = Nữ
  final ValueChanged<int> onMealChanged;

  const PlanHeader({
    super.key,
    required this.workoutIndex,
    required this.onWorkoutChanged,
    required this.mealIndex,
    required this.onMealChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    Widget chip({
      required String title,
      required String subtitle,
      required bool selected,
      required VoidCallback onTap,
    }) {
      return Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            decoration: BoxDecoration(
              color: selected ? cs.primary : cs.outlineVariant,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected ? cs.primary : cs.outlineVariant,
              ),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (selected) ...[
                      const Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      title,
                      style: t.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: selected ? cs.onPrimary : cs.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: t.bodySmall?.copyWith(
                    color: selected
                        ? cs.onPrimary.withOpacity(.9)
                        : cs.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====== WORKOUT SECTION ======
          Text(
            'Workout Demo · Chọn lịch mẫu',
            style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              chip(
                title: '3 buổi / tuần',
                subtitle: 'Push · Pull · Legs',
                selected: workoutIndex == 0,
                onTap: () => onWorkoutChanged(0),
              ),
              const SizedBox(width: 8),
              chip(
                title: '4 buổi / tuần',
                subtitle: 'Upper · Lower · Split',
                selected: workoutIndex == 1,
                onTap: () => onWorkoutChanged(1),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ====== MEAL SECTION ======
          Text(
            'Meal Demo · Chọn menu mẫu',
            style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              chip(
                title: 'Nam',
                subtitle: '2300 kcal / ngày',
                selected: mealIndex == 0,
                onTap: () => onMealChanged(0),
              ),
              const SizedBox(width: 8),
              chip(
                title: 'Nữ',
                subtitle: '1600 kcal / ngày',
                selected: mealIndex == 1,
                onTap: () => onMealChanged(1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
