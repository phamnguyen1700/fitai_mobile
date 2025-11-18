import 'package:dio/dio.dart';
import 'package:fitai_mobile/features/home/data/models/chat_thread_models.dart';
import 'package:fitai_mobile/features/home/data/services/chat_thread_service.dart';

class ChatThreadRepository {
  final ChatThreadService _service;

  ChatThreadRepository([ChatThreadService? service])
    : _service = service ?? ChatThreadService();

  // ==================== GET THREAD LIST ====================
  Future<List<ChatThread>> getChatThreads() async {
    try {
      final res = await _service.getChatThreadsRaw();
      final body = ChatThreadResponse.fromJson(res.data);
      return body.data;
    } catch (e) {
      rethrow;
    }
  }

  // ==================== CREATE NEW THREAD ====================
  Future<CreateChatThreadData> createNewChatThread({
    String? title,
    String threadType = 'fitness',
  }) async {
    try {
      final req = CreateChatThreadRequest(title: title, threadType: threadType);
      final res = await _service.createChatThreadRaw(req);
      final body = CreateChatThreadResponse.fromJson(res.data);
      return body.data;
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // ==================== SEND MESSAGE + AI RESPONSE ====================
  Future<ChatMessage> sendMessageToThread({
    required String threadId,
    required String content,
    String role = 'user',
    String? data,
  }) async {
    try {
      final req = SendChatMessageRequest(
        role: role,
        content: content,
        data: data,
      );

      final res = await _service.sendMessageRaw(threadId, req);
      final body = SendChatMessageResponse.fromJson(res.data);
      return body.data; // ChatMessage trả về từ AI
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // ==================== GET ALL MESSAGES OF THREAD ====================
  Future<List<ChatMessage>> getThreadMessages(String threadId) async {
    try {
      final res = await _service.getThreadMessagesRaw(threadId);
      final body = GetChatMessagesResponse.fromJson(res.data);
      return body.data;
    } catch (e) {
      rethrow;
    }
  }

  // ==================== NEW: CREATE AI HEALTH PLAN ====================
  Future<AiHealthPlanCreateResponse> createHealthPlanFromMeta(
    ChatMessageMeta meta,
  ) async {
    try {
      final req = AiHealthPlanCreateRequest.fromMeta(meta);
      final res = await _service.createAiHealthPlanRaw(req);
      final body = AiHealthPlanCreateResponse.fromJson(
        res.data as Map<String, dynamic>,
      );
      return body;
    } catch (e) {
      rethrow;
    }
  }

  // ==================== MEAL PLAN PREVIEW ====================
  /// Gọi API /api/mealplan/generate và parse về model đầy đủ
  Future<MealPlanGenerateResponse> generateMealPlan() {
    return _service.generateMealPlan();
  }

  /// Nếu ở UI chỉ cần list dailyMeals cho dễ dùng:
  Future<List<DailyMealPlan>> generateMealPlanDailyMeals() async {
    final resp = await generateMealPlan();
    return resp.data.data.dailyMeals;
  }
}
