import 'package:dio/dio.dart';
import 'package:fitai_mobile/core/api/api_client.dart';
import 'package:fitai_mobile/core/api/api_constants.dart';

class MealPlanService {
  final ApiClient _client;

  MealPlanService([ApiClient? client])
    : _client = client ?? ApiClient.fitness();

  Future<Response<dynamic>> getDailyMeals({required int dayNumber}) {
    return _client.get<dynamic>(
      ApiConstants.dailyMeals,
      queryParameters: {'dayNumber': dayNumber},
    );
  }
}
