import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  final bool success;
  final String message;
  final UserModel? data;

  // Legacy fields for backward compatibility
  @JsonKey(name: 'access_token')
  final String? accessToken;
  @JsonKey(name: 'token_type')
  final String? tokenType;
  @JsonKey(name: 'expires_in')
  final int? expiresIn;
  final UserModel? user;

  const AuthResponse({
    required this.success,
    required this.message,
    this.data,
    this.accessToken,
    this.tokenType,
    this.expiresIn,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);

  // Helper methods to get token and user from either new or legacy format
  String? get token => data?.token ?? accessToken;
  UserModel? get userData => data ?? user;

  @override
  String toString() {
    return 'AuthResponse(success: $success, message: $message, data: $data, token: $token)';
  }
}
