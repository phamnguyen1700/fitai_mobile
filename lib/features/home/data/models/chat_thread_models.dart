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
///   "role": "user",
///   "content": "string",
///   "data": "string"
/// }
@JsonSerializable()
class SendChatMessageRequest {
  final String role;
  final String content;
  final String? data;

  SendChatMessageRequest({
    this.role = 'user',
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

/// =======================
/// GET /chatthreads/{threadId}/messages
/// =======================

/// Response dạng:
/// {
///   "data": [ {..ChatMessage..}, ... ],
///   "success": true,
///   "message": "string"
/// }
@JsonSerializable(explicitToJson: true)
class GetChatMessagesResponse {
  final List<ChatMessage> data;
  final bool success;
  final String message;

  GetChatMessagesResponse({
    required this.data,
    required this.success,
    required this.message,
  });

  factory GetChatMessagesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetChatMessagesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetChatMessagesResponseToJson(this);
}

// =======================
// POST /api/aihealthplan/create
// =======================

@JsonSerializable()
class AiHealthPlanCreateRequest {
  final int activityLevel;
  final int experienceLevel;
  final String healthProblem;
  final String goal;
  final int nextCheckPoint;
  final int workoutDays;
  final String importantNote;
  final int dietType;

  AiHealthPlanCreateRequest({
    required this.activityLevel,
    required this.experienceLevel,
    required this.healthProblem,
    required this.goal,
    required this.nextCheckPoint,
    required this.workoutDays,
    required this.importantNote,
    required this.dietType,
  });

  /// tiện: tạo request trực tiếp từ ChatMessageMeta
  factory AiHealthPlanCreateRequest.fromMeta(ChatMessageMeta meta) {
    return AiHealthPlanCreateRequest(
      activityLevel: meta.activityLevel,
      experienceLevel: meta.experienceLevel,
      healthProblem: meta.healthProblem,
      goal: meta.goal,
      nextCheckPoint: meta.nextCheckPoint,
      workoutDays: meta.workoutDays,
      importantNote: meta.importantNote,
      dietType: meta.dietType,
    );
  }

  factory AiHealthPlanCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$AiHealthPlanCreateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AiHealthPlanCreateRequestToJson(this);
}

/// tuỳ backend, ở đây mình chỉ cần success + message là đủ
@JsonSerializable()
class AiHealthPlanCreateResponse {
  final bool success;
  final String message;

  AiHealthPlanCreateResponse({required this.success, required this.message});

  factory AiHealthPlanCreateResponse.fromJson(Map<String, dynamic> json) =>
      _$AiHealthPlanCreateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AiHealthPlanCreateResponseToJson(this);
}

/// =======================
/// POST /api/mealplan/generate
/// =======================
/// Response tổng:
/// {
///   "data": { ...MealPlanGenerateData },
///   "success": true,
///   "message": "Meal plan generated successfully"
/// }
@JsonSerializable(explicitToJson: true)
class MealPlanGenerateResponse {
  final MealPlanGenerateData data;
  final bool success;
  final String message;

  MealPlanGenerateResponse({
    required this.data,
    required this.success,
    required this.message,
  });

  factory MealPlanGenerateResponse.fromJson(Map<String, dynamic> json) =>
      _$MealPlanGenerateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MealPlanGenerateResponseToJson(this);
}

/// "data" bên trong:
/// {
///   "processingTime": "00:01:24.4743742",
///   "targetCalories": 2816,
///   "data": { "dailyMeals": [ ... ] }
/// }
@JsonSerializable(explicitToJson: true)
class MealPlanGenerateData {
  final String processingTime;
  final int targetCalories;
  final MealPlanCoreData data;

  MealPlanGenerateData({
    required this.processingTime,
    required this.targetCalories,
    required this.data,
  });

  factory MealPlanGenerateData.fromJson(Map<String, dynamic> json) =>
      _$MealPlanGenerateDataFromJson(json);

  Map<String, dynamic> toJson() => _$MealPlanGenerateDataToJson(this);
}

/// Lớp chứa mảng dailyMeals
@JsonSerializable(explicitToJson: true)
class MealPlanCoreData {
  final List<DailyMealPlan> dailyMeals;

  MealPlanCoreData({required this.dailyMeals});

  factory MealPlanCoreData.fromJson(Map<String, dynamic> json) =>
      _$MealPlanCoreDataFromJson(json);

  Map<String, dynamic> toJson() => _$MealPlanCoreDataToJson(this);
}

/// 1 ngày trong plan
@JsonSerializable(explicitToJson: true)
class DailyMealPlan {
  final int dayNumber;
  final List<MealItem> meals;

  DailyMealPlan({required this.dayNumber, required this.meals});

  factory DailyMealPlan.fromJson(Map<String, dynamic> json) =>
      _$DailyMealPlanFromJson(json);

  Map<String, dynamic> toJson() => _$DailyMealPlanToJson(this);
}

/// 1 bữa ăn (Breakfast / Lunch / Dinner / Snack...)
@JsonSerializable(explicitToJson: true)
class MealItem {
  final String type;
  final int calories;
  final MealNutrition nutrition;
  final List<MealFood> foods;

  MealItem({
    required this.type,
    required this.calories,
    required this.nutrition,
    required this.foods,
  });

  factory MealItem.fromJson(Map<String, dynamic> json) =>
      _$MealItemFromJson(json);

  Map<String, dynamic> toJson() => _$MealItemToJson(this);
}

/// Thông tin macro cho 1 bữa
@JsonSerializable()
class MealNutrition {
  final double carbs;
  final double protein;
  final double fat;
  final double fiber;
  final double sugar;

  MealNutrition({
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.fiber,
    required this.sugar,
  });

  factory MealNutrition.fromJson(Map<String, dynamic> json) =>
      _$MealNutritionFromJson(json);

  Map<String, dynamic> toJson() => _$MealNutritionToJson(this);
}

/// Thực phẩm cụ thể trong bữa
@JsonSerializable()
class MealFood {
  final String name;
  final String quantity;

  MealFood({required this.name, required this.quantity});

  factory MealFood.fromJson(Map<String, dynamic> json) =>
      _$MealFoodFromJson(json);

  Map<String, dynamic> toJson() => _$MealFoodToJson(this);
}

/// =======================
/// POST /api/workoutplan/generate
/// =======================
/// Response:
/// {
///   "data": {
///     "success": true,
///     "errorMessage": "",
///     "processingTime": "00:00:23.0805089",
///     "goal": "Weight_Loss",
///     "activityLevel": 1,
///     "data": {
///       "workoutPlan": [ { ...WorkoutPlanDay... } ]
///     }
///   },
///   "success": true,
///   "message": "Workout plan generated successfully"
/// }
@JsonSerializable(explicitToJson: true)
class WorkoutPlanGenerateResponse {
  final WorkoutPlanGenerateData data;
  final bool success;
  final String message;

  WorkoutPlanGenerateResponse({
    required this.data,
    required this.success,
    required this.message,
  });

  factory WorkoutPlanGenerateResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkoutPlanGenerateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutPlanGenerateResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class WorkoutPlanGenerateData {
  final bool success;
  final String errorMessage;
  final String processingTime;
  final String goal;
  final int activityLevel;
  final WorkoutPlanCoreData data;

  WorkoutPlanGenerateData({
    required this.success,
    required this.errorMessage,
    required this.processingTime,
    required this.goal,
    required this.activityLevel,
    required this.data,
  });

  factory WorkoutPlanGenerateData.fromJson(Map<String, dynamic> json) =>
      _$WorkoutPlanGenerateDataFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutPlanGenerateDataToJson(this);
}

/// Lớp chứa mảng workoutPlan
@JsonSerializable(explicitToJson: true)
class WorkoutPlanCoreData {
  final List<WorkoutPlanDay> workoutPlan;

  WorkoutPlanCoreData({required this.workoutPlan});

  factory WorkoutPlanCoreData.fromJson(Map<String, dynamic> json) =>
      _$WorkoutPlanCoreDataFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutPlanCoreDataToJson(this);
}

/// 1 ngày trong workout plan
@JsonSerializable(explicitToJson: true)
class WorkoutPlanDay {
  final int dayNumber;
  final String sessionName;
  final List<WorkoutExercise> exercises;

  WorkoutPlanDay({
    required this.dayNumber,
    required this.sessionName,
    required this.exercises,
  });

  factory WorkoutPlanDay.fromJson(Map<String, dynamic> json) =>
      _$WorkoutPlanDayFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutPlanDayToJson(this);
}

/// 1 bài tập trong ngày
@JsonSerializable()
class WorkoutExercise {
  final String exerciseId;
  final String name;
  final int? sets;
  final int? reps;
  final int? durationMinutes;
  final String category;
  final String videoUrl;
  final String note;

  WorkoutExercise({
    required this.exerciseId,
    required this.name,
    this.sets,
    this.reps,
    this.durationMinutes,
    required this.category,
    required this.videoUrl,
    required this.note,
  });

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) =>
      _$WorkoutExerciseFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutExerciseToJson(this);
}
