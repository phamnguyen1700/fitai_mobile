import 'package:json_annotation/json_annotation.dart';

part 'advisor_assign_models.g.dart';

/// Request body cho POST /api/advisor/assign-advisor
@JsonSerializable()
class AdvisorAssignRequest {
  final String userId;
  final String advisorId;

  const AdvisorAssignRequest({required this.userId, required this.advisorId});

  factory AdvisorAssignRequest.fromJson(Map<String, dynamic> json) =>
      _$AdvisorAssignRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AdvisorAssignRequestToJson(this);
}
