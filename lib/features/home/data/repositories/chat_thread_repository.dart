import 'package:dio/dio.dart';
import 'package:fitai_mobile/features/home/data/models/chat_thread_models.dart';
import 'package:fitai_mobile/features/home/data/services/chat_thread_service.dart';

class ChatThreadRepository {
  final ChatThreadService _service;

  ChatThreadRepository([ChatThreadService? service])
    : _service = service ?? ChatThreadService();

  Future<List<ChatThread>> getChatThreads() async {
    try {
      final res = await _service.getChatThreadsRaw();
      final body = ChatThreadResponse.fromJson(res.data);
      return body.data;
    } catch (e) {
      rethrow;
    }
  }

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

  Future<ChatMessage> sendMessageToThread({
    required String threadId,
    required String content,
    String role = 'customer',
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
      return body.data;
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
