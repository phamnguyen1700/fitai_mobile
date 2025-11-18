import 'package:json_annotation/json_annotation.dart';

part 'meal_plan_models.g.dart';

@JsonSerializable(explicitToJson: true)
class DailyMealsResponse {
  final MealDayData data;
  final bool success;
  final String message;

  DailyMealsResponse({
    required this.data,
    required this.success,
    required this.message,
  });

  factory DailyMealsResponse.fromJson(Map<String, dynamic> json) =>
      _$DailyMealsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DailyMealsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MealDayData {
  final int dayNumber;
  final int totalCalories;
  final int totalProtein;
  final int totalCarbs;
  final int totalFat;
  final List<MealEntry> meals;

  MealDayData({
    required this.dayNumber,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.meals,
  });

  factory MealDayData.empty({required int dayNumber}) => MealDayData(
    dayNumber: dayNumber,
    totalCalories: 0,
    totalProtein: 0,
    totalCarbs: 0,
    totalFat: 0,
    meals: const [],
  );

  factory MealDayData.fromJson(Map<String, dynamic> json) =>
      _$MealDayDataFromJson(json);

  Map<String, dynamic> toJson() => _$MealDayDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MealEntry {
  final String? mealLogId;
  final Meal meal;
  final bool isCompleted;
  final String? photoUrl;

  final AdvisorReview? advisorReview;

  MealEntry({
    this.mealLogId,
    required this.meal,
    required this.isCompleted,
    this.photoUrl,
    this.advisorReview,
  });

  factory MealEntry.fromJson(Map<String, dynamic> json) =>
      _$MealEntryFromJson(json);

  Map<String, dynamic> toJson() => _$MealEntryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Meal {
  final String type;
  final int calories;
  final MealNutrition nutrition;
  final List<FoodItem> foods;

  Meal({
    required this.type,
    required this.calories,
    required this.nutrition,
    required this.foods,
  });

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);

  Map<String, dynamic> toJson() => _$MealToJson(this);
}

@JsonSerializable()
class MealNutrition {
  final int carbs;
  final int protein;
  final int fat;
  final int fiber;
  final int sugar;

  MealNutrition({
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.fiber,
    required this.sugar,
  });

  factory MealNutrition.fromJson(Map<String, dynamic> json) =>
      _$MealNutritionFromJson(json);

  Map<String, dynamic> toJson() => _$MealNutritionToJson(this);
}

@JsonSerializable()
class FoodItem {
  final String name;
  final String quantity;
  final String? note;

  FoodItem({required this.name, required this.quantity, this.note});

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);

  Map<String, dynamic> toJson() => _$FoodItemToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AdvisorReview {
  final double? completionPercent;

  final String? advisorId;

  final DateTime? reviewedAt;

  final List<AdvisorComment>? comments;

  AdvisorReview({
    this.completionPercent,
    this.advisorId,
    this.reviewedAt,
    this.comments,
  });

  factory AdvisorReview.fromJson(Map<String, dynamic> json) =>
      _$AdvisorReviewFromJson(json);

  Map<String, dynamic> toJson() => _$AdvisorReviewToJson(this);
}

@JsonSerializable()
class AdvisorComment {
  final String? senderId;
  final String? senderType;
  final String? content;
  final DateTime? createdAt;

  AdvisorComment({
    this.senderId,
    this.senderType,
    this.content,
    this.createdAt,
  });

  factory AdvisorComment.fromJson(Map<String, dynamic> json) =>
      _$AdvisorCommentFromJson(json);

  Map<String, dynamic> toJson() => _$AdvisorCommentToJson(this);
}
