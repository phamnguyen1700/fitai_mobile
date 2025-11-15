import 'package:dio/dio.dart';
import 'package:fitai_mobile/core/api/api_constants.dart';
import 'package:fitai_mobile/core/api/api_client.dart';

class SubscriptionService {
  final ApiClient _client = ApiClient.account();

  Future<Response<dynamic>> getActiveProductsRaw() {
    return _client.get<dynamic>(ApiConstants.subscriptionProducts);
  }
}
