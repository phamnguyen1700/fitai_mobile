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
  role: json['role'] as String? ?? 'user',
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

GetChatMessagesResponse _$GetChatMessagesResponseFromJson(
  Map<String, dynamic> json,
) => GetChatMessagesResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
      .toList(),
  success: json['success'] as bool,
  message: json['message'] as String,
);

Map<String, dynamic> _$GetChatMessagesResponseToJson(
  GetChatMessagesResponse instance,
) => <String, dynamic>{
  'data': instance.data.map((e) => e.toJson()).toList(),
  'success': instance.success,
  'message': instance.message,
};

AiHealthPlanCreateRequest _$AiHealthPlanCreateRequestFromJson(
  Map<String, dynamic> json,
) => AiHealthPlanCreateRequest(
  activityLevel: (json['activityLevel'] as num).toInt(),
  experienceLevel: (json['experienceLevel'] as num).toInt(),
  healthProblem: json['healthProblem'] as String,
  goal: json['goal'] as String,
  nextCheckPoint: (json['nextCheckPoint'] as num).toInt(),
  workoutDays: (json['workoutDays'] as num).toInt(),
  importantNote: json['importantNote'] as String,
  dietType: (json['dietType'] as num).toInt(),
);

Map<String, dynamic> _$AiHealthPlanCreateRequestToJson(
  AiHealthPlanCreateRequest instance,
) => <String, dynamic>{
  'activityLevel': instance.activityLevel,
  'experienceLevel': instance.experienceLevel,
  'healthProblem': instance.healthProblem,
  'goal': instance.goal,
  'nextCheckPoint': instance.nextCheckPoint,
  'workoutDays': instance.workoutDays,
  'importantNote': instance.importantNote,
  'dietType': instance.dietType,
};

AiHealthPlanCreateResponse _$AiHealthPlanCreateResponseFromJson(
  Map<String, dynamic> json,
) => AiHealthPlanCreateResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
);

Map<String, dynamic> _$AiHealthPlanCreateResponseToJson(
  AiHealthPlanCreateResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
};

MealPlanGenerateResponse _$MealPlanGenerateResponseFromJson(
  Map<String, dynamic> json,
) => MealPlanGenerateResponse(
  data: MealPlanGenerateData.fromJson(json['data'] as Map<String, dynamic>),
  success: json['success'] as bool,
  message: json['message'] as String,
);

Map<String, dynamic> _$MealPlanGenerateResponseToJson(
  MealPlanGenerateResponse instance,
) => <String, dynamic>{
  'data': instance.data.toJson(),
  'success': instance.success,
  'message': instance.message,
};

MealPlanGenerateData _$MealPlanGenerateDataFromJson(
  Map<String, dynamic> json,
) => MealPlanGenerateData(
  processingTime: json['processingTime'] as String,
  targetCalories: (json['targetCalories'] as num).toInt(),
  data: MealPlanCoreData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MealPlanGenerateDataToJson(
  MealPlanGenerateData instance,
) => <String, dynamic>{
  'processingTime': instance.processingTime,
  'targetCalories': instance.targetCalories,
  'data': instance.data.toJson(),
};

MealPlanCoreData _$MealPlanCoreDataFromJson(Map<String, dynamic> json) =>
    MealPlanCoreData(
      dailyMeals: (json['dailyMeals'] as List<dynamic>)
          .map((e) => DailyMealPlan.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MealPlanCoreDataToJson(MealPlanCoreData instance) =>
    <String, dynamic>{
      'dailyMeals': instance.dailyMeals.map((e) => e.toJson()).toList(),
    };

DailyMealPlan _$DailyMealPlanFromJson(Map<String, dynamic> json) =>
    DailyMealPlan(
      dayNumber: (json['dayNumber'] as num).toInt(),
      meals: (json['meals'] as List<dynamic>)
          .map((e) => MealItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DailyMealPlanToJson(DailyMealPlan instance) =>
    <String, dynamic>{
      'dayNumber': instance.dayNumber,
      'meals': instance.meals.map((e) => e.toJson()).toList(),
    };

MealItem _$MealItemFromJson(Map<String, dynamic> json) => MealItem(
  type: json['type'] as String,
  calories: (json['calories'] as num).toInt(),
  nutrition: MealNutrition.fromJson(json['nutrition'] as Map<String, dynamic>),
  foods: (json['foods'] as List<dynamic>)
      .map((e) => MealFood.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MealItemToJson(MealItem instance) => <String, dynamic>{
  'type': instance.type,
  'calories': instance.calories,
  'nutrition': instance.nutrition.toJson(),
  'foods': instance.foods.map((e) => e.toJson()).toList(),
};

MealNutrition _$MealNutritionFromJson(Map<String, dynamic> json) =>
    MealNutrition(
      carbs: (json['carbs'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      fiber: (json['fiber'] as num).toDouble(),
      sugar: (json['sugar'] as num).toDouble(),
    );

Map<String, dynamic> _$MealNutritionToJson(MealNutrition instance) =>
    <String, dynamic>{
      'carbs': instance.carbs,
      'protein': instance.protein,
      'fat': instance.fat,
      'fiber': instance.fiber,
      'sugar': instance.sugar,
    };

MealFood _$MealFoodFromJson(Map<String, dynamic> json) => MealFood(
  name: json['name'] as String,
  quantity: json['quantity'] as String,
);

Map<String, dynamic> _$MealFoodToJson(MealFood instance) => <String, dynamic>{
  'name': instance.name,
  'quantity': instance.quantity,
};
