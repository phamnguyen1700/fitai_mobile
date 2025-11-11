// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'full_profile_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FullProfileRequest _$FullProfileRequestFromJson(Map<String, dynamic> json) =>
    FullProfileRequest(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      goal: $enumDecode(_$GoalEnumMap, json['goal']),
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      activityLevel: $enumDecode(_$ActivityLevelEnumMap, json['activityLevel']),
    );

Map<String, dynamic> _$FullProfileRequestToJson(FullProfileRequest instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'gender': _$GenderEnumMap[instance.gender]!,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'goal': _$GoalEnumMap[instance.goal]!,
      'height': instance.height,
      'weight': instance.weight,
      'activityLevel': _$ActivityLevelEnumMap[instance.activityLevel]!,
    };

const _$GenderEnumMap = {Gender.M: 'M', Gender.F: 'F'};

const _$GoalEnumMap = {
  Goal.Weight_Loss: 'Weight_Loss',
  Goal.Weight_Gain: 'Weight_Gain',
  Goal.Maintain_Weight: 'Maintain_Weight',
  Goal.Build_Muscle: 'Build_Muscle',
};

const _$ActivityLevelEnumMap = {
  ActivityLevel.Sedentary: 'Sedentary',
  ActivityLevel.LightlyActive: 'LightlyActive',
  ActivityLevel.ModeratelyActive: 'ModeratelyActive',
  ActivityLevel.VeryActive: 'VeryActive',
  ActivityLevel.ExtraActive: 'ExtraActive',
};
