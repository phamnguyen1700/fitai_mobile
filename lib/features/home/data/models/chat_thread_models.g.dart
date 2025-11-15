// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_thread_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatThreadResponse _$ChatThreadResponseFromJson(Map<String, dynamic> json) =>
    ChatThreadResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => ChatThread.fromJson(e as Map<String, dynamic>))
          .toList(),
      success: json['success'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$ChatThreadResponseToJson(ChatThreadResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'success': instance.success,
      'message': instance.message,
    };

ChatThread _$ChatThreadFromJson(Map<String, dynamic> json) => ChatThread(
  id: json['id'] as String,
  userId: json['userId'] as String,
  title: json['title'] as String,
  threadType: json['threadType'] as String,
  lastMessageAt: json['lastMessageAt'] as String?,
  deletedAt: json['deletedAt'] as String?,
);

Map<String, dynamic> _$ChatThreadToJson(ChatThread instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'threadType': instance.threadType,
      'lastMessageAt': instance.lastMessageAt,
      'deletedAt': instance.deletedAt,
    };

CreateChatThreadRequest _$CreateChatThreadRequestFromJson(
  Map<String, dynamic> json,
) => CreateChatThreadRequest(
  title: json['title'] as String?,
  threadType: json['threadType'] as String? ?? 'fitness',
);

Map<String, dynamic> _$CreateChatThreadRequestToJson(
  CreateChatThreadRequest instance,
) => <String, dynamic>{
  'title': instance.title,
  'threadType': instance.threadType,
};

CreateChatThreadResponse _$CreateChatThreadResponseFromJson(
  Map<String, dynamic> json,
) => CreateChatThreadResponse(
  data: CreateChatThreadData.fromJson(json['data'] as Map<String, dynamic>),
  success: json['success'] as bool,
  message: json['message'] as String,
);

Map<String, dynamic> _$CreateChatThreadResponseToJson(
  CreateChatThreadResponse instance,
) => <String, dynamic>{
  'data': instance.data,
  'success': instance.success,
  'message': instance.message,
};

CreateChatThreadData _$CreateChatThreadDataFromJson(
  Map<String, dynamic> json,
) => CreateChatThreadData(
  threadId: json['threadId'] as String,
  title: json['title'] as String,
  threadType: json['threadType'] as String,
  aiMessage: json['aiMessage'] as String,
);

Map<String, dynamic> _$CreateChatThreadDataToJson(
  CreateChatThreadData instance,
) => <String, dynamic>{
  'threadId': instance.threadId,
  'title': instance.title,
  'threadType': instance.threadType,
  'aiMessage': instance.aiMessage,
};

SendChatMessageRequest _$SendChatMessageRequestFromJson(
  Map<String, dynamic> json,
) => SendChatMessageRequest(
  role: json['role'] as String? ?? 'customer',
  content: json['content'] as String,
  data: json['data'] as String?,
);

Map<String, dynamic> _$SendChatMessageRequestToJson(
  SendChatMessageRequest instance,
) => <String, dynamic>{
  'role': instance.role,
  'content': instance.content,
  'data': instance.data,
};

SendChatMessageResponse _$SendChatMessageResponseFromJson(
  Map<String, dynamic> json,
) => SendChatMessageResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: ChatMessage.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SendChatMessageResponseToJson(
  SendChatMessageResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
  id: json['id'] as String,
  threadId: json['threadId'] as String,
  role: json['role'] as String,
  content: json['content'] as String,
  data: json['data'] == null
      ? null
      : ChatMessageMeta.fromJson(json['data'] as Map<String, dynamic>),
  createdAt: json['createdAt'] as String,
);

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'threadId': instance.threadId,
      'role': instance.role,
      'content': instance.content,
      'data': instance.data?.toJson(),
      'createdAt': instance.createdAt,
    };

ChatMessageMeta _$ChatMessageMetaFromJson(Map<String, dynamic> json) =>
    ChatMessageMeta(
      activityLevel: (json['activityLevel'] as num).toInt(),
      experienceLevel: (json['experienceLevel'] as num).toInt(),
      healthProblem: json['healthProblem'] as String,
      goal: json['goal'] as String,
      nextCheckPoint: (json['nextCheckPoint'] as num).toInt(),
      workoutDays: (json['workoutDays'] as num).toInt(),
      importantNote: json['importantNote'] as String,
      dietType: (json['dietType'] as num).toInt(),
    );

Map<String, dynamic> _$ChatMessageMetaToJson(ChatMessageMeta instance) =>
    <String, dynamic>{
      'activityLevel': instance.activityLevel,
      'experienceLevel': instance.experienceLevel,
      'healthProblem': instance.healthProblem,
      'goal': instance.goal,
      'nextCheckPoint': instance.nextCheckPoint,
      'workoutDays': instance.workoutDays,
      'importantNote': instance.importantNote,
      'dietType': instance.dietType,
    };
