// lib/features/daily/data/models/workout_comment_models.dart
import 'package:json_annotation/json_annotation.dart';

part 'workout_comments_models.g.dart';

/// ================= COMMON DTOs =================

/// 1 comment (dùng chung cho cả POST/GET/DELETE, cả advisorReview.comments)
@JsonSerializable()
class WorkoutCommentDto {
  final String id;

  /// "user" | "advisor" | ...
  final String senderType;

  /// Tùy API: có khi trả senderId, có khi senderName + senderAvatarUrl
  final String? senderId;
  final String? senderName;
  final String? senderAvatarUrl;

  final String content;

  /// Chỉ có trong POST (createdAt) hoặc có thể thêm sau này
  final DateTime? createdAt;

  WorkoutCommentDto({
    required this.id,
    required this.senderType,
    required this.content,
    this.senderId,
    this.senderName,
    this.senderAvatarUrl,
    this.createdAt,
  });

  factory WorkoutCommentDto.fromJson(Map<String, dynamic> json) =>
      _$WorkoutCommentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutCommentDtoToJson(this);
}

/// Advisor review block trong POST response
///
/// ```json
/// "advisorReview": {
///   "advisorId": "690b1197ed5c9adb8bfb2184",
///   "completionPercent": null,
///   "reviewedAt": null,
///   "comments": [ ... WorkoutCommentDto ... ]
/// }
/// ```
@JsonSerializable(explicitToJson: true)
class AdvisorReviewDto {
  final String advisorId;
  final double? completionPercent;
  final DateTime? reviewedAt;
  final List<WorkoutCommentDto> comments;

  AdvisorReviewDto({
    required this.advisorId,
    this.completionPercent,
    this.reviewedAt,
    this.comments = const [],
  });

  factory AdvisorReviewDto.fromJson(Map<String, dynamic> json) =>
      _$AdvisorReviewDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AdvisorReviewDtoToJson(this);
}

/// ================= DATA (data field) =================

/// data dùng cho GET / DELETE
///
/// ```json
/// "data": {
///   "exerciseLogId": "...",
///   "exerciseName": "Xe đạp tĩnh",
///   "comments": [ ... ]
/// }
/// ```
@JsonSerializable(explicitToJson: true)
class WorkoutExerciseCommentsData {
  final String exerciseLogId;
  final String exerciseName;
  final List<WorkoutCommentDto> comments;

  WorkoutExerciseCommentsData({
    required this.exerciseLogId,
    required this.exerciseName,
    this.comments = const [],
  });

  factory WorkoutExerciseCommentsData.fromJson(Map<String, dynamic> json) =>
      _$WorkoutExerciseCommentsDataFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutExerciseCommentsDataToJson(this);
}

/// data dùng cho POST (trả thêm workoutLogId, dayNumber, isCompleted, photoUrl, advisorReview, createdAt)
///
/// ```json
/// "data": {
///   "workoutLogId": "...",
///   "exerciseLogId": "...",
///   "exerciseName": "...",
///   "dayNumber": 0,
///   "isCompleted": true,
///   "photoUrl": "https://...",
///   "advisorReview": { ... },
///   "comments": [ ... ],
///   "createdAt": "2025-11-21T10:36:14.453Z"
/// }
/// ```
@JsonSerializable(explicitToJson: true)
class WorkoutCommentPostData {
  final String workoutLogId;
  final String exerciseLogId;
  final String exerciseName;
  final int dayNumber;
  final bool isCompleted;
  final String? photoUrl;
  final AdvisorReviewDto? advisorReview;
  final List<WorkoutCommentDto> comments;
  final DateTime createdAt;

  WorkoutCommentPostData({
    required this.workoutLogId,
    required this.exerciseLogId,
    required this.exerciseName,
    required this.dayNumber,
    required this.isCompleted,
    this.photoUrl,
    this.advisorReview,
    this.comments = const [],
    required this.createdAt,
  });

  factory WorkoutCommentPostData.fromJson(Map<String, dynamic> json) =>
      _$WorkoutCommentPostDataFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutCommentPostDataToJson(this);
}

/// ================= RESPONSE WRAPPERS =================

/// POST response
///
/// ```json
/// {
///   "data": { ... WorkoutCommentPostData ... },
///   "success": true,
///   "message": "Comment added successfully"
/// }
/// ```
@JsonSerializable(explicitToJson: true)
class WorkoutCommentPostResponse {
  final WorkoutCommentPostData data;
  final bool success;
  final String message;

  WorkoutCommentPostResponse({
    required this.data,
    required this.success,
    required this.message,
  });

  factory WorkoutCommentPostResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkoutCommentPostResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutCommentPostResponseToJson(this);
}

/// GET response
///
/// ```json
/// {
///   "data": { ... WorkoutExerciseCommentsData ... },
///   "success": true,
///   "message": "Comments retrieved successfully"
/// }
/// ```
@JsonSerializable(explicitToJson: true)
class WorkoutCommentGetResponse {
  final WorkoutExerciseCommentsData data;
  final bool success;
  final String message;

  WorkoutCommentGetResponse({
    required this.data,
    required this.success,
    required this.message,
  });

  factory WorkoutCommentGetResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkoutCommentGetResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutCommentGetResponseToJson(this);
}

/// DELETE response
///
/// ```json
/// {
///   "data": { ... WorkoutExerciseCommentsData (comments rỗng) ... },
///   "success": true,
///   "message": "Comment deleted successfully"
/// }
/// ```
@JsonSerializable(explicitToJson: true)
class WorkoutCommentDeleteResponse {
  final WorkoutExerciseCommentsData data;
  final bool success;
  final String message;

  WorkoutCommentDeleteResponse({
    required this.data,
    required this.success,
    required this.message,
  });

  factory WorkoutCommentDeleteResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkoutCommentDeleteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutCommentDeleteResponseToJson(this);
}

/// (Optional) body gửi khi add comment
@JsonSerializable()
class AddWorkoutCommentRequest {
  final String content;

  AddWorkoutCommentRequest({required this.content});

  factory AddWorkoutCommentRequest.fromJson(Map<String, dynamic> json) =>
      _$AddWorkoutCommentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddWorkoutCommentRequestToJson(this);
}
