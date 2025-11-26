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

  // ==================== WORKOUT PLAN ====================
  /// Gọi API /api/workoutplan/generate → trả về full response
  Future<WorkoutPlanGenerateResponse> generateWorkoutPlan() async {
    try {
      final res = await _service.generateWorkoutPlanRaw();
      final body = WorkoutPlanGenerateResponse.fromJson(
        res.data as Map<String, dynamic>,
      );
      return body;
    } catch (e) {
      rethrow;
    }
  }

  /// Nếu UI chỉ cần list workoutPlan (nguyên từng ngày)
  Future<List<WorkoutPlanDay>> generateWorkoutPlanDays() async {
    final resp = await generateWorkoutPlan();
    return resp.data.data.workoutPlan;
  }

  // ==================== SAVE WORKOUT PLAN (SAVE-ALL) ====================

  /// Gửi thẳng List<WorkoutPlanSaveDayRequest> xuống API
  Future<WorkoutPlanSaveAllResponse> saveWorkoutPlanAll(
    List<WorkoutPlanSaveDayRequest> days,
  ) async {
    try {
      final res = await _service.saveWorkoutPlanAllRaw(days);
      final body = WorkoutPlanSaveAllResponse.fromJson(
        res.data as Map<String, dynamic>,
      );
      return body;
    } catch (e) {
      rethrow;
    }
  }

  /// Helper: nhận List<WorkoutPlanDay> (từ generate) rồi convert sang payload save-all
  Future<WorkoutPlanSaveAllResponse> saveWorkoutPlanAllFromGenerate(
    List<WorkoutPlanDay> days,
  ) {
    final payload = days
        .map((d) => WorkoutPlanSaveDayRequest.fromWorkoutPlanDay(d))
        .toList();

    return saveWorkoutPlanAll(payload);
  }

  // ==================== SAVE MEAL PLAN (SAVE-BATCH) ====================

  /// Gửi thẳng List<MealPlanSaveBatchDayRequest> xuống API
  Future<MealPlanSaveBatchResponse> saveMealPlanBatch(
    List<MealPlanSaveBatchDayRequest> days,
  ) async {
    try {
      final res = await _service.saveMealPlanBatchRaw(days);
      final body = MealPlanSaveBatchResponse.fromJson(
        res.data as Map<String, dynamic>,
      );
      return body;
    } catch (e) {
      rethrow;
    }
  }

  /// Helper: nhận List<DailyMealPlan> (từ generate) rồi convert sang payload save-batch
  Future<MealPlanSaveBatchResponse> saveMealPlanBatchFromGenerate(
    List<DailyMealPlan> days,
  ) {
    final payload = days
        .map((d) => MealPlanSaveBatchDayRequest.fromDailyMealPlan(d))
        .toList();

    return saveMealPlanBatch(payload);
  }
  // ==================== ACTIVATE AI HEALTH PLAN ====================

  Future<AiHealthPlanActivateResponse> activateAiHealthPlan() async {
    try {
      final res = await _service.activateAiHealthPlanRaw();
      final body = AiHealthPlanActivateResponse.fromJson(
        res.data as Map<String, dynamic>,
      );
      return body;
    } catch (e) {
      rethrow;
    }
  }
}
