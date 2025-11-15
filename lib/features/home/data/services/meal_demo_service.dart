import 'package:dio/dio.dart';
import 'package:fitai_mobile/core/api/api_client.dart';
import 'package:fitai_mobile/core/api/api_constants.dart';

import '../models/meal_demo_models.dart';

class MealDemoService {
  final ApiClient _client;

  MealDemoService([ApiClient? client])
    : _client = client ?? ApiClient.fitness();

  Future<Response<dynamic>> getMealDemosRaw({
    int pageNumber = 1,
    int pageSize = 15,
    bool? isDeleted,
  }) {
    final qp = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      if (isDeleted != null) 'isDeleted': isDeleted,
    };

    return _client.get<dynamic>(ApiConstants.mealDemo, queryParameters: qp);
  }

  Future<MealDemoListResponse> getMealDemos({
    int pageNumber = 1,
    int pageSize = 15,
    bool? isDeleted,
  }) async {
    final res = await getMealDemosRaw(
      pageNumber: pageNumber,
      pageSize: pageSize,
      isDeleted: isDeleted,
    );

    return MealDemoListResponse.fromJson(res.data as Map<String, dynamic>);
  }

  Future<Response<dynamic>> getMealDemoDetailRaw(String mealDemoId) {
    return _client.get<dynamic>(
      '${ApiConstants.mealDemoDetail}/meal-demo/$mealDemoId',
    );
  }

  Future<MealDemoDetailResponse> getMealDemoDetail(String mealDemoId) async {
    final res = await getMealDemoDetailRaw(mealDemoId);

    return MealDemoDetailResponse.fromJson(res.data as Map<String, dynamic>);
  }
}
