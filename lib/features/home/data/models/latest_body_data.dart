// lib/features/home/data/models/latest_body_data_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'latest_body_data.g.dart';

@JsonSerializable()
class LatestBodyDataModel {
  final String? frontImageUrl;
  final String? rightImageUrl;

  final String? estimationId;
  final String? customScanId;

  final Map<String, dynamic>? measurements;
  final Map<String, dynamic>? bodyComposition;

  final bool status;
  final String userId;

  final String activityLevel;

  final double bmi;
  final double bmr;
  final double tdee;

  final int height;
  final double weight;

  final String id;
  final DateTime lastCreate;
  final DateTime lastUpdate;

  LatestBodyDataModel({
    this.frontImageUrl,
    this.rightImageUrl,
    this.estimationId,
    this.customScanId,
    this.measurements,
    this.bodyComposition,
    required this.status,
    required this.userId,
    required this.activityLevel,
    required this.bmi,
    required this.bmr,
    required this.tdee,
    required this.height,
    required this.weight,
    required this.id,
    required this.lastCreate,
    required this.lastUpdate,
  });

  factory LatestBodyDataModel.fromJson(Map<String, dynamic> json) =>
      _$LatestBodyDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$LatestBodyDataModelToJson(this);
}
