import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:fitai_mobile/features/camera/pose_painter_mirror.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import './feet_guide.dart';

class BodyCameraScreen extends StatefulWidget {
  const BodyCameraScreen({super.key});

  @override
  State<BodyCameraScreen> createState() => _BodyCameraScreenState();
}

enum _CaptureStage { front, side }

class _BodyCameraScreenState extends State<BodyCameraScreen> {
  CameraController? _controller;
  late Future<void> _initFuture;
  List<CameraDescription> _cameras = [];
  int _cameraIndex = 0;

  String? _error;

  late final PoseDetector _poseDetector;
  bool _isBusy = false;
  bool _canProcess = true;

  String _hintText = 'Đặt chân bạn vào vị trí';

  Timer? _countdownTimer;
  bool _isCountingDown = false;
  bool _isCapturingPhoto = false; // đang gọi takePicture

  // trạng thái pose
  bool _feetInGuide = false; // chỉ check chân trong ô
  bool _sidePoseOk = false; // tư thế quay ngang (chỉ khi chụp bên hông)
  bool _readyForCapture =
      false; // đủ điều kiện chụp (front: chân; side: chân+vai)

  // để vẽ skeleton debug
  Size? _lastImageSize;
  List<Pose> _lastPoses = [];

  _CaptureStage _stage = _CaptureStage.front;
  File? _frontFile;
  File? _sideFile;

  // map device orientation -> degrees
  final Map<DeviceOrientation, int> _orientations = const {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  @override
  void initState() {
    super.initState();

    _poseDetector = PoseDetector(
      options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
    );

    _initFuture = _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();

      // Ưu tiên camera trước
      _cameraIndex = _cameras.indexWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
      );
      if (_cameraIndex < 0) _cameraIndex = 0;

      final camera = _cameras[_cameraIndex];

      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup
                  .nv21 // để dùng InputImage.fromBytes
            : ImageFormatGroup.bgra8888,
      );

      await _controller!.initialize();

