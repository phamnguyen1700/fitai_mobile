// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_mealplan_with_target_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenerateMealPlanWithTargetCoreData _$GenerateMealPlanWithTargetCoreDataFromJson(
  Map<String, dynamic> json,
) => GenerateMealPlanWithTargetCoreData(
  dailyMeals: (json['dailyMeals'] as List<dynamic>)
      .map((e) => DailyMealPlan.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GenerateMealPlanWithTargetCoreDataToJson(
  GenerateMealPlanWithTargetCoreData instance,
) => <String, dynamic>{
  'dailyMeals': instance.dailyMeals.map((e) => e.toJson()).toList(),
};

GenerateMealPlanWithTargetData _$GenerateMealPlanWithTargetDataFromJson(
  Map<String, dynamic> json,
) => GenerateMealPlanWithTargetData(
  processingTime: json['processingTime'] as String,
  targetCalories: (json['targetCalories'] as num).toInt(),
  data: GenerateMealPlanWithTargetCoreData.fromJson(
    json['data'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$GenerateMealPlanWithTargetDataToJson(
  GenerateMealPlanWithTargetData instance,
) => <String, dynamic>{
  'processingTime': instance.processingTime,
  'targetCalories': instance.targetCalories,
  'data': instance.data.toJson(),
};

GenerateMealPlanWithTargetResponse _$GenerateMealPlanWithTargetResponseFromJson(
  Map<String, dynamic> json,
) => GenerateMealPlanWithTargetResponse(
  data: json['data'] == null
      ? null
      : GenerateMealPlanWithTargetData.fromJson(
          json['data'] as Map<String, dynamic>,
        ),
  success: json['success'] as bool,
  message: json['message'] as String?,
);

Map<String, dynamic> _$GenerateMealPlanWithTargetResponseToJson(
  GenerateMealPlanWithTargetResponse instance,
) => <String, dynamic>{
  'data': instance.data?.toJson(),
  'success': instance.success,
  'message': instance.message,
};
