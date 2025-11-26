import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:fitai_mobile/features/profile_setup/data/services/bodygram_api_service.dart';
import 'package:fitai_mobile/features/profile_setup/data/models/bodygram_upload_request.dart';
import 'package:fitai_mobile/features/profile_setup/data/models/bodygram_analyze_request.dart';
import 'package:fitai_mobile/features/camera/image_normalizer.dart';

class BodygramRepository {
  BodygramRepository(this._api);

  final BodygramApiService _api;

  // =========================================================
  // FLOW WEEKLY CHECK-IN: chỉ dùng 4 field (height, weight, front, side)
  // =========================================================
  Future<void> uploadFromWeeklyCheckin({
    required double height,
    required double weight,
    required String frontPhotoPath,
    required String sidePhotoPath,
  }) async {
    debugPrint(
      '[BodygramRepo] WEEKLY CHECK-IN => '
      'h=$height, w=$weight, front=$frontPhotoPath, side=$sidePhotoPath',
    );

    if (frontPhotoPath.isEmpty || sidePhotoPath.isEmpty) {
      throw StateError(
        'Thiếu ảnh body (front/side) khi upload Weekly Check-in',
      );
    }

    // Chuẩn hoá ảnh giống flow profile
    final originalFront = File(frontPhotoPath);
    final originalSide = File(sidePhotoPath);

    final normalizedFront = await normalizeBodyPhoto(originalFront);
    final normalizedSide = await normalizeBodyPhoto(originalSide);

    debugPrint(
      '[BodygramRepo] Normalized files (WEEKLY) => '
      'front=${normalizedFront.path}, side=${normalizedSide.path}',
    );

    final req = BodygramUploadRequest(
      height: height,
      weight: weight,
      frontPhoto: normalizedFront,
      rightPhoto: normalizedSide,
    );

    debugPrint(
      '[BodygramRepo] CALL API uploadBodyImages (WEEKLY) '
      '(h=$height, w=$weight, front=${req.frontPhoto.path}, side=${req.rightPhoto.path})',
    );

    await _uploadAndAnalyze(req, context: 'WEEKLY_CHECKIN');
  }

  // =========================================================
  // PRIVATE: Upload + auto gọi analyze
  // =========================================================
  Future<void> _uploadAndAnalyze(
    BodygramUploadRequest req, {
    required String context,
  }) async {
    try {
      // 1) Upload ảnh
      final uploadResp = await _api.uploadBodyImages(req);
      debugPrint(
        '[BodygramRepo][$context] Upload success = ${uploadResp.success}',
      );

      final bodyDataId = uploadResp.data?.bodyDataId;

      if (bodyDataId == null || bodyDataId.isEmpty) {
        debugPrint(
          '[BodygramRepo][$context] ⚠ Không tìm thấy body_data_id → bỏ qua analyze',
        );
        return;
      }

      debugPrint(
        '[BodygramRepo][$context] Gửi analyze-body-images với bodyDataId=$bodyDataId',
      );

      // 2) Gọi analyze
      final analyzeReq = BodygramAnalyzeRequest(bodyDataId: bodyDataId);
      await _api.analyzeBodyImages(analyzeReq);

      debugPrint('[BodygramRepo][$context] Analyze thành công');
    } catch (e, st) {
      debugPrint('[BodygramRepo][$context] Upload/Analyze ERROR: $e\n$st');
      rethrow;
    }
  }
}
