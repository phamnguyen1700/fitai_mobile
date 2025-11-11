// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  token: json['token'] as String?,
  onboardingStep: json['onboardingStep'] as String?,
  message: json['message'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  fullName: json['fullName'] as String?,
  profileImage: json['profileImage'] as String?,
  emailVerifiedAt: json['emailVerifiedAt'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  gender: $enumDecodeNullable(
    _$GenderEnumMap,
    json['gender'],
    unknownValue: Gender.M,
  ),
  dateOfBirth: _dateFromJson(json['dateOfBirth']),
  goal: $enumDecodeNullable(
    _$GoalEnumMap,
    json['goal'],
    unknownValue: Goal.Maintain_Weight,
  ),
  height: _toDouble(json['height']),
  weight: _toDouble(json['weight']),
  activityLevel: $enumDecodeNullable(
    _$ActivityLevelEnumMap,
    json['activityLevel'],
    unknownValue: ActivityLevel.Sedentary,
  ),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'token': instance.token,
  'onboardingStep': instance.onboardingStep,
  'message': instance.message,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'fullName': instance.fullName,
  'profileImage': instance.profileImage,
  'emailVerifiedAt': instance.emailVerifiedAt,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'gender': _$GenderEnumMap[instance.gender],
  'dateOfBirth': _dateToJson(instance.dateOfBirth),
  'goal': _$GoalEnumMap[instance.goal],
  'height': _doubleToNum(instance.height),
  'weight': _doubleToNum(instance.weight),
  'activityLevel': _$ActivityLevelEnumMap[instance.activityLevel],
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
