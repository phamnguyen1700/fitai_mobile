// lib/features/ai/presentation/widgets/workout/workout_day_selector.dart
import 'package:flutter/material.dart';
import 'package:fitai_mobile/features/home/presentation/widgets/workout/workout_card.dart';

class WorkoutScheduleDay {
  final int dayNumber;
  final String dayName;
  final int totalExercises;

  const WorkoutScheduleDay({
    required this.dayNumber,
    required this.dayName,
    required this.totalExercises,
  });

  factory WorkoutScheduleDay.fromJson(Map<String, dynamic> json) {
    return WorkoutScheduleDay(
      dayNumber: json['dayNumber'] as int,
      dayName: json['dayName'] as String,
      totalExercises: json['totalExercises'] as int,
    );
  }
}

class WorkoutDaySelector extends StatelessWidget {
  final List<WorkoutScheduleDay> days;
  final int? selectedDayNumber;

  final ValueChanged<int>? onDaySelected;

  const WorkoutDaySelector({
    super.key,
    required this.days,
    this.selectedDayNumber,
    this.onDaySelected,
  });

  double _localTextScale(BuildContext context) {
    final media = MediaQuery.of(context);
    final shortest = media.size.shortestSide;

    if (shortest < 340) return 0.92; // máy mini
    if (shortest < 380) return 0.96; // máy hẹp
    return 1.0; // máy bình thường
  }

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) return const SizedBox.shrink();

    final scale = _localTextScale(context);

    return Column(
      children: [
        for (final day in days)
          MediaQuery(
            // 👇 Scale text theo kích thước máy (thêm vào global scale)
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(scale)),
            child: WorkoutDayCard(
              dayTitle: 'Day ${day.dayNumber}',
              featuredTitle: day.dayName,
              totalExercises: day.totalExercises,
              isSelected: day.dayNumber == selectedDayNumber,
              onTap: () => onDaySelected?.call(day.dayNumber),
            ),
          ),
      ],
    );
  }
}
