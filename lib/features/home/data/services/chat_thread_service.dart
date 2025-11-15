import 'package:dio/dio.dart';
import 'package:fitai_mobile/core/api/api_client.dart';
import 'package:fitai_mobile/core/api/api_constants.dart';
import 'package:fitai_mobile/features/home/data/models/chat_thread_models.dart';

class ChatThreadService {
  final ApiClient _client;

  ChatThreadService([ApiClient? client]) : _client = client ?? ApiClient.chat();

  Future<Response<dynamic>> getChatThreadsRaw() {
    return _client.get<dynamic>(ApiConstants.chatThreads);
  }

  Future<Response<dynamic>> createChatThreadRaw(CreateChatThreadRequest body) {
    return _client.post<dynamic>(ApiConstants.chatThreads, data: body.toJson());
  }

  Future<Response<dynamic>> sendMessageRaw(
    String threadId,
    SendChatMessageRequest body,
  ) {
    final path = '${ApiConstants.chatThreads}/$threadId/messages';
    return _client.post<dynamic>(path, data: body.toJson());
  }
}
