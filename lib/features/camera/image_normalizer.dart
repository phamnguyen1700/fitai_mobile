import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:exif/exif.dart';

/// Chuẩn hoá ảnh portrait 9:16 và scale về 1080x1920.
/// Trả về file mới (không ghi đè file gốc).
Future<File> normalizeBodyPhoto(File src) async {
  final bytes = await src.readAsBytes();

  // ============ 1) Decode ảnh (non-null) ============
  img.Image image = img.decodeImage(bytes)!;

  // ============ 2) Đọc EXIF orientation (nếu có) ============
  try {
    final exif = await readExifFromBytes(bytes);

    final orientationStr = exif['Image Orientation']?.printable ?? '';
    final orientation = int.tryParse(
      orientationStr.replaceAll(RegExp(r'[^0-9]'), ''),
    );

    switch (orientation) {
      case 3:
        image = img.copyRotate(image, angle: 180);
        break;
      case 6:
        image = img.copyRotate(image, angle: 90);
        break;
      case 8:
        image = img.copyRotate(image, angle: -90);
        break;
    }
  } catch (_) {
    // không có EXIF → bỏ qua
  }

  // ============ 3) Đảm bảo portrait ============
  if (image.width > image.height) {
    image = img.copyRotate(image, angle: 90);
  }

  // ============ 4) Crop về tỉ lệ 9:16 ============
  const targetRatio = 9 / 16;
  final currentRatio = image.width / image.height;

  if ((currentRatio - targetRatio).abs() > 0.001) {
    int cropW = image.width;
    int cropH = image.height;

    if (currentRatio > targetRatio) {
      cropW = (image.height * targetRatio).round(); // quá ngang → cắt ngang
    } else {
      cropH = (image.width / targetRatio).round(); // quá dọc → cắt dọc
    }

    final left = ((image.width - cropW) / 2).round();
    final top = ((image.height - cropH) / 2).round();

    image = img.copyCrop(image, x: left, y: top, width: cropW, height: cropH);
  }

  // ============ 5) Resize về chuẩn 1080×1920 ============
  image = img.copyResize(
    image,
    width: 1080,
    height: 1920,
    interpolation: img.Interpolation.cubic,
  );

  // ============ 6) Ghi JPG ============
  final outBytes = img.encodeJpg(image, quality: 90);

  final outPath = src.path.replaceFirst(
    RegExp(r'\.(jpg|jpeg|png)$', caseSensitive: false),
    '_norm_${DateTime.now().millisecondsSinceEpoch}.jpg',
  );

  final outFile = File(outPath);
  await outFile.writeAsBytes(outBytes);

  return outFile;
}
