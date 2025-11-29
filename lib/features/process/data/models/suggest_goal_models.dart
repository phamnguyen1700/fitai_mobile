import 'package:json_annotation/json_annotation.dart';

part 'suggest_goal_models.g.dart';

@JsonSerializable()
class SuggestGoalResponse {
  final SuggestGoalData data;
  final bool success;
  final String message;

  SuggestGoalResponse({
    required this.data,
    required this.success,
    required this.message,
  });

  factory SuggestGoalResponse.fromJson(Map<String, dynamic> json) =>
      _$SuggestGoalResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SuggestGoalResponseToJson(this);
}

@JsonSerializable()
class SuggestGoalData {
  final int goalType;
  final String goalName;
  final String goalNameVi;
  final bool needToChangePlan;

  SuggestGoalData({
    required this.goalType,
    required this.goalName,
    required this.goalNameVi,
    required this.needToChangePlan,
  });

  factory SuggestGoalData.fromJson(Map<String, dynamic> json) =>
      _$SuggestGoalDataFromJson(json);

  Map<String, dynamic> toJson() => _$SuggestGoalDataToJson(this);
}
