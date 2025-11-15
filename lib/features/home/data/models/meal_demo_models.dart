// lib/features/meal_demo/data/models/meal_demo_models.dart
import 'package:json_annotation/json_annotation.dart';

part 'meal_demo_models.g.dart';

double _doubleFromJson(Object? json) => (json as num?)?.toDouble() ?? 0;
Object _doubleToJson(double value) => value;

/// =====================
/// 1. LIST MEAL DEMO
/// =====================

@JsonSerializable(explicitToJson: true)
class MealDemoListResponse {
  final bool success;
  final String message;
  final List<MealDemo> data;
  final int totalCount;
  final int pageNumber;
  final int pageSize;

  MealDemoListResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
  });

  factory MealDemoListResponse.fromJson(Map<String, dynamic> json) =>
      _$MealDemoListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MealDemoListResponseToJson(this);
}

@JsonSerializable()
class MealDemo {
  final String id;
  final String planName;
  final String gender;
  final int maxDailyCalories;
  final String goal;
  final int totalMenus;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  MealDemo({
    required this.id,
    required this.planName,
    required this.gender,
    required this.maxDailyCalories,
    required this.goal,
    required this.totalMenus,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MealDemo.fromJson(Map<String, dynamic> json) =>
      _$MealDemoFromJson(json);

  Map<String, dynamic> toJson() => _$MealDemoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MealDemoDetailResponse {
  final bool success;
  final String message;
  final List<MealDemoDetail> data;

  MealDemoDetailResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MealDemoDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$MealDemoDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MealDemoDetailResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MealDemoDetail {
  final String id;
  final String mealDemoId;
  final int menuNumber;
  final List<MealSession> sessions;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)
  final double totalCalories;
  @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)
  final double totalCarbs;
  @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)
  final double totalProtein;
  @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)
  final double totalFat;

  MealDemoDetail({
    required this.id,
    required this.mealDemoId,
    required this.menuNumber,
    required this.sessions,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.totalCalories,
    required this.totalCarbs,
    required this.totalProtein,
    required this.totalFat,
  });

  factory MealDemoDetail.fromJson(Map<String, dynamic> json) =>
      _$MealDemoDetailFromJson(json);

  Map<String, dynamic> toJson() => _$MealDemoDetailToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MealSession {
  final String sessionName;
  final List<MealIngredient> ingredients;

  MealSession({required this.sessionName, required this.ingredients});

  factory MealSession.fromJson(Map<String, dynamic> json) =>
      _$MealSessionFromJson(json);

  Map<String, dynamic> toJson() => _$MealSessionToJson(this);
}

@JsonSerializable()
class MealIngredient {
  final String name;
  @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)
  final double weight;
  @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)
  final double calories;
  @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)
  final double carbs;
  @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)
  final double protein;
  @JsonKey(fromJson: _doubleFromJson, toJson: _doubleToJson)
  final double fat;
  final String? foodId;

  MealIngredient({
    required this.name,
    required this.weight,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    this.foodId,
  });

  factory MealIngredient.fromJson(Map<String, dynamic> json) =>
      _$MealIngredientFromJson(json);

  Map<String, dynamic> toJson() => _$MealIngredientToJson(this);
}
