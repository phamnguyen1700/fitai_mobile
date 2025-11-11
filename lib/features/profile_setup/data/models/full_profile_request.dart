// lib/features/profile_setup/data/models/full_profile_request.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:fitai_mobile/features/auth/data/models/user_model.dart';
import 'package:fitai_mobile/features/profile_setup/presentation/widgets/user_data.dart';

part 'full_profile_request.g.dart';

@JsonSerializable()
class FullProfileRequest {
  final String firstName;
  final String lastName;
  final Gender gender;
  final DateTime dateOfBirth;
  final Goal goal;
  final double height;
  final double weight;
  final ActivityLevel activityLevel;

  const FullProfileRequest({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
    required this.goal,
    required this.height,
    required this.weight,
    required this.activityLevel,
  });

  factory FullProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$FullProfileRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FullProfileRequestToJson(this);
}

/// Map từ UI draft -> DTO gửi API
extension ProfileDraftToFullProfile on ProfileDraft {
  FullProfileRequest toFullProfileRequest() {
    return FullProfileRequest(
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      gender: gender!, // đã validate bên form
      dateOfBirth: dateOfBirth!,
      goal: goal!,
      height: height!,
      weight: weight!,
      activityLevel: activityLevel ?? ActivityLevel.Sedentary,
    );
  }
}
