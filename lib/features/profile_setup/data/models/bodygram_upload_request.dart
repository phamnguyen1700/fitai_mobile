import 'dart:io';

/// Chỉ dùng để gom data cho upload multipart, KHÔNG cần json_serializable
class BodygramUploadRequest {
  final double height;
  final double weight;
  final File frontPhoto;
  final File rightPhoto;

  const BodygramUploadRequest({
    required this.height,
    required this.weight,
    required this.frontPhoto,
    required this.rightPhoto,
  });
}
