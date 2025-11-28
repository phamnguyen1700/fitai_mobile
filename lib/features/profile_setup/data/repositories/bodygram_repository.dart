import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:fitai_mobile/features/profile_setup/presentation/widgets/user_data.dart';
import 'package:fitai_mobile/features/profile_setup/data/services/bodygram_api_service.dart';
import 'package:fitai_mobile/features/profile_setup/data/models/bodygram_upload_request.dart';

// 🔹 Auth repo – import đúng path của bạn
import 'package:fitai_mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:fitai_mobile/features/auth/data/models/user_model.dart';

// 🔹 Hàm chuẩn hoá ảnh
import 'package:fitai_mobile/features/camera/image_normalizer.dart';

class BodygramRepository {
  BodygramRepository(this._api, this._authRepository);

  final BodygramApiService _api;
  final AuthRepository _authRepository;

  Future<void> uploadFromDraft(ProfileDraft draft) async {
    // 1. Log draft hiện tại
    debugPrint(
      '[BodygramRepo] DRAFT => '
      'height=${draft.height}, weight=${draft.weight}, '
      'front=${draft.frontBodyPhotoPath}, side=${draft.sideBodyPhotoPath}',
    );

    // 2. Validate ảnh
    if (draft.frontBodyPhotoPath == null ||
        draft.sideBodyPhotoPath == null ||
        draft.frontBodyPhotoPath!.isEmpty ||
        draft.sideBodyPhotoPath!.isEmpty) {
      throw StateError('Thiếu ảnh body trong draft');
    }

    // 3. Lấy height/weight: ưu tiên từ draft
    double? height = draft.height;
    double? weight = draft.weight;

    // 4. Nếu draft chưa có, fallback sang current user trong AuthRepository
    if (height == null || weight == null) {
      debugPrint(
        '[BodygramRepo] draft thiếu height/weight, fallback sang getCurrentUser()',
      );

      try {
        final UserModel? user = await _authRepository.getCurrentUser();
        debugPrint('[BodygramRepo] getCurrentUser() => $user');

        if (user != null) {
          debugPrint(
            '[BodygramRepo] USER => '
            'height=${user.height}, weight=${user.weight}, '
            'firstName=${user.firstName}, lastName=${user.lastName}',
          );

          height ??= user.height;
          weight ??= user.weight;
        } else {
          debugPrint('[BodygramRepo] getCurrentUser() trả về null');
        }
      } catch (e, st) {
        debugPrint('[BodygramRepo] getCurrentUser() ERROR: $e\n$st');
      }
    }

    // 5. Log kết quả final
    debugPrint('[BodygramRepo] FINAL => height=$height, weight=$weight');

    // 6. Sau khi fallback mà vẫn thiếu thì mới coi là lỗi
    if (height == null || weight == null) {
      throw StateError('Thiếu chiều cao hoặc cân nặng');
    }

    // 7. 🔥 Chuẩn hoá ảnh theo đúng yêu cầu BE (9:16, 1080x1920)
    final originalFront = File(draft.frontBodyPhotoPath!);
    final originalSide = File(draft.sideBodyPhotoPath!);

    final normalizedFront = await normalizeBodyPhoto(originalFront);
    final normalizedSide = await normalizeBodyPhoto(originalSide);

    debugPrint(
      '[BodygramRepo] Normalized files => '
      'front=${normalizedFront.path}, side=${normalizedSide.path}',
    );

    // (tuỳ bạn, nếu muốn dùng lại sau thì có thể gán ngược vào draft)
    // draft.frontBodyPhotoPath = normalizedFront.path;
    // draft.sideBodyPhotoPath  = normalizedSide.path;
    // 8. Tạo request upload với file đã normalize
    final req = BodygramUploadRequest(
      height: height,
      weight: weight,
      frontPhoto: normalizedFront,
      rightPhoto: normalizedSide,
    );

    debugPrint(
      '[BodygramRepo] CALL API uploadBodyImages '
      '(h=$height, w=$weight, front=${req.frontPhoto.path}, side=${req.rightPhoto.path})',
    );

    // 9. Gọi API
    await _api.uploadBodyImages(req);
  }
}
