// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_comments_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealCommentsResponse _$MealCommentsResponseFromJson(
  Map<String, dynamic> json,
) => MealCommentsResponse(
  data: MealCommentsData.fromJson(json['data'] as Map<String, dynamic>),
  success: json['success'] as bool,
  message: json['message'] as String,
);

Map<String, dynamic> _$MealCommentsResponseToJson(
  MealCommentsResponse instance,
) => <String, dynamic>{
  'data': instance.data.toJson(),
  'success': instance.success,
  'message': instance.message,
};

MealCommentsData _$MealCommentsDataFromJson(Map<String, dynamic> json) =>
    MealCommentsData(
      mealLogId: json['mealLogId'] as String,
      mealType: json['mealType'] as String,
      dayNumber: (json['dayNumber'] as num).toInt(),
      comments: (json['comments'] as List<dynamic>)
          .map((e) => MealLogComment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MealCommentsDataToJson(MealCommentsData instance) =>
    <String, dynamic>{
      'mealLogId': instance.mealLogId,
      'mealType': instance.mealType,
      'dayNumber': instance.dayNumber,
      'comments': instance.comments.map((e) => e.toJson()).toList(),
    };

MealLogComment _$MealLogCommentFromJson(Map<String, dynamic> json) =>
    MealLogComment(
      id: json['id'] as String,
      senderName: json['senderName'] as String,
      senderType: json['senderType'] as String,
      content: json['content'] as String,
      senderAvatarUrl: json['senderAvatarUrl'] as String?,
    );

Map<String, dynamic> _$MealLogCommentToJson(MealLogComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderName': instance.senderName,
      'senderType': instance.senderType,
      'content': instance.content,
      'senderAvatarUrl': instance.senderAvatarUrl,
    };
