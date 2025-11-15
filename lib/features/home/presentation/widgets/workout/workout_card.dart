// lib/features/ai/presentation/widgets/workout/workout_day_card.dart
import 'package:flutter/material.dart';

/// Hàng lịch tập theo mẫu:
/// [ Push ]  ●─  Cardio (30 phút)  |  3 bài
class WorkoutDayCard extends StatelessWidget {
  final String dayTitle; // "Push" / "Day 1 - Upper Body"
  final String featuredTitle; // ví dụ: "Cardio" / "Bench press"
  final String featuredMeta; // "30 phút" hoặc "3 sets × 12 reps"
  final int totalExercises; // số bài trong ngày
  final VoidCallback? onTap;
  final bool isSelected;

  const WorkoutDayCard({
    super.key,
    required this.dayTitle,
    required this.featuredTitle,
    required this.featuredMeta,
    required this.totalExercises,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700);
    final metaStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant);

    final borderColor = isSelected
        ? cs.primary
        : cs.outlineVariant.withOpacity(.6);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: isSelected ? 1.6 : 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _DayPill(text: dayTitle),
              const SizedBox(width: 10),
              _DotLine(color: cs.onSurface),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(featuredTitle, style: titleStyle),
                    const SizedBox(height: 4),
                    Text(featuredMeta, style: metaStyle),
                  ],
                ),
              ),
              SizedBox(
                height: 36,
                child: VerticalDivider(
                  width: 20,
                  thickness: 1,
                  color: cs.outline,
                ),
              ),
              _CountCol(total: totalExercises),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountCol extends StatelessWidget {
  final int total;
  const _CountCol({required this.total});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final big = Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800);
    final small = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$total', style: big),
        Text('bài', style: small),
      ],
    );
  }
}

class _DayPill extends StatelessWidget {
  final String text;
  const _DayPill({required this.text});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _DotLine extends StatelessWidget {
  final Color color;
  const _DotLine({required this.color});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      Container(
        width: 18,
        height: 2,
        margin: const EdgeInsets.only(left: 6),
        color: color,
      ),
    ],
  );
}
