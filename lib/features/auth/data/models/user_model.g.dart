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
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  fullName: json['full_name'] as String?,
  profileImage: json['profile_image'] as String?,
  emailVerifiedAt: json['email_verified_at'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'token': instance.token,
  'onboardingStep': instance.onboardingStep,
  'message': instance.message,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'full_name': instance.fullName,
  'profile_image': instance.profileImage,
  'email_verified_at': instance.emailVerifiedAt,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
