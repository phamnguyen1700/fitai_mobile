// lib/features/home/presentation/viewmodels/chat_thread_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fitai_mobile/features/home/data/models/chat_thread_models.dart';
import 'package:fitai_mobile/features/home/data/repositories/chat_thread_repository.dart';

part 'chat_thread_provider.g.dart';

@riverpod
ChatThreadRepository chatThreadRepository(ChatThreadRepositoryRef ref) {
  return ChatThreadRepository();
}

@riverpod
Future<List<ChatThread>> chatThreads(ChatThreadsRef ref) {
  final repo = ref.watch(chatThreadRepositoryProvider);
  return repo.getChatThreads();
}

@riverpod
Future<CreateChatThreadData> createChatThread(
  CreateChatThreadRef ref, {
  String? title,
  String threadType = 'fitness',
}) {
  final repo = ref.watch(chatThreadRepositoryProvider);
  return repo.createNewChatThread(title: title, threadType: threadType);
}

@riverpod
Future<ChatMessage> sendChatMessage(
  SendChatMessageRef ref, {
  required String threadId,
  required String content,
  String role = 'user',
  String? data,
}) {
  final repo = ref.watch(chatThreadRepositoryProvider);
  return repo.sendMessageToThread(
    threadId: threadId,
    content: content,
    role: role,
    data: data,
  );
}

/// =======================
/// GET messages của 1 thread
/// =======================
@riverpod
Future<List<ChatMessage>> threadMessages(
  ThreadMessagesRef ref, {
  required String threadId,
}) {
  final repo = ref.watch(chatThreadRepositoryProvider);
  return repo.getThreadMessages(threadId);
}

/// =======================
/// SAVE AI HEALTH PLAN
/// =======================
/// - Gọi khi ChatMessage.data (ChatMessageMeta) != null
/// - UI có thể watch để hiện loading banner
@riverpod
class AiHealthPlanCreateController extends _$AiHealthPlanCreateController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> saveFromMeta(ChatMessageMeta meta) async {
    final repo = ref.read(chatThreadRepositoryProvider);

    state = const AsyncLoading();
    try {
      await repo.createHealthPlanFromMeta(meta);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

// ===================== MEAL PLAN PREVIEW ===================== //

@riverpod
Future<MealPlanGenerateResponse> mealPlanGenerate(
  MealPlanGenerateRef ref,
) async {
  final repo = ref.read(chatThreadRepositoryProvider);
  // gọi đúng hàm bạn đã viết trong repository
  return repo.generateMealPlan();
}

/// Nếu UI chỉ cần list DailyMealPlan cho phần preview
@riverpod
Future<List<DailyMealPlan>> mealPlanDailyMeals(
  MealPlanDailyMealsRef ref,
) async {
  final repo = ref.read(chatThreadRepositoryProvider);
  return repo.generateMealPlanDailyMeals();
}
