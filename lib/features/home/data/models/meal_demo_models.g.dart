// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_demo_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealDemoListResponse _$MealDemoListResponseFromJson(
  Map<String, dynamic> json,
) => MealDemoListResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: (json['data'] as List<dynamic>)
      .map((e) => MealDemo.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalCount: (json['totalCount'] as num).toInt(),
  pageNumber: (json['pageNumber'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
);

Map<String, dynamic> _$MealDemoListResponseToJson(
  MealDemoListResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data.map((e) => e.toJson()).toList(),
  'totalCount': instance.totalCount,
  'pageNumber': instance.pageNumber,
  'pageSize': instance.pageSize,
};

MealDemo _$MealDemoFromJson(Map<String, dynamic> json) => MealDemo(
  id: json['id'] as String,
  planName: json['planName'] as String,
  gender: json['gender'] as String,
  maxDailyCalories: (json['maxDailyCalories'] as num).toInt(),
  goal: json['goal'] as String,
  totalMenus: (json['totalMenus'] as num).toInt(),
  isDeleted: json['isDeleted'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$MealDemoToJson(MealDemo instance) => <String, dynamic>{
  'id': instance.id,
  'planName': instance.planName,
  'gender': instance.gender,
  'maxDailyCalories': instance.maxDailyCalories,
  'goal': instance.goal,
  'totalMenus': instance.totalMenus,
  'isDeleted': instance.isDeleted,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

MealDemoDetailResponse _$MealDemoDetailResponseFromJson(
  Map<String, dynamic> json,
) => MealDemoDetailResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: (json['data'] as List<dynamic>)
      .map((e) => MealDemoDetail.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MealDemoDetailResponseToJson(
  MealDemoDetailResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data.map((e) => e.toJson()).toList(),
};

MealDemoDetail _$MealDemoDetailFromJson(Map<String, dynamic> json) =>
    MealDemoDetail(
      id: json['id'] as String,
      mealDemoId: json['mealDemoId'] as String,
      menuNumber: (json['menuNumber'] as num).toInt(),
      sessions: (json['sessions'] as List<dynamic>)
          .map((e) => MealSession.fromJson(e as Map<String, dynamic>))
          .toList(),
      isDeleted: json['isDeleted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      totalCalories: _doubleFromJson(json['totalCalories']),
      totalCarbs: _doubleFromJson(json['totalCarbs']),
      totalProtein: _doubleFromJson(json['totalProtein']),
      totalFat: _doubleFromJson(json['totalFat']),
    );

Map<String, dynamic> _$MealDemoDetailToJson(MealDemoDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mealDemoId': instance.mealDemoId,
      'menuNumber': instance.menuNumber,
      'sessions': instance.sessions.map((e) => e.toJson()).toList(),
      'isDeleted': instance.isDeleted,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'totalCalories': _doubleToJson(instance.totalCalories),
      'totalCarbs': _doubleToJson(instance.totalCarbs),
      'totalProtein': _doubleToJson(instance.totalProtein),
      'totalFat': _doubleToJson(instance.totalFat),
    };

MealSession _$MealSessionFromJson(Map<String, dynamic> json) => MealSession(
  sessionName: json['sessionName'] as String,
  ingredients: (json['ingredients'] as List<dynamic>)
      .map((e) => MealIngredient.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MealSessionToJson(MealSession instance) =>
    <String, dynamic>{
      'sessionName': instance.sessionName,
      'ingredients': instance.ingredients.map((e) => e.toJson()).toList(),
    };

MealIngredient _$MealIngredientFromJson(Map<String, dynamic> json) =>
    MealIngredient(
      name: json['name'] as String,
      weight: _doubleFromJson(json['weight']),
      calories: _doubleFromJson(json['calories']),
      carbs: _doubleFromJson(json['carbs']),
      protein: _doubleFromJson(json['protein']),
      fat: _doubleFromJson(json['fat']),
      foodId: json['foodId'] as String?,
    );

Map<String, dynamic> _$MealIngredientToJson(MealIngredient instance) =>
    <String, dynamic>{
      'name': instance.name,
      'weight': _doubleToJson(instance.weight),
      'calories': _doubleToJson(instance.calories),
      'carbs': _doubleToJson(instance.carbs),
      'protein': _doubleToJson(instance.protein),
      'fat': _doubleToJson(instance.fat),
      'foodId': instance.foodId,
    };
