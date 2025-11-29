import 'package:fitai_mobile/core/status/bodygram_error.dart';
import 'package:fitai_mobile/features/profile_setup/data/services/bodygram_api_service.dart';
import 'package:fitai_mobile/features/profile_setup/data/models/bodygram_analyze_request.dart';

class BodygramAnalyzeRepository {
  final BodygramApiService _api;

  BodygramAnalyzeRepository([BodygramApiService? api])
    : _api = api ?? BodygramApiService();

  /// Chỉ gọi analyze, không upload.
  ///
  /// - Ném lại `BodygramAnalyzeException` để UI show message chi tiết
  /// - Các lỗi khác được wrap thành Exception chung.
  Future<void> analyze(BodygramAnalyzeRequest request) async {
    try {
      await _api.analyzeBodyImages(request);
    } on BodygramAnalyzeException {
      // đã được map code -> status ở ApiService, để UI xử lý tiếp
      rethrow;
    } catch (_) {
      // Lỗi mạng / server không rõ
      throw Exception(
        'Phân tích dữ liệu cơ thể thất bại, vui lòng thử lại sau.',
      );
    }
  }
}
