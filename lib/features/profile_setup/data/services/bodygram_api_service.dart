import 'package:dio/dio.dart';
import 'package:fitai_mobile/core/api/api_client.dart';
import 'package:fitai_mobile/core/api/api_constants.dart';
import 'package:fitai_mobile/core/status/bodygram_error.dart';
import '../models/bodygram_upload_request.dart';
import '../models/bodygram_upload_response.dart';
import '../models/bodygram_analyze_request.dart';

class BodygramApiService {
  final ApiClient _client = ApiClient.account();

  /// Dùng chung cho cả 2 flow:
  /// - Flow chỉ cần upload: chỉ cần `await uploadBodyImages(...)`
  /// - Flow Weekly: dùng response để lấy bodyDataId
  Future<BodygramUploadResponse> uploadBodyImages(
    BodygramUploadRequest request,
  ) async {
    final formData = FormData.fromMap({
      'Height': request.height,
      'Weight': request.weight,
      'FrontPhoto': await MultipartFile.fromFile(
        request.frontPhoto.path,
        filename: 'front_${DateTime.now().millisecondsSinceEpoch}.jpg',
      ),
      'RightPhoto': await MultipartFile.fromFile(
        request.rightPhoto.path,
        filename: 'side_${DateTime.now().millisecondsSinceEpoch}.jpg',
      ),
    });

    final resp = await _client.post<dynamic>(
      ApiConstants.bodygramUpload,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    // chỗ khác nếu chỉ cần upload có thể ignore return value
    return BodygramUploadResponse.fromJson(
      Map<String, dynamic>.from(resp.data as Map),
    );
  }

  Future<void> analyzeBodyImages(BodygramAnalyzeRequest request) async {
    try {
      await _client.post<dynamic>(
        ApiConstants.bodygramAnalyze,
        data: request.toJson(),
      );
    } on DioException catch (e) {
      final dynamic data = e.response?.data;
      String? code;

      if (data is Map && data['message'] is String) {
        code = data['message'] as String;
      }

      if (code != null) {
        throw BodygramAnalyzeException(resolveBodygramError(code));
      }

      rethrow;
    }
  }
}
