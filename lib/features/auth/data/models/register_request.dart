import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest {
  final String email;
  final String password;
  @JsonKey(name: 'password_confirmation')
  final String passwordConfirmation;
  @JsonKey(name: 'first_name')
  final String? firstName;
  @JsonKey(name: 'last_name')
  final String? lastName;
  @JsonKey(name: 'device_name')
  final String? deviceName;

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    this.firstName,
    this.lastName,
    this.deviceName,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);

  @override
  String toString() {
    return 'RegisterRequest(email: $email, firstName: $firstName, lastName: $lastName, deviceName: $deviceName)';
  }
}