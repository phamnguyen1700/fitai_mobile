// lib/features/daily/presentation/viewmodels/meal_photo_providers.dart
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:fitai_mobile/features/daily/data/models/upload_image.dart';
import 'package:fitai_mobile/features/daily/data/repositories/meal_photo_repository.dart';

part 'meal_photo_providers.g.dart';

/// Repo provider – dùng chung toàn app
@riverpod
MealPhotoRepository mealPhotoRepository(MealPhotoRepositoryRef ref) {
  return MealPhotoRepository();
}

/// Controller upload ảnh + mark-completed
///
/// - state: AsyncValue<UploadMealPhotoResponse?>
///   + null: chưa upload
///   + loading: đang upload
///   + data: kết quả trả về từ API
///   + error: lỗi khi upload/mark
@riverpod
class UploadMealPhotoController extends _$UploadMealPhotoController {
  @override
  AsyncValue<UploadMealPhotoResponse?> build() {
    return const AsyncData(null);
  }

  Future<void> uploadAndComplete({
    required int dayNumber,
    required String mealType,
    required File photoFile,
  }) async {
    state = const AsyncLoading();

    final repo = ref.read(mealPhotoRepositoryProvider);

    state = await AsyncValue.guard(
      () => repo.uploadAndComplete(
        dayNumber: dayNumber,
        mealType: mealType,
        photoFile: photoFile,
      ),
    );
  }

  /// Option: reset state sau khi dùng xong
  void reset() {
    state = const AsyncData(null);
  }
}
