// lib/features/xxx/data/models/process_models.dart
import 'package:json_annotation/json_annotation.dart';

part 'process_models.g.dart';

/// =======================
/// 1. PREVIOUS CHECKPOINT COMPLETION %
/// =======================

/// Response tổng cho API:
/// GET /api/checkpoints/previous/completion-percent
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

/// Phần `data` bên trong previous completion percent
@JsonSerializable()
class CheckpointCompletionPercentData {
  /// % hoàn thành checkpoint trước (có thể null)
  final num? completionPercent;

  final int? checkpointNumber;
  final String? planId;
  final String? planName;

  /// Message riêng cho data
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

/// Response cho API line chart:
/// (ví dụ: GET /api/checkpoints/progress/line-chart)
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

/// Một điểm dữ liệu trên line chart (một checkpoint)
@JsonSerializable()
class ProgressLineChartPoint {
  final int checkpointNumber;

  /// Thời điểm đo (ISO string)
  final DateTime measuredAt;

  /// Cân nặng (kg)
  final double weightKg;

  /// Skeletal Muscle Mass
  final double skeletalMuscleMass;

  /// Lượng mỡ (kg)
  final double fatMassKg;

  /// Có thể null nếu chưa có ảnh
  final String? frontImageUrl;
  final String? rightImageUrl;

  ProgressLineChartPoint({
    required this.checkpointNumber,
    required this.measuredAt,
    required this.weightKg,
    required this.skeletalMuscleMass,
    required this.fatMassKg,
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

/// Response cho API pie chart:
/// ví dụ: GET /api/checkpoints/body-composition/pie
///
/// Sample:
/// {
///   "data": {
///     "bodyFatPercent": 15,
///     "skeletalMusclePercent": 47.19,
///     "remainingPercent": 37.80,
///     "fatLow": 10,
///     "fatGood": 18,
///     "fatHigh": 25,
///     "muscleGood": 40
///   },
///   "success": true,
///   "message": "Body composition data retrieved successfully"
/// }
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
