// lib/features/xxx/data/models/process_models.dart
import 'package:json_annotation/json_annotation.dart';

part 'process_models.g.dart';

/// =======================
/// 1. PREVIOUS CHECKPOINT COMPLETION %
/// =======================

@JsonSerializable()
class PreviousCheckpointCompletionResponse {
  final CheckpointCompletionPercentData? data;
  final bool success;
  final String message;

  PreviousCheckpointCompletionResponse({
    this.data,
    required this.success,
    required this.message,
  });

  factory PreviousCheckpointCompletionResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$PreviousCheckpointCompletionResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PreviousCheckpointCompletionResponseToJson(this);
}

@JsonSerializable()
class CheckpointCompletionPercentData {
  /// % hoàn thành checkpoint trước (có thể null)
  final num? completionPercent;
  final int? checkpointNumber;
  final String? planId;
  final String? planName;
  final String? message;

  CheckpointCompletionPercentData({
    this.completionPercent,
    this.checkpointNumber,
    this.planId,
    this.planName,
    this.message,
  });

  factory CheckpointCompletionPercentData.fromJson(Map<String, dynamic> json) =>
      _$CheckpointCompletionPercentDataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CheckpointCompletionPercentDataToJson(this);
}

/// =======================
/// 2. PROGRESS LINE CHART
/// =======================

@JsonSerializable()
class ProgressLineChartResponse {
  final List<ProgressLineChartPoint> data;
  final bool success;
  final String message;

  ProgressLineChartResponse({
    required this.data,
    required this.success,
    required this.message,
  });

  factory ProgressLineChartResponse.fromJson(Map<String, dynamic> json) =>
      _$ProgressLineChartResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProgressLineChartResponseToJson(this);
}

@JsonSerializable()
class ProgressLineChartPoint {
  final int checkpointNumber;

  /// Thời điểm đo (ISO string)
  final DateTime measuredAt;

  /// Cân nặng (kg)
  final double weightKg;

  /// Skeletal Muscle Mass (backend đang trả số, có thể là gram hay kg tuỳ logic server)
  final double skeletalMuscleMass;

  /// Thực chất là % mỡ cơ thể, backend trả về key `fatPercentage`
  @JsonKey(name: 'fatPercentage')
  final double fatPercent;

  /// Có thể null nếu chưa có ảnh
  final String? frontImageUrl;
  final String? rightImageUrl;

  ProgressLineChartPoint({
    required this.checkpointNumber,
    required this.measuredAt,
    required this.weightKg,
    required this.skeletalMuscleMass,
    required this.fatPercent,
    this.frontImageUrl,
    this.rightImageUrl,
  });

  factory ProgressLineChartPoint.fromJson(Map<String, dynamic> json) =>
      _$ProgressLineChartPointFromJson(json);

  Map<String, dynamic> toJson() => _$ProgressLineChartPointToJson(this);
}

/// =======================
/// 3. BODY COMPOSITION PIE CHART
/// =======================

@JsonSerializable()
class BodyCompositionPieResponse {
  final BodyCompositionPieData? data;
  final bool success;
  final String message;

  BodyCompositionPieResponse({
    this.data,
    required this.success,
    required this.message,
  });

  factory BodyCompositionPieResponse.fromJson(Map<String, dynamic> json) =>
      _$BodyCompositionPieResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BodyCompositionPieResponseToJson(this);
}

@JsonSerializable()
class BodyCompositionPieData {
  /// % mỡ cơ thể hiện tại
  final double bodyFatPercent;

  /// % cơ xương hiện tại
  final double skeletalMusclePercent;

  /// % còn lại (các thành phần khác)
  final double remainingPercent;

  /// Ngưỡng mỡ thấp – good – cao (để vẽ vùng tham chiếu)
  final double fatLow;
  final double fatGood;
  final double fatHigh;

  /// Ngưỡng % cơ xương được coi là tốt
  final double muscleGood;

  BodyCompositionPieData({
    required this.bodyFatPercent,
    required this.skeletalMusclePercent,
    required this.remainingPercent,
    required this.fatLow,
    required this.fatGood,
    required this.fatHigh,
    required this.muscleGood,
  });

  factory BodyCompositionPieData.fromJson(Map<String, dynamic> json) =>
      _$BodyCompositionPieDataFromJson(json);

  Map<String, dynamic> toJson() => _$BodyCompositionPieDataToJson(this);
}