      // stream frame cho MLKit
      await _controller!.startImageStream(_processCameraImage);
    } catch (e) {
      _error = e.toString();
      debugPrint('[BodyCam] init error: $_error');
    }
  }

  @override
  void dispose() {
    _canProcess = false;
    _controller?.stopImageStream();
    _controller?.dispose();
    _poseDetector.close();
    super.dispose();
  }

  void _processCameraImage(CameraImage image) async {
    if (!_canProcess || _isBusy || _isCapturingPhoto) return;
    _isBusy = true;

    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) {
      _isBusy = false;
      return;
    }

    try {
      final poses = await _poseDetector.processImage(inputImage);
      debugPrint('[Pose] detected ${poses.length} poses');

      // Hàm này sẽ set _feetInGuide, _sidePoseOk và trả về "readyForCapture"
      final ready = _areFeetInGuide(poses, image);

      if (mounted) {
        setState(() {
          _readyForCapture = ready;
          _lastPoses = poses;
        });

        _onFeetGuideChanged(ready);
      }
    } catch (e) {
      debugPrint('[Pose] error: $e');
    } finally {
      _isBusy = false;
    }
  }

  /// Cập nhật logic khi pose thay đổi:
  /// - Nếu chân chưa trong ô => dừng, nhắc về chân
  /// - Nếu chân ok nhưng chụp bên hông & vai chưa chuẩn => dừng, nhắc quay trái
  /// - Nếu đủ điều kiện chụp => countdown
  void _onFeetGuideChanged(bool readyForCapture) {
    if (_isCapturingPhoto) return;

    // 1. CHÂN CHƯA TRONG Ô -> dừng hết, chỉ nhắc đặt chân
    if (!_feetInGuide) {
      if (_isCountingDown) _cancelCountdown();
      _setFeetHint();
      return;
    }

    // 2. CHÂN ĐÃ TRONG Ô, đang ở bước chụp bên hông nhưng vai chưa chuẩn
    if (_stage == _CaptureStage.side && !_sidePoseOk) {
      if (_isCountingDown) _cancelCountdown();
      _setShoulderHint();
      return;
    }

    // 3. ĐỦ ĐIỀU KIỆN CHỤP (front: chân ok; side: chân+vai ok)
    if (readyForCapture) {
      if (!_isCountingDown) {
        _startCountdown();
      }
    } else {
      // fallback an toàn
      if (_isCountingDown) _cancelCountdown();
      _setFeetHint();
    }
  }

  void _setFeetHint() {
    final msg = _stage == _CaptureStage.front
        ? 'Đặt chân bạn vào đúng ô\nở phía dưới màn hình.'
        : 'Quay người sang trái và\nđặt chân bạn vào ô phía dưới.';
    if (_hintText != msg) {
      setState(() => _hintText = msg);
    }
  }

  void _setShoulderHint() {
    const msg =
        'Giữ chân trong ô trắng,\n'
        'quay người nghiêng sang trái hơn\n'
        'sao cho vai nhìn ngang.';
    if (_hintText != msg) {
      setState(() => _hintText = msg);
    }
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _isCountingDown = true;

    setState(() {
      _hintText = _stage == _CaptureStage.front
          ? 'Giữ nguyên, đang chụp ảnh chính diện...'
          : 'Giữ nguyên, đang chụp ảnh bên hông...';
    });

    _countdownTimer = Timer(const Duration(seconds: 5), () {
      if (!mounted) return;

      // 5s sau mà vẫn đủ điều kiện chụp, vẫn đang countdown, và chưa chụp → chụp
      if (_readyForCapture && _isCountingDown && !_isCapturingPhoto) {
        _capturePhotoForCurrentStage();
      } else {
        setState(() {
          _isCountingDown = false;
        });
        _setFeetHint();
      }
    });
  }

  void _cancelCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    if (!mounted) return;
    setState(() {
      _isCountingDown = false;
    });
    // Hint sẽ được set lại trong _onFeetGuideChanged
  }

  Future<void> _capturePhotoForCurrentStage() async {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _isCountingDown = false;

    setState(() {
      _isCapturingPhoto = true;
    });

    try {
      _canProcess = false;
      await _controller?.stopImageStream();

      final xFile = await _controller!.takePicture();
      final file = File(xFile.path);

      if (!mounted) return;

      if (_stage == _CaptureStage.front) {
        _frontFile = file;
        _stage = _CaptureStage.side;

        setState(() {
          _hintText =
              'Đã chụp ảnh chính diện.\nQuay người sang trái để chụp bên hông.';
        });

        // Restart stream để chụp ảnh bên hông
        if (_controller != null && !_controller!.value.isStreamingImages) {
          _canProcess = true;
          await _controller!.startImageStream(_processCameraImage);
        }
      } else {
        _sideFile = file;

        setState(() {
          _hintText = 'Đã chụp xong 2 ảnh.';
        });

        // Trả path ảnh về cho màn trước
        Navigator.of(
          context,
        ).pop({'frontPath': _frontFile!.path, 'sidePath': _sideFile!.path});
        return;
      }
    } catch (e) {
      debugPrint('[Capture] error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không chụp được ảnh, thử lại nhé')),
      );

      // Thử restart stream để user làm lại
      if (_controller != null && !_controller!.value.isStreamingImages) {
        _canProcess = true;
        await _controller!.startImageStream(_processCameraImage);
      }
    } finally {
      if (!mounted) return;
      setState(() {
        _isCapturingPhoto = false;
        _feetInGuide = false;
        _sidePoseOk = false;
        _readyForCapture = false;
      });
    }
  }

  /// Chuyển [CameraImage] -> [InputImage] (theo google_mlkit_commons)
  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_controller == null || _cameras.isEmpty) return null;
    final camera = _cameras[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;

    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      final deviceOrientation = _controller!.value.deviceOrientation;
      final rotationCompensation = _orientations[deviceOrientation];
      if (rotationCompensation == null) return null;

      if (camera.lensDirection == CameraLensDirection.front) {
        rotation = InputImageRotationValue.fromRawValue(
          (sensorOrientation + rotationCompensation) % 360,
        );
      } else {
        rotation = InputImageRotationValue.fromRawValue(
          (sensorOrientation - rotationCompensation + 360) % 360,
        );
      }
    }

    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;

    // ✅ Dùng plane đầu tiên (đúng kiểu NV21/BGRA mà MLKit mong muốn)
    final plane = image.planes.first;

    // kích thước thô của frame (chưa xoay)
    final rawSize = Size(image.width.toDouble(), image.height.toDouble());

    // ✅ Lưu lại kích thước sau xoay để vẽ overlay
    if (rotation == InputImageRotation.rotation90deg ||
        rotation == InputImageRotation.rotation270deg) {
      _lastImageSize = Size(rawSize.height, rawSize.width);
    } else {
      _lastImageSize = rawSize;
    }

    debugPrint(
      '[InputImage] rawSize=$rawSize, rotatedSize=$_lastImageSize, rotation=$rotation, format=$format, planes=${image.planes.length}',
    );

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        // LƯU Ý: MLKit muốn size trước xoay
        size: rawSize,
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  /// Rule:
  /// - FRONT: chỉ cần HAI BÀN CHÂN nằm trong ô nhỏ ở giữa phía dưới
  /// - SIDE: chân đúng ô + tư thế nghiêng (2 vai gần chồng lên nhau)
  ///
  /// Trả về: true nếu "đủ điều kiện chụp", đồng thời cập nhật:
  /// - _feetInGuide
  /// - _sidePoseOk
  bool _areFeetInGuide(List<Pose> poses, CameraImage img) {
    // reset mỗi frame
    _feetInGuide = false;
    _sidePoseOk = false;

    if (poses.isEmpty) return false;
    final pose = poses.first;

    // Ưu tiên dùng footIndex (ngón chân cái), fallback về gót chân nếu null
    final leftFoot =
        pose.landmarks[PoseLandmarkType.leftFootIndex] ??
        pose.landmarks[PoseLandmarkType.leftHeel];

    final rightFoot =
        pose.landmarks[PoseLandmarkType.rightFootIndex] ??
        pose.landmarks[PoseLandmarkType.rightHeel];

    final rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
    final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];

    if (leftFoot == null || rightFoot == null) return false;

    // Dùng size đã rotate nếu có, fallback về size gốc của frame
    final w = _lastImageSize?.width ?? img.width.toDouble();
    final h = _lastImageSize?.height ?? img.height.toDouble();

    // ----- VÙNG DỌC (chỉ 10–12% cuối cùng của ảnh) -----
    const feetBandFraction = 0.12; // 12% chiều cao cuối
    final bandTop = h * (1 - feetBandFraction);
    final bandBottom = h * 0.99; // chừa chút margin trên đáy

    // ----- VÙNG NGANG (ô ở giữa, chiếm ~25% chiều rộng) -----
    const centerWidthFraction = 0.25;
    final centerX = w / 2;
    final halfGuideWidth = w * centerWidthFraction / 2;
    final guideLeft = centerX - halfGuideWidth;
    final guideRight = centerX + halfGuideWidth;

    bool _inGuideFeet(PoseLandmark lm) {
      return lm.y >= bandTop &&
          lm.y <= bandBottom &&
          lm.x >= guideLeft &&
          lm.x <= guideRight;
    }

    // 1. Check chân
    final feetInside = _inGuideFeet(leftFoot) && _inGuideFeet(rightFoot);
    _feetInGuide = feetInside;

    if (!feetInside) {
      debugPrint(
        '[FeetGuide] feet NOT inside (stage=$_stage) '
        'L=(${leftFoot.x.toStringAsFixed(1)}, ${leftFoot.y.toStringAsFixed(1)}) '
        'R=(${rightFoot.x.toStringAsFixed(1)}, ${rightFoot.y.toStringAsFixed(1)})',
      );
      return false;
    }

    // 2. FRONT: chỉ cần chân đúng ô
    if (_stage == _CaptureStage.front) {
      _sidePoseOk = true; // coi như luôn ok
      debugPrint('[FeetGuide] FRONT ok feetInside=true w=$w h=$h');
      return true;
    }

    // 3. SIDE: chân đúng ô + vai nghiêng
    if (_stage == _CaptureStage.side) {
      if (rightShoulder == null || leftShoulder == null) {
        debugPrint('[FeetGuide] SIDE: missing shoulders => inside=false');
        _sidePoseOk = false;
        return false;
      }

      final shoulderDxNorm =
          (rightShoulder.x - leftShoulder.x).abs() / w; // 0..1
      final shoulderDyNorm =
          (rightShoulder.y - leftShoulder.y).abs() / h; // 0..1

      // Heuristic: hai vai gần như chồng lên nhau & không lệch dọc quá
      final sidePose = shoulderDxNorm < 0.08 && shoulderDyNorm < 0.12;

      _sidePoseOk = sidePose;

      debugPrint(
        '[FeetGuide] SIDE: shoulderDxNorm=$shoulderDxNorm, '
        'shoulderDyNorm=$shoulderDyNorm, sidePose=$sidePose',
      );

      return feetInside && sidePose;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          if (_error != null) {
            return Center(
              child: Text(
                'Không mở được camera:\n$_error',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (snapshot.connectionState != ConnectionState.done ||
              _controller == null ||
              !_controller!.value.isInitialized) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (_lastImageSize != null && _lastPoses.isNotEmpty) {
            debugPrint(
              'Drawing with size=$_lastImageSize and ${_lastPoses.length} poses',
            );
          }

          return Stack(
            children: [
              // CAMERA FULL MÀN
              Positioned.fill(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller!.value.previewSize!.height,
                    height: _controller!.value.previewSize!.width,
                    child: CameraPreview(_controller!),
                  ),
                ),
              ),

              // Skeleton overlay
              if (_lastImageSize != null && _lastPoses.isNotEmpty)
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: PosePainterMirror(
                        _lastPoses,
                        _lastImageSize!,
                        isFrontCamera: true,
                      ),
                    ),
                  ),
                ),

              // FEET GUIDE Ở DƯỚI
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: FeetGuideOverlay(isActive: _feetInGuide),
                ),
              ),

              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                      left: 16,
                      right: 16,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isCountingDown || _isCapturingPhoto) ...[
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.red,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Text(
                            _hintText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 50,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // NÚT ĐÓNG
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
