// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyMealsResponse _$DailyMealsResponseFromJson(Map<String, dynamic> json) =>
    DailyMealsResponse(
      data: MealDayData.fromJson(json['data'] as Map<String, dynamic>),
      success: json['success'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$DailyMealsResponseToJson(DailyMealsResponse instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
      'success': instance.success,
      'message': instance.message,
    };

MealDayData _$MealDayDataFromJson(Map<String, dynamic> json) => MealDayData(
  dayNumber: (json['dayNumber'] as num).toInt(),
  totalCalories: (json['totalCalories'] as num).toInt(),
  totalProtein: (json['totalProtein'] as num).toInt(),
  totalCarbs: (json['totalCarbs'] as num).toInt(),
  totalFat: (json['totalFat'] as num).toInt(),
  meals: (json['meals'] as List<dynamic>)
      .map((e) => MealEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MealDayDataToJson(MealDayData instance) =>
    <String, dynamic>{
      'dayNumber': instance.dayNumber,
      'totalCalories': instance.totalCalories,
      'totalProtein': instance.totalProtein,
      'totalCarbs': instance.totalCarbs,
      'totalFat': instance.totalFat,
      'meals': instance.meals.map((e) => e.toJson()).toList(),
    };

MealEntry _$MealEntryFromJson(Map<String, dynamic> json) => MealEntry(
  mealLogId: json['mealLogId'] as String?,
  meal: Meal.fromJson(json['meal'] as Map<String, dynamic>),
  isCompleted: json['isCompleted'] as bool,
  photoUrl: json['photoUrl'] as String?,
  advisorReview: json['advisorReview'] == null
      ? null
      : AdvisorReview.fromJson(json['advisorReview'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MealEntryToJson(MealEntry instance) => <String, dynamic>{
  'mealLogId': instance.mealLogId,
  'meal': instance.meal.toJson(),
  'isCompleted': instance.isCompleted,
  'photoUrl': instance.photoUrl,
  'advisorReview': instance.advisorReview?.toJson(),
};

Meal _$MealFromJson(Map<String, dynamic> json) => Meal(
  type: json['type'] as String,
  calories: (json['calories'] as num).toInt(),
  nutrition: MealNutrition.fromJson(json['nutrition'] as Map<String, dynamic>),
  foods: (json['foods'] as List<dynamic>)
      .map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MealToJson(Meal instance) => <String, dynamic>{
  'type': instance.type,
  'calories': instance.calories,
  'nutrition': instance.nutrition.toJson(),
  'foods': instance.foods.map((e) => e.toJson()).toList(),
};

MealNutrition _$MealNutritionFromJson(Map<String, dynamic> json) =>
    MealNutrition(
      carbs: (json['carbs'] as num).toInt(),
      protein: (json['protein'] as num).toInt(),
      fat: (json['fat'] as num).toInt(),
      fiber: (json['fiber'] as num).toInt(),
      sugar: (json['sugar'] as num).toInt(),
    );

Map<String, dynamic> _$MealNutritionToJson(MealNutrition instance) =>
    <String, dynamic>{
      'carbs': instance.carbs,
      'protein': instance.protein,
      'fat': instance.fat,
      'fiber': instance.fiber,
      'sugar': instance.sugar,
    };

FoodItem _$FoodItemFromJson(Map<String, dynamic> json) => FoodItem(
  name: json['name'] as String,
  quantity: json['quantity'] as String,
  note: json['note'] as String?,
);

Map<String, dynamic> _$FoodItemToJson(FoodItem instance) => <String, dynamic>{
  'name': instance.name,
  'quantity': instance.quantity,
  'note': instance.note,
};

AdvisorReview _$AdvisorReviewFromJson(Map<String, dynamic> json) =>
    AdvisorReview(
      completionPercent: (json['completionPercent'] as num?)?.toDouble(),
      advisorId: json['advisorId'] as String?,
      reviewedAt: json['reviewedAt'] == null
          ? null
          : DateTime.parse(json['reviewedAt'] as String),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => AdvisorComment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AdvisorReviewToJson(AdvisorReview instance) =>
    <String, dynamic>{
      'completionPercent': instance.completionPercent,
      'advisorId': instance.advisorId,
      'reviewedAt': instance.reviewedAt?.toIso8601String(),
      'comments': instance.comments?.map((e) => e.toJson()).toList(),
    };

AdvisorComment _$AdvisorCommentFromJson(Map<String, dynamic> json) =>
    AdvisorComment(
      senderId: json['senderId'] as String?,
      senderType: json['senderType'] as String?,
      content: json['content'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AdvisorCommentToJson(AdvisorComment instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'senderType': instance.senderType,
      'content': instance.content,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
