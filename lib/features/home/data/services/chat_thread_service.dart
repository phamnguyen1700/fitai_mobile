import 'package:dio/dio.dart';
import 'package:fitai_mobile/core/api/api_client.dart';
import 'package:fitai_mobile/core/api/api_constants.dart';
import 'package:fitai_mobile/features/home/data/models/chat_thread_models.dart';

class ChatThreadService {
  final ApiClient _client;

  ChatThreadService([ApiClient? client]) : _client = client ?? ApiClient.chat();

  // ================= GET /chatthreads =================
  Future<Response<dynamic>> getChatThreadsRaw() {
    return _client.get<dynamic>(ApiConstants.chatThreads);
  }

  // Optional: typed
  Future<ChatThreadResponse> getChatThreads() async {
    final res = await getChatThreadsRaw();
    return ChatThreadResponse.fromJson(res.data as Map<String, dynamic>);
  }

  // ================= POST /chatthreads =================
  Future<Response<dynamic>> createChatThreadRaw(CreateChatThreadRequest body) {
    return _client.post<dynamic>(ApiConstants.chatThreads, data: body.toJson());
  }

  // Optional: typed
  Future<CreateChatThreadResponse> createChatThread(
    CreateChatThreadRequest body,
  ) async {
    final res = await createChatThreadRaw(body);
    return CreateChatThreadResponse.fromJson(res.data as Map<String, dynamic>);
  }

  // ========== POST /chatthreads/{threadId}/messages ==========
  Future<Response<dynamic>> sendMessageRaw(
    String threadId,
    SendChatMessageRequest body,
  ) {
    final path = '${ApiConstants.chatThreads}/$threadId/messages';
    return _client.post<dynamic>(path, data: body.toJson());
  }

  // Optional: typed
  Future<SendChatMessageResponse> sendMessage(
    String threadId,
    SendChatMessageRequest body,
  ) async {
    final res = await sendMessageRaw(threadId, body);
    return SendChatMessageResponse.fromJson(res.data as Map<String, dynamic>);
  }

  // ========== GET /chatthreads/{threadId}/messages ==========
  Future<Response<dynamic>> getThreadMessagesRaw(String threadId) {
    final path = '${ApiConstants.chatThreads}/$threadId/messages';
    return _client.get<dynamic>(path);
  }

  Future<GetChatMessagesResponse> getThreadMessages(String threadId) async {
    final res = await getThreadMessagesRaw(threadId);
    return GetChatMessagesResponse.fromJson(res.data as Map<String, dynamic>);
  }

  // ========== AI HEALTH PLAN: POST /api/aihealthplan/create ==========
  /// Raw: gửi thẳng body tạo health plan
  Future<Response<dynamic>> createAiHealthPlanRaw(
    AiHealthPlanCreateRequest body,
  ) {
    return _client.post<dynamic>(
      ApiConstants.aiHealthPlanCreate, // ví dụ: '/aihealthplan/create'
      data: body.toJson(),
    );
  }

  /// Typed: parse về AiHealthPlanCreateResponse
  Future<AiHealthPlanCreateResponse> createAiHealthPlan(
    AiHealthPlanCreateRequest body,
  ) async {
    final res = await createAiHealthPlanRaw(body);
    return AiHealthPlanCreateResponse.fromJson(
      res.data as Map<String, dynamic>,
    );
  }

  // ========== MEAL PLAN: POST /mealplan/generate ==========
  /// Raw: gọi generate meal plan
  Future<Response<dynamic>> generateMealPlanRaw() {
    // Endpoint không có body theo Swagger: "No parameters"
    return _client.post<dynamic>(ApiConstants.mealPlanGenerate);
  }

  /// Typed: parse về MealPlanGenerateResponse
  Future<MealPlanGenerateResponse> generateMealPlan() async {
    final res = await generateMealPlanRaw();
    return MealPlanGenerateResponse.fromJson(res.data as Map<String, dynamic>);
  }

  // ========== WORKOUT PLAN: POST /api/workoutplan/generate ==========
  /// Raw: gọi generate workout plan
  Future<Response<dynamic>> generateWorkoutPlanRaw() {
    // Tương tự meal plan: endpoint không có body
    return _client.post<dynamic>(ApiConstants.workoutPlanGenerate);
  }

  /// Typed: parse về WorkoutPlanGenerateResponse
  Future<WorkoutPlanGenerateResponse> generateWorkoutPlan() async {
    final res = await generateWorkoutPlanRaw();
    return WorkoutPlanGenerateResponse.fromJson(
      res.data as Map<String, dynamic>,
    );
  }
}
