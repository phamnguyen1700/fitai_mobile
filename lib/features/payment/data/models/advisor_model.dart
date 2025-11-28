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

  /// Backend trả: "specialties": ["yoga", ...]
  @JsonKey(defaultValue: [])
  final List<String> specialties;

  final int yearsExperience;
  final String? profilePicture;

  /// Chưa thấy backend trả, để nullable cho an toàn
  final String? availability;

  /// Backend chưa trả rating → để default = 0.0
  @JsonKey(defaultValue: 0.0)
  final double rating;

  final bool isActive;

  final DateTime? accountLockedUntil;
  final DateTime? lastCreate;
  final DateTime? lastUpdate;

  /// Backend có "totalCustomers"
  final int? totalCustomers;

  /// Backend có "customers": [...]
  @JsonKey(defaultValue: [])
  final List<AdvisorCustomer> customers;

  const AdvisorModel({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.bio,
    this.certifications,
    this.specialties = const [],
    required this.yearsExperience,
    this.profilePicture,
    this.availability,
    this.rating = 0.0,
    required this.isActive,
    this.accountLockedUntil,
    this.lastCreate,
    this.lastUpdate,
    this.totalCustomers,
    this.customers = const [],
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

/// =======================
/// Model cho customers
/// =======================
@JsonSerializable()
class AdvisorCustomer {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String? goal;
  final String subscriptionStatus;
  final DateTime? subscriptionStartDate;
  final DateTime? subscriptionEndDate;

  const AdvisorCustomer({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.goal,
    required this.subscriptionStatus,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
  });

  factory AdvisorCustomer.fromJson(Map<String, dynamic> json) =>
      _$AdvisorCustomerFromJson(json);

  Map<String, dynamic> toJson() => _$AdvisorCustomerToJson(this);
}
