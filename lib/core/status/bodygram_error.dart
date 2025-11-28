class BodygramErrorStatus {
  BodygramErrorStatus({
    required this.code,
    required this.type,
    required this.explanation,
  });

  final String code;
  final String type;
  final String explanation;
}

final Map<String, BodygramErrorStatus> bodygramErrorMap = {
  'noEXIF': BodygramErrorStatus(
    code: 'noEXIF',
    type: 'format',
    explanation: 'Ảnh thiếu dữ liệu EXIF. Hãy chụp lại bằng camera mặc định.',
  ),
  'invalidPhotoFormat': BodygramErrorStatus(
    code: 'invalidPhotoFormat',
    type: 'format',
    explanation:
        'Định dạng ảnh không hợp lệ. Vui lòng tham khảo hướng dẫn và chụp lại.',
  ),
  'imageTooDark': BodygramErrorStatus(
    code: 'imageTooDark',
    type: 'quality',
    explanation:
        'Phông nền quá tối. Hãy chụp lại ở nơi có đủ ánh sáng hoặc bật đèn.',
  ),
  'imageTooBright': BodygramErrorStatus(
    code: 'imageTooBright',
    type: 'quality',
    explanation: 'Phông nền quá sáng. Hãy chuyển sang khu vực ít sáng hơn.',
  ),
  'imageTooBlurry': BodygramErrorStatus(
    code: 'imageTooBlurry',
    type: 'quality',
    explanation: 'Ảnh bị mờ. Hãy giữ chắc thiết bị và chụp lại.',
  ),
  'faceNotDetected': BodygramErrorStatus(
    code: 'faceNotDetected',
    type: 'face',
    explanation:
        'Không phát hiện được khuôn mặt. Hãy đảm bảo mặt bạn rõ ràng trong ảnh.',
  ),
  'personNotDetected': BodygramErrorStatus(
    code: 'personNotDetected',
    type: 'person',
    explanation:
        'Không phát hiện được người. Hãy làm theo hướng dẫn tạo dáng và chụp lại.',
  ),
  'multiplePeopleDetected': BodygramErrorStatus(
    code: 'multiplePeopleDetected',
    type: 'person',
    explanation:
        'Phát hiện nhiều người trong ảnh. Vui lòng chụp chỉ một mình bạn.',
  ),
  'rightPhotoFacingWrongDirection': BodygramErrorStatus(
    code: 'rightPhotoFacingWrongDirection',
    type: 'posing',
    explanation:
        'Ảnh bên hông đang đối mặt sai hướng. Hãy quay đúng chiều yêu cầu.',
  ),
  'frontPhotoNotInFrame': BodygramErrorStatus(
    code: 'frontPhotoNotInFrame',
    type: 'posing',
    explanation:
        'Ảnh chính diện không nằm trọn khung. Hãy điều chỉnh và chụp lại.',
  ),
  'rightPhotoNotInFrame': BodygramErrorStatus(
    code: 'rightPhotoNotInFrame',
    type: 'posing',
    explanation:
        'Ảnh bên hông không nằm trọn khung. Hãy điều chỉnh và chụp lại.',
  ),
  'frontPhotoLeftArmAngle': BodygramErrorStatus(
    code: 'frontPhotoLeftArmAngle',
    type: 'posing',
    explanation:
        'Ảnh chính diện: tay trái chưa đúng góc. Hãy giơ thẳng theo hướng dẫn.',
  ),
  'frontPhotoRightArmAngle': BodygramErrorStatus(
    code: 'frontPhotoRightArmAngle',
    type: 'posing',
    explanation:
        'Ảnh chính diện: tay phải chưa đúng góc. Hãy giơ thẳng theo hướng dẫn.',
  ),
  'headNotInFrame': BodygramErrorStatus(
    code: 'headNotInFrame',
    type: 'posing',
    explanation: 'Ảnh chính diện: đầu chưa nằm trọn khung. Hãy lùi ra xa hơn.',
  ),
  'leftArmNotInFrame': BodygramErrorStatus(
    code: 'leftArmNotInFrame',
    type: 'posing',
    explanation: 'Ảnh chính diện: tay trái chưa nằm trọn trong khung.',
  ),
  'rightArmNotInFrame': BodygramErrorStatus(
    code: 'rightArmNotInFrame',
    type: 'posing',
    explanation: 'Ảnh chính diện: tay phải chưa nằm trọn trong khung.',
  ),
  'leftLegNotInFrame': BodygramErrorStatus(
    code: 'leftLegNotInFrame',
    type: 'posing',
    explanation: 'Ảnh chính diện: chân trái chưa nằm trọn trong khung.',
  ),
  'rightLegNotInFrame': BodygramErrorStatus(
    code: 'rightLegNotInFrame',
    type: 'posing',
    explanation: 'Ảnh chính diện: chân phải chưa nằm trọn trong khung.',
  ),
  'feetNotInFrame': BodygramErrorStatus(
    code: 'feetNotInFrame',
    type: 'posing',
    explanation: 'Ảnh chính diện: bàn chân chưa nằm trọn hoặc không rõ ràng.',
  ),
  'unknown': BodygramErrorStatus(
    code: 'unknown',
    type: 'other',
    explanation:
        'Đã xảy ra lỗi nội bộ. Vui lòng thử lại sau, nếu vẫn gặp lỗi hãy liên hệ Bodygram.',
  ),
};

BodygramErrorStatus resolveBodygramError(String? code) {
  return bodygramErrorMap[code] ?? bodygramErrorMap['unknown']!;
}

class BodygramAnalyzeException implements Exception {
  BodygramAnalyzeException(this.status);

  final BodygramErrorStatus status;

  @override
  String toString() => 'BodygramAnalyzeException(${status.code})';
}
