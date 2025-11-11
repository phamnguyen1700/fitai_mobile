// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dietary_preference_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DietaryPreferenceRequest _$DietaryPreferenceRequestFromJson(
  Map<String, dynamic> json,
) => DietaryPreferenceRequest(
  mealsPerDay: (json['mealsPerDay'] as num).toInt(),
  cuisineType: json['cuisineType'] as String?,
  allergies: json['allergies'] as String?,
  avoidIngredients: json['avoidIngredients'] as String?,
  preferredIngredients: json['preferredIngredients'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$DietaryPreferenceRequestToJson(
  DietaryPreferenceRequest instance,
) => <String, dynamic>{
  'mealsPerDay': instance.mealsPerDay,
  'cuisineType': instance.cuisineType,
  'allergies': instance.allergies,
  'avoidIngredients': instance.avoidIngredients,
  'preferredIngredients': instance.preferredIngredients,
  'notes': instance.notes,
};
