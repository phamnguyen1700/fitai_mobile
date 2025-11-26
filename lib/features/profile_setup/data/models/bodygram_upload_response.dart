class BodygramUploadResponse {
  final bool success;
  final BodygramUploadData? data;
  final String? message;

  BodygramUploadResponse({required this.success, this.data, this.message});

  factory BodygramUploadResponse.fromJson(Map<String, dynamic> json) {
    return BodygramUploadResponse(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null
          ? BodygramUploadData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      message: json['message'] as String?,
    );
  }
}

class BodygramUploadData {
  final String? status;
  final String? bodyDataId;
  final String? frontUrl;
  final String? rightUrl;
  final String? userId;

  BodygramUploadData({
    this.status,
    this.bodyDataId,
    this.frontUrl,
    this.rightUrl,
    this.userId,
  });

  factory BodygramUploadData.fromJson(Map<String, dynamic> json) {
    return BodygramUploadData(
      status: json['status'] as String?,
      bodyDataId: json['body_data_id'] as String?,
      frontUrl: json['front_url'] as String?,
      rightUrl: json['right_url'] as String?,
      userId: json['userId'] as String?,
    );
  }
}
