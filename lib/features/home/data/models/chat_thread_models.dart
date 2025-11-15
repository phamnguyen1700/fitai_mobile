// lib/features/home/data/models/chat_thread_models.dart
import 'package:json_annotation/json_annotation.dart';

part 'chat_thread_models.g.dart';

/// =======================
/// GET /chatthreads
/// =======================

@JsonSerializable()
class ChatThreadResponse {
  final List<ChatThread> data;
  final bool success;
  final String message;

  ChatThreadResponse({
    required this.data,
    required this.success,
    required this.message,
  });

  factory ChatThreadResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatThreadResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatThreadResponseToJson(this);
}

@JsonSerializable()
class ChatThread {
  final String id;
  final String userId;
  final String title;
  final String threadType;
  final String? lastMessageAt;
  final String? deletedAt;

  ChatThread({
    required this.id,
    required this.userId,
    required this.title,
    required this.threadType,
    this.lastMessageAt,
    this.deletedAt,
  });

  factory ChatThread.fromJson(Map<String, dynamic> json) =>
      _$ChatThreadFromJson(json);

  Map<String, dynamic> toJson() => _$ChatThreadToJson(this);
}

/// =======================
/// POST /chatthreads  (tạo thread mới)
/// =======================

/// Body gửi:
/// {
///   "title": "",
///   "threadType": "fitness"
/// }
@JsonSerializable()
class CreateChatThreadRequest {
  final String? title;
  final String threadType;

  CreateChatThreadRequest({this.title, this.threadType = 'fitness'});

  factory CreateChatThreadRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateChatThreadRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateChatThreadRequestToJson(this);
}

/// Response:
/// {
///   "data": { ... },
///   "success": true,
///   "message": "Thread with AI created successfully"
/// }
@JsonSerializable()
class CreateChatThreadResponse {
  final CreateChatThreadData data;
  final bool success;
  final String message;

  CreateChatThreadResponse({
    required this.data,
    required this.success,
    required this.message,
  });

  factory CreateChatThreadResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateChatThreadResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateChatThreadResponseToJson(this);
}

@JsonSerializable()
class CreateChatThreadData {
  final String threadId;
  final String title;
  final String threadType;
  final String aiMessage;

  CreateChatThreadData({
    required this.threadId,
    required this.title,
    required this.threadType,
    required this.aiMessage,
  });

  factory CreateChatThreadData.fromJson(Map<String, dynamic> json) =>
      _$CreateChatThreadDataFromJson(json);

  Map<String, dynamic> toJson() => _$CreateChatThreadDataToJson(this);
}

/// =======================
/// POST /chatthreads/{threadId}/messages
/// =======================

/// Body gửi:
/// {
///   "role": "customer",
///   "content": "string",
///   "data": "string"
/// }
@JsonSerializable()
class SendChatMessageRequest {
  final String role;
  final String content;
  final String? data;

  SendChatMessageRequest({
    this.role = 'customer',
    required this.content,
    this.data,
  });

  factory SendChatMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$SendChatMessageRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SendChatMessageRequestToJson(this);
}

/// Response:
/// {
///   "success": true,
///   "message": "string",
///   "data": { ...ChatMessage... }
/// }
@JsonSerializable()
class SendChatMessageResponse {
  final bool success;
  final String message;
  final ChatMessage data;

  SendChatMessageResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SendChatMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$SendChatMessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendChatMessageResponseToJson(this);
}

/// data bên trong:
///
/// {
///   "id": "string",
///   "threadId": "string",
///   "role": "string",
///   "content": "string",
///   "data": { ...meta... },
///   "createdAt": "2025-11-15T12:45:16.217Z"
/// }
@JsonSerializable(explicitToJson: true)
class ChatMessage {
  final String id;
  final String threadId;
  final String role;
  final String content;
  final ChatMessageMeta? data;
  final String createdAt;

  ChatMessage({
    required this.id,
    required this.threadId,
    required this.role,
    required this.content,
    this.data,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}

/// meta:
/// {
///   "activityLevel": 0,
///   "experienceLevel": 0,
///   "healthProblem": "string",
///   "goal": "string",
///   "nextCheckPoint": 0,
///   "workoutDays": 0,
///   "importantNote": "string",
///   "dietType": 0
/// }
@JsonSerializable()
class ChatMessageMeta {
  final int activityLevel;
  final int experienceLevel;
  final String healthProblem;
  final String goal;
  final int nextCheckPoint;
  final int workoutDays;
  final String importantNote;
  final int dietType;

  ChatMessageMeta({
    required this.activityLevel,
    required this.experienceLevel,
    required this.healthProblem,
    required this.goal,
    required this.nextCheckPoint,
    required this.workoutDays,
    required this.importantNote,
    required this.dietType,
  });

  factory ChatMessageMeta.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageMetaFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageMetaToJson(this);
}
