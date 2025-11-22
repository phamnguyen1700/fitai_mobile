// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_comments_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutCommentDto _$WorkoutCommentDtoFromJson(Map<String, dynamic> json) =>
    WorkoutCommentDto(
      id: json['id'] as String,
      senderType: json['senderType'] as String,
      content: json['content'] as String,
      senderId: json['senderId'] as String?,
      senderName: json['senderName'] as String?,
      senderAvatarUrl: json['senderAvatarUrl'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$WorkoutCommentDtoToJson(WorkoutCommentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderType': instance.senderType,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'senderAvatarUrl': instance.senderAvatarUrl,
      'content': instance.content,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

AdvisorReviewDto _$AdvisorReviewDtoFromJson(Map<String, dynamic> json) =>
    AdvisorReviewDto(
      advisorId: json['advisorId'] as String,
      completionPercent: (json['completionPercent'] as num?)?.toDouble(),
      reviewedAt: json['reviewedAt'] == null
          ? null
          : DateTime.parse(json['reviewedAt'] as String),
      comments:
          (json['comments'] as List<dynamic>?)
              ?.map(
                (e) => WorkoutCommentDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$AdvisorReviewDtoToJson(AdvisorReviewDto instance) =>
    <String, dynamic>{
      'advisorId': instance.advisorId,
      'completionPercent': instance.completionPercent,
      'reviewedAt': instance.reviewedAt?.toIso8601String(),
      'comments': instance.comments.map((e) => e.toJson()).toList(),
    };

WorkoutExerciseCommentsData _$WorkoutExerciseCommentsDataFromJson(
  Map<String, dynamic> json,
) => WorkoutExerciseCommentsData(
  exerciseLogId: json['exerciseLogId'] as String,
  exerciseName: json['exerciseName'] as String,
  comments:
      (json['comments'] as List<dynamic>?)
          ?.map((e) => WorkoutCommentDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$WorkoutExerciseCommentsDataToJson(
  WorkoutExerciseCommentsData instance,
) => <String, dynamic>{
  'exerciseLogId': instance.exerciseLogId,
  'exerciseName': instance.exerciseName,
  'comments': instance.comments.map((e) => e.toJson()).toList(),
};

WorkoutCommentPostData _$WorkoutCommentPostDataFromJson(
  Map<String, dynamic> json,
) => WorkoutCommentPostData(
  workoutLogId: json['workoutLogId'] as String,
  exerciseLogId: json['exerciseLogId'] as String,
  exerciseName: json['exerciseName'] as String,
  dayNumber: (json['dayNumber'] as num).toInt(),
  isCompleted: json['isCompleted'] as bool,
  photoUrl: json['photoUrl'] as String?,
  advisorReview: json['advisorReview'] == null
      ? null
      : AdvisorReviewDto.fromJson(
          json['advisorReview'] as Map<String, dynamic>,
        ),
  comments:
      (json['comments'] as List<dynamic>?)
          ?.map((e) => WorkoutCommentDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$WorkoutCommentPostDataToJson(
  WorkoutCommentPostData instance,
) => <String, dynamic>{
  'workoutLogId': instance.workoutLogId,
  'exerciseLogId': instance.exerciseLogId,
  'exerciseName': instance.exerciseName,
  'dayNumber': instance.dayNumber,
  'isCompleted': instance.isCompleted,
  'photoUrl': instance.photoUrl,
  'advisorReview': instance.advisorReview?.toJson(),
  'comments': instance.comments.map((e) => e.toJson()).toList(),
  'createdAt': instance.createdAt.toIso8601String(),
};

WorkoutCommentPostResponse _$WorkoutCommentPostResponseFromJson(
  Map<String, dynamic> json,
) => WorkoutCommentPostResponse(
  data: WorkoutCommentPostData.fromJson(json['data'] as Map<String, dynamic>),
  success: json['success'] as bool,
  message: json['message'] as String,
);

Map<String, dynamic> _$WorkoutCommentPostResponseToJson(
  WorkoutCommentPostResponse instance,
) => <String, dynamic>{
  'data': instance.data.toJson(),
  'success': instance.success,
  'message': instance.message,
};

WorkoutCommentGetResponse _$WorkoutCommentGetResponseFromJson(
  Map<String, dynamic> json,
) => WorkoutCommentGetResponse(
  data: WorkoutExerciseCommentsData.fromJson(
    json['data'] as Map<String, dynamic>,
  ),
  success: json['success'] as bool,
  message: json['message'] as String,
);

Map<String, dynamic> _$WorkoutCommentGetResponseToJson(
  WorkoutCommentGetResponse instance,
) => <String, dynamic>{
  'data': instance.data.toJson(),
  'success': instance.success,
  'message': instance.message,
};

WorkoutCommentDeleteResponse _$WorkoutCommentDeleteResponseFromJson(
  Map<String, dynamic> json,
) => WorkoutCommentDeleteResponse(
  data: WorkoutExerciseCommentsData.fromJson(
    json['data'] as Map<String, dynamic>,
  ),
  success: json['success'] as bool,
  message: json['message'] as String,
);

Map<String, dynamic> _$WorkoutCommentDeleteResponseToJson(
  WorkoutCommentDeleteResponse instance,
) => <String, dynamic>{
  'data': instance.data.toJson(),
  'success': instance.success,
  'message': instance.message,
};

AddWorkoutCommentRequest _$AddWorkoutCommentRequestFromJson(
  Map<String, dynamic> json,
) => AddWorkoutCommentRequest(content: json['content'] as String);

Map<String, dynamic> _$AddWorkoutCommentRequestToJson(
  AddWorkoutCommentRequest instance,
) => <String, dynamic>{'content': instance.content};
