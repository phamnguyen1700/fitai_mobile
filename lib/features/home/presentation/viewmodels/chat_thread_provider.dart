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
  String role = 'customer',
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
