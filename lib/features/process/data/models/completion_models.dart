import 'package:json_annotation/json_annotation.dart';

part 'completion_models.g.dart';

@JsonSerializable()
class CompletionPercentResponse {
  final CompletionPercentData? data;
  final bool success;
  final String? message;

  CompletionPercentResponse({
    required this.data,
    required this.success,
    required this.message,
  });

  factory CompletionPercentResponse.fromJson(Map<String, dynamic> json) =>
      _$CompletionPercentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CompletionPercentResponseToJson(this);
}

@JsonSerializable()
class CompletionPercentData {
  final double? completionPercent;
  final int checkpointNumber;
  final String planId;
  final String? planName;
  final String? message;

  CompletionPercentData({
    this.completionPercent,
    required this.checkpointNumber,
    required this.planId,
    this.planName,
    this.message,
  });

  factory CompletionPercentData.fromJson(Map<String, dynamic> json) =>
      _$CompletionPercentDataFromJson(json);

  Map<String, dynamic> toJson() => _$CompletionPercentDataToJson(this);
}
