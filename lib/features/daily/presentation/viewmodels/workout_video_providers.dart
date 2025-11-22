import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fitai_mobile/features/daily/data/models/upload_image.dart';
import 'package:fitai_mobile/features/daily/data/repositories/workout_video_repository.dart';

part 'workout_video_providers.g.dart';

/// Singleton repo
@riverpod
WorkoutVideoRepository workoutVideoRepository(WorkoutVideoRepositoryRef ref) {
  return WorkoutVideoRepository();
}

/// Controller để gọi upload từ UI
@riverpod
class WorkoutVideoUploadController extends _$WorkoutVideoUploadController {
  @override
  FutureOr<void> build() {
    // không cần state ban đầu -> để void
  }

  Future<UploadWorkoutVideoResponse> upload({
    required int dayNumber,
    required String exerciseId,
    required File videoFile,
  }) async {
    // set state loading nếu muốn UI hiển thị
    state = const AsyncLoading();

    final repo = ref.read(workoutVideoRepositoryProvider);

    try {
      final res = await repo.uploadAndComplete(
        dayNumber: dayNumber,
        exerciseId: exerciseId,
        videoFile: videoFile,
      );

      state = AsyncData(res);
      return res;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
