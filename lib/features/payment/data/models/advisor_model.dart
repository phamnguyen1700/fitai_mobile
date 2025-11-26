import 'package:json_annotation/json_annotation.dart';

part 'advisor_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AdvisorModel {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? bio;
  final String? certifications;
  final String? specialties;
  final int yearsExperience;
  final String? profilePicture;
  final String? availability;
  final double rating;
  final bool isActive;
  final DateTime? accountLockedUntil;
  final DateTime? lastCreate;
  final DateTime? lastUpdate;

  const AdvisorModel({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.bio,
    this.certifications,
    this.specialties,
    required this.yearsExperience,
    this.profilePicture,
    this.availability,
    required this.rating,
    required this.isActive,
    this.accountLockedUntil,
    this.lastCreate,
    this.lastUpdate,
  });

  String get fullName {
    final f = firstName ?? '';
    final l = lastName ?? '';
    final combined = '$f $l'.trim();
    return combined.isEmpty ? email : combined;
  }

  factory AdvisorModel.fromJson(Map<String, dynamic> json) =>
      _$AdvisorModelFromJson(json);

  Map<String, dynamic> toJson() => _$AdvisorModelToJson(this);

  /// Helper: parse list từ response dạng `List<dynamic>`
  static List<AdvisorModel> listFromJson(dynamic data) {
    final list = (data as List).cast<Map<String, dynamic>>();
    return list.map(AdvisorModel.fromJson).toList();
  }
}
