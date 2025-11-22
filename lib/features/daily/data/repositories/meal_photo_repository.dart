import 'dart:io';
import 'package:fitai_mobile/features/daily/data/models/upload_image.dart';
import 'package:fitai_mobile/features/daily/data/services/meal_photo_service.dart';

class MealPhotoRepository {
  final MealPhotoService _service;

  MealPhotoRepository({MealPhotoService? service})
    : _service = service ?? MealPhotoService();

  /// Upload + auto mark-completed
  Future<UploadMealPhotoResponse> uploadAndComplete({
    required int dayNumber,
    required String mealType,
    required File photoFile,
  }) async {
    final res = await _service.uploadMealPhoto(
      dayNumber: dayNumber,
      mealType: mealType,
      photoFile: photoFile,
    );

    final data = UploadMealPhotoResponse.fromJson(res.data);

    if (!data.success) return data;

    // gọi tiếp mark completed
    final res2 = await _service.markMealCompleted(
      dayNumber: dayNumber,
      mealType: mealType,
    );

    return UploadMealPhotoResponse.fromJson(res2.data);
  }
}
