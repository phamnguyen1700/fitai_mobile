import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fitai_mobile/core/api/api_client.dart';
import 'package:fitai_mobile/core/api/api_constants.dart';

/// Service xử lý upload ảnh bữa ăn + mark completed
class MealPhotoService {
  final ApiClient _client;

  MealPhotoService({ApiClient? client})
    : _client = client ?? ApiClient.fitness();

  /// Gọi /api/mealplan/upload-photo (multipart/form-data)
  ///
  /// Body:
  /// - DayNumber: int
  /// - MealType: string (Breakfast / Lunch / Dinner / Snack...)
  /// - PhotoFile: file binary
  Future<Response<dynamic>> uploadMealPhoto({
    required int dayNumber,
    required String mealType,
    required File photoFile,
  }) async {
    final formData = FormData.fromMap({
      // Tên field giữ nguyên như swagger
      'DayNumber': dayNumber,
      'MealType': mealType,
      'PhotoFile': await MultipartFile.fromFile(
        photoFile.path,
        filename: photoFile.uri.pathSegments.isNotEmpty
            ? photoFile.uri.pathSegments.last
            : 'meal_photo.jpg',
      ),
    });

    return _client.post<dynamic>(ApiConstants.mealUploadPhoto, data: formData);
  }

  /// Gọi /api/mealplan/mark-completed (không upload ảnh)
  ///
  /// Query:
  /// - dayNumber
  /// - mealType
  Future<Response<dynamic>> markMealCompleted({
    required int dayNumber,
    required String mealType,
  }) {
    return _client.post<dynamic>(
      ApiConstants.mealMarkCompleted,
      queryParameters: <String, dynamic>{
        'dayNumber': dayNumber,
        'mealType': mealType,
      },
    );
  }

  /// Convenience: Upload ảnh xong nếu `success == true` thì gọi luôn mark-completed.
  /// Vì 2 response có cùng format nên tầng repo có thể parse về chung 1 model
  /// (ví dụ `UploadMealPhotoResponse`) để dùng lại sau này cho comment.
  Future<Response<dynamic>> uploadPhotoAndMarkCompleted({
    required int dayNumber,
    required String mealType,
    required File photoFile,
  }) async {
    final uploadRes = await uploadMealPhoto(
      dayNumber: dayNumber,
      mealType: mealType,
      photoFile: photoFile,
    );

    final data = uploadRes.data;
    final bool success = data is Map<String, dynamic>
        ? (data['success'] == true)
        : false;

    if (!success) {
      // upload fail → trả luôn response upload cho tầng trên tự xử lý
      return uploadRes;
    }

    // upload OK → gọi tiếp mark completed
    final markRes = await markMealCompleted(
      dayNumber: dayNumber,
      mealType: mealType,
    );

    return markRes;
  }
}
