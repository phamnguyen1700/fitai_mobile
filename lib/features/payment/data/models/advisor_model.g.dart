// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advisor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdvisorModel _$AdvisorModelFromJson(Map<String, dynamic> json) => AdvisorModel(
  id: json['id'] as String,
  email: json['email'] as String,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  phone: json['phone'] as String?,
  bio: json['bio'] as String?,
  certifications: json['certifications'] as String?,
  specialties: json['specialties'] as String?,
  yearsExperience: (json['yearsExperience'] as num).toInt(),
  profilePicture: json['profilePicture'] as String?,
  availability: json['availability'] as String?,
  rating: (json['rating'] as num).toDouble(),
  isActive: json['isActive'] as bool,
  accountLockedUntil: json['accountLockedUntil'] == null
      ? null
      : DateTime.parse(json['accountLockedUntil'] as String),
  lastCreate: json['lastCreate'] == null
      ? null
      : DateTime.parse(json['lastCreate'] as String),
  lastUpdate: json['lastUpdate'] == null
      ? null
      : DateTime.parse(json['lastUpdate'] as String),
);

Map<String, dynamic> _$AdvisorModelToJson(AdvisorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'bio': instance.bio,
      'certifications': instance.certifications,
      'specialties': instance.specialties,
      'yearsExperience': instance.yearsExperience,
      'profilePicture': instance.profilePicture,
      'availability': instance.availability,
      'rating': instance.rating,
      'isActive': instance.isActive,
      'accountLockedUntil': instance.accountLockedUntil?.toIso8601String(),
      'lastCreate': instance.lastCreate?.toIso8601String(),
      'lastUpdate': instance.lastUpdate?.toIso8601String(),
    };
