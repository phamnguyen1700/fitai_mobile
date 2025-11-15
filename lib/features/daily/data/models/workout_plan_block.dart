import 'package:json_annotation/json_annotation.dart';

part 'workout_plan_block.g.dart';

@JsonSerializable(explicitToJson: true)
class WorkoutPlanBlock {
  WorkoutPlanBlock({
    required this.title,
    required this.leftStat,
    required this.rightStat,
    required this.progress,
    required this.calories,
    required this.levels,
    required this.videoTitle,
    required this.videoThumb,
    required this.category,
    this.sets,
    this.reps,
    this.minutes,
    this.checked = false,
    this.selectedLevelIndex = 0,
  });

  // ===== DATA CŨ =====
  final String title;
  final String leftStat;
  final String rightStat;
  final double progress; // 0..1
  final int calories;
  final List<String> levels;
  final String videoTitle;
  final String videoThumb;

  bool checked;
  int selectedLevelIndex;

  // ===== DATA MỚI =====
  final String category;
  final int? sets;
  final int? reps;
  final int? minutes;

  // ===== JSON =====
  factory WorkoutPlanBlock.fromJson(Map<String, dynamic> json) =>
      _$WorkoutPlanBlockFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutPlanBlockToJson(this);
}
