import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final String? token;
  @JsonKey(name: 'onboardingStep')
  final String? onboardingStep;
  final String? message;
  @JsonKey(name: 'first_name')
  final String? firstName;
  @JsonKey(name: 'last_name')
  final String? lastName;
  @JsonKey(name: 'full_name')
  final String? fullName;
  @JsonKey(name: 'profile_image')
  final String? profileImage;
  @JsonKey(name: 'email_verified_at')
  final String? emailVerifiedAt;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    this.token,
    this.onboardingStep,
    this.message,
    this.firstName,
    this.lastName,
    this.fullName,
    this.profileImage,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, onboardingStep: $onboardingStep, message: $message)';
  }
}