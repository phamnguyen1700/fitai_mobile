import 'package:json_annotation/json_annotation.dart';

// Dùng lại DailyMealPlan từ flow cũ
import 'package:fitai_mobile/features/home/data/models/chat_thread_models.dart'
    show DailyMealPlan;

part 'generate_mealplan_with_target_models.g.dart';

/// ===============================
/// Lớp core chứa mảng dailyMeals
/// ===============================
@JsonSerializable(explicitToJson: true)
class GenerateMealPlanWithTargetCoreData {
  final List<DailyMealPlan> dailyMeals;

  GenerateMealPlanWithTargetCoreData({required this.dailyMeals});

  factory GenerateMealPlanWithTargetCoreData.fromJson(
    Map<String, dynamic> json,
  ) => _$GenerateMealPlanWithTargetCoreDataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GenerateMealPlanWithTargetCoreDataToJson(this);
}

/// ===============================================
/// Lớp "data" cấp 1:
/// {
///   "processingTime": "...",
///   "targetCalories": 2400,
///   "data": { "dailyMeals": [...] }
/// }
/// ===============================================
@JsonSerializable(explicitToJson: true)
class GenerateMealPlanWithTargetData {
  final String processingTime;
  final int targetCalories;
  final GenerateMealPlanWithTargetCoreData data;

  GenerateMealPlanWithTargetData({
    required this.processingTime,
    required this.targetCalories,
    required this.data,
  });

  factory GenerateMealPlanWithTargetData.fromJson(Map<String, dynamic> json) =>
      _$GenerateMealPlanWithTargetDataFromJson(json);

  Map<String, dynamic> toJson() => _$GenerateMealPlanWithTargetDataToJson(this);
}

/// ===============================================
/// Response tổng:
/// {
///   "data": { ...GenerateMealPlanWithTargetData },
///   "success": true,
///   "message": "Meal plan generated successfully"
/// }
/// ===============================================
@JsonSerializable(explicitToJson: true)
class GenerateMealPlanWithTargetResponse {
  final GenerateMealPlanWithTargetData? data;
  final bool success;
  final String? message;

  GenerateMealPlanWithTargetResponse({
    this.data,
    required this.success,
    this.message,
  });

  factory GenerateMealPlanWithTargetResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$GenerateMealPlanWithTargetResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GenerateMealPlanWithTargetResponseToJson(this);
}
