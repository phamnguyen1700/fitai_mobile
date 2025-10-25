import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;
  @JsonKey(name: 'remember_me')
  final bool? rememberMe;
  @JsonKey(name: 'device_name')
  final String? deviceName;

  const LoginRequest({
    required this.email,
    required this.password,
    this.rememberMe,
    this.deviceName,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);

  @override
  String toString() {
    return 'LoginRequest(email: $email, rememberMe: $rememberMe, deviceName: $deviceName)';
  }
}