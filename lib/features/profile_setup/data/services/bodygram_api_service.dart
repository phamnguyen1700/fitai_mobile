import 'package:dio/dio.dart';
import 'package:fitai_mobile/core/api/api_client.dart';
import 'package:fitai_mobile/core/api/api_constants.dart';
import '../models/bodygram_upload_request.dart';

class BodygramApiService {
  final ApiClient _client = ApiClient.account();

  Future<void> uploadBodyImages(BodygramUploadRequest request) async {
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

    await _client.post<dynamic>(
      ApiConstants.bodygramUpload,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
  }
}
