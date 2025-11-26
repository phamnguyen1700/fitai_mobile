import 'package:json_annotation/json_annotation.dart';

part 'next_checkpoint_target_models.g.dart';

@JsonSerializable()
class NextCheckpointTarget {
  final double? expectedWeightChangeKg;
  final double? startWeightKg;
  final double? targetWeightKg;
  final String? goalText;
  final int? targetCaloriesPerDay;
  final String? nutritionText;

  NextCheckpointTarget({
    this.expectedWeightChangeKg,
    this.startWeightKg,
    this.targetWeightKg,
    this.goalText,
    this.targetCaloriesPerDay,
    this.nutritionText,
  });

  factory NextCheckpointTarget.fromJson(Map<String, dynamic> json) =>
      _$NextCheckpointTargetFromJson(json);

  Map<String, dynamic> toJson() => _$NextCheckpointTargetToJson(this);
}

@JsonSerializable()
class NextCheckpointTargetResponse {
  final NextCheckpointTarget? data;
  final bool success;
  final String? message;

  NextCheckpointTargetResponse({
    this.data,
    required this.success,
    this.message,
  });

  factory NextCheckpointTargetResponse.fromJson(Map<String, dynamic> json) =>
      _$NextCheckpointTargetResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NextCheckpointTargetResponseToJson(this);
}
