import 'dart:io';
import 'package:fitai_mobile/features/daily/data/models/upload_image.dart';
import 'package:fitai_mobile/features/daily/data/services/workout_video_service.dart';

class WorkoutVideoRepository {
  final WorkoutVideoService _service;

  WorkoutVideoRepository([WorkoutVideoService? service])
    : _service = service ?? WorkoutVideoService();

  Future<UploadWorkoutVideoResponse> uploadAndComplete({
    required int dayNumber,
    required String exerciseId,
    required File videoFile,
  }) async {
    // 1️⃣ Upload video
    final raw = await _service.uploadVideo(
      dayNumber: dayNumber,
      exerciseId: exerciseId,
      video: videoFile,
    );

    final parsed = UploadWorkoutVideoResponse.fromJson(raw);

    // 2️⃣ Nếu OK → mark completed
    if (parsed.success) {
      await _service.markCompleted(
        dayNumber: dayNumber,
        exerciseId: exerciseId,
      );
    }

    return parsed;
  }
}
