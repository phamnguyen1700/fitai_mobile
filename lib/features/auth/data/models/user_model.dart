import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

enum Gender { M, F }

enum Goal { Weight_Loss, Weight_Gain, Maintain_Weight, Build_Muscle }

/// Enum map 1–1 với backend
enum ActivityLevel {
  @JsonValue('Sedentary')
  Sedentary,

  @JsonValue('LightlyActive')
  LightlyActive,

  @JsonValue('ModeratelyActive')
  ModeratelyActive,

  @JsonValue('VeryActive')
  VeryActive,

  @JsonValue('ExtraActive')
  ExtraActive,
}

@JsonSerializable()
class UserModel {
  // ——— Core ———
  final String id;
  final String email;
  final String? token;

  @JsonKey(name: 'onboardingStep')
  final String? onboardingStep;

  final String? message;

  // ——— Profile (camelCase) ———
  @JsonKey(name: 'firstName')
  final String? firstName;

  @JsonKey(name: 'lastName')
  final String? lastName;

  @JsonKey(name: 'fullName')
  final String? fullName;

  @JsonKey(name: 'profileImage')
  final String? profileImage;

  @JsonKey(name: 'emailVerifiedAt')
  final String? emailVerifiedAt;

  @JsonKey(name: 'createdAt')
  final String? createdAt;

  @JsonKey(name: 'updatedAt')
  final String? updatedAt;

  // ——— Health profile ———
  @JsonKey(unknownEnumValue: Gender.M)
  final Gender? gender;

  @JsonKey(name: 'dateOfBirth', fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime? dateOfBirth;

  @JsonKey(unknownEnumValue: Goal.Maintain_Weight)
  final Goal? goal;

  @JsonKey(fromJson: _toDouble, toJson: _doubleToNum)
  final double? height;

  @JsonKey(fromJson: _toDouble, toJson: _doubleToNum)
  final double? weight;

  @JsonKey(unknownEnumValue: ActivityLevel.Sedentary)
  final ActivityLevel? activityLevel;

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
    this.gender,
    this.dateOfBirth,
    this.goal,
    this.height,
    this.weight,
    this.activityLevel,
  });

  /// Backward-compatible: chấp nhận cả snake_case từ API cũ.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final normalized = {
      ...json,
      'onboardingStep': json['onboardingStep'] ?? json['onboarding_step'],
      'firstName': json['firstName'] ?? json['first_name'],
      'lastName': json['lastName'] ?? json['last_name'],
      'fullName': json['fullName'] ?? json['full_name'],
      'profileImage': json['profileImage'] ?? json['profile_image'],
      'emailVerifiedAt': json['emailVerifiedAt'] ?? json['email_verified_at'],
      'createdAt': json['createdAt'] ?? json['created_at'],
      'updatedAt': json['updatedAt'] ?? json['updated_at'],
      'dateOfBirth': json['dateOfBirth'] ?? json['date_of_birth'],
      'activityLevel': json['activityLevel'] ?? json['activity_level'],
    };
    return _$UserModelFromJson(normalized);
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  String toString() =>
      'UserModel(id: $id, email: $email, goal: $goal, activityLevel: $activityLevel)';
}

// ===== Helpers (top-level) =====
DateTime? _dateFromJson(Object? v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  return DateTime.tryParse(v.toString());
}

String? _dateToJson(DateTime? d) => d?.toUtc().toIso8601String();

double? _toDouble(Object? v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString());
}

num? _doubleToNum(double? v) => v;

// ===== Enum helpers: lấy value gửi API =====

// Dùng lại map do json_serializable sinh ra trong user_model.g.dart
extension GenderApiValue on Gender {
  String get apiValue => _$GenderEnumMap[this]!;
}

extension GoalApiValue on Goal {
  String get apiValue => _$GoalEnumMap[this]!;
}

extension ActivityLevelApiValue on ActivityLevel {
  String get apiValue => _$ActivityLevelEnumMap[this]!;
}
