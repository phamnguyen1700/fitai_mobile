import 'package:json_annotation/json_annotation.dart';

part 'meal_comments_models.g.dart';

@JsonSerializable(explicitToJson: true)
class MealCommentsResponse {
  final MealCommentsData data;
  final bool success;
  final String message;

  MealCommentsResponse({
    required this.data,
    required this.success,
    required this.message,
  });

  factory MealCommentsResponse.fromJson(Map<String, dynamic> json) =>
      _$MealCommentsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MealCommentsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MealCommentsData {
  final String mealLogId;
  final String mealType;
  final int dayNumber;
  final List<MealLogComment> comments;

  MealCommentsData({
    required this.mealLogId,
    required this.mealType,
    required this.dayNumber,
    required this.comments,
  });

  factory MealCommentsData.fromJson(Map<String, dynamic> json) =>
      _$MealCommentsDataFromJson(json);

  Map<String, dynamic> toJson() => _$MealCommentsDataToJson(this);
}

@JsonSerializable()
class MealLogComment {
  final String id;
  final String senderName;
  final String senderType;
  final String content;
  final String? senderAvatarUrl;

  MealLogComment({
    required this.id,
    required this.senderName,
    required this.senderType,
    required this.content,
    this.senderAvatarUrl,
  });

  factory MealLogComment.fromJson(Map<String, dynamic> json) =>
      _$MealLogCommentFromJson(json);

  Map<String, dynamic> toJson() => _$MealLogCommentToJson(this);
}
