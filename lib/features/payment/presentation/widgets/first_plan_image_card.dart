// lib/features/process/presentation/widgets/first_plan_image_card.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitai_mobile/core/status/bodygram_error.dart';
import 'package:fitai_mobile/features/camera/camera_level_guide_screen.dart';

// latest body data
import 'package:fitai_mobile/features/home/presentation/viewmodels/body_data_providers.dart';

/// Card dùng cho lần đầu tạo plan:
/// - Quét body bằng CameraLevelGuideScreen
/// - Gửi dữ liệu cho AI phân tích (upload + analyze)
///
/// Flow & UI giống phần "Quét dữ liệu cơ thể" trong WeeklyCheckInCard,
/// nhưng tách riêng, không có note / reminder / weight form.
class FirstPlanImageCard extends ConsumerStatefulWidget {
  /// Chiều cao hiện tại (cm) – truyền từ profile / step trước
  final double heightCm;

  /// Cân nặng hiện tại (kg) – truyền từ profile / step trước
  final double weightKg;

  /// Callback gọi API upload + analyze
  final Future<void> Function({
    required double height,
    required double weight,
    required String frontPath,
    required String sidePath,
  })
  onUploadAndAnalyze;

  /// Callback khi upload + analyze xong
  final VoidCallback? onCompleted;

  /// 🔴 Lỗi initial từ bước analyze đầu (gọi từ PaymentResultScreen)
  final String? initialErrorMessage; // NEW

  const FirstPlanImageCard({
    super.key,
    required this.heightCm,
    required this.weightKg,
    required this.onUploadAndAnalyze,
    this.onCompleted,
    this.initialErrorMessage, // NEW
  });

  @override
  ConsumerState<FirstPlanImageCard> createState() => _FirstPlanImageCardState();
}

class _FirstPlanImageCardState extends ConsumerState<FirstPlanImageCard> {
  String? _frontImagePath;
  String? _sideImagePath;

  bool _isUploadingBodygram = false;
  String? _bodygramError;

  @override
  void initState() {
    super.initState();
    // Gán lỗi initial (nếu có) để hiện ngay trong card
    _bodygramError = widget.initialErrorMessage; // NEW
  }

  String _bodygramErrorMessage(Object error) {
    if (error is BodygramAnalyzeException) {
      return error.status.explanation;
    }
    return 'Gửi dữ liệu Bodygram thất bại, vui lòng thử lại.';
  }

  Future<void> _openBodyCamera() async {
    final result = await Navigator.of(context, rootNavigator: true)
        .push<Map<String, dynamic>?>(
          MaterialPageRoute(
            builder: (_) => const CameraLevelGuideScreen(),
            fullscreenDialog: true,
          ),
        );

    if (result == null || !mounted) return;

    final front = result['frontPath'] as String?;
    final side = result['sidePath'] as String?;

    setState(() {
      _frontImagePath = front;
      _sideImagePath = side;
      _bodygramError = null;
    });
  }

  Future<void> _submitBodygram() async {
    setState(() => _bodygramError = null);

    final hasFront = _frontImagePath != null && _frontImagePath!.isNotEmpty;
    final hasSide = _sideImagePath != null && _sideImagePath!.isNotEmpty;

    if (!hasFront || !hasSide) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Hãy quét đủ 2 ảnh chính diện và bên hông trước khi gửi AI phân tích.',
          ),
        ),
      );
      return;
    }

    setState(() => _isUploadingBodygram = true);

    try {
      await widget.onUploadAndAnalyze(
        height: widget.heightCm,
        weight: widget.weightKg,
        frontPath: _frontImagePath!,
        sidePath: _sideImagePath!,
      );

      if (!mounted) return;

      _bodygramError = null;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã gửi dữ liệu Bodygram để AI phân tích.'),
        ),
      );

      widget.onCompleted?.call();
    } catch (e, st) {
      debugPrint('[FirstPlanImageCard] upload Bodygram ERROR: $e\n$st');
      if (!mounted) return;

      final message = _bodygramErrorMessage(e);
      setState(() {
        _bodygramError = message;
        _frontImagePath = null;
        _sideImagePath = null;
      });
    } finally {
      if (mounted) {
        setState(() => _isUploadingBodygram = false);
      }
    }
  }

  Widget _buildLoadingSection(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          'Đang gửi dữ liệu Bodygram để AI phân tích...',
          style: t.bodyMedium?.copyWith(color: cs.primary),
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          backgroundColor: cs.primary.withOpacity(0.15),
          valueColor: AlwaysStoppedAnimation(cs.primary),
          minHeight: 4,
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // Lấy latest body data (ảnh từ API)
    final latestBodyDataAsync = ref.watch(latestBodyDataProvider);
    final latestBodyData = latestBodyDataAsync.value;

    final frontUrl = latestBodyData?.frontImageUrl;
    final sideUrl = latestBodyData?.rightImageUrl;

    final hasFrontLocal =
        _frontImagePath != null && _frontImagePath!.isNotEmpty;
    final hasSideLocal = _sideImagePath != null && _sideImagePath!.isNotEmpty;

    final hasFrontRemote = frontUrl != null && frontUrl.isNotEmpty;
    final hasSideRemote = sideUrl != null && sideUrl.isNotEmpty;

    final hasAnyOverall =
        hasFrontLocal || hasSideLocal || hasFrontRemote || hasSideRemote;

    // Helper build ảnh ưu tiên: local file -> network -> asset mẫu
    Widget _buildFrontImage() {
      if (hasFrontLocal) {
        return Image.file(
          File(_frontImagePath!),
          height: 150,
          fit: BoxFit.cover,
        );
      }
      if (hasFrontRemote) {
        return Image.network(frontUrl!, height: 150, fit: BoxFit.cover);
      }
      return Image.asset(
        'lib/core/assets/images/front.png',
        height: 150,
        fit: BoxFit.contain,
      );
    }

    Widget _buildSideImage() {
      if (hasSideLocal) {
        return Image.file(
          File(_sideImagePath!),
          height: 150,
          fit: BoxFit.cover,
        );
      }
      if (hasSideRemote) {
        return Image.network(sideUrl!, height: 150, fit: BoxFit.cover);
      }
      return Image.asset(
        'lib/core/assets/images/right.png',
        height: 150,
        fit: BoxFit.contain,
      );
    }

    final card = Card(
      elevation: 0,
      color: cs.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========= Quét dữ liệu cơ thể =========
            Text(
              'Quét dữ liệu cơ thể',
              style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            // ẢNH: ưu tiên local -> API -> asset
            SizedBox(
              height: 180,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _buildFrontImage(),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Chính diện',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _buildSideImage(),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Mặt cạnh (R)',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            const Center(
              child: Text(
                'Tư thế chính xác',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
              ),
            ),
            const SizedBox(height: 8),

            // Hộp hướng dẫn (copy từ WeeklyCheckInCard)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest.withOpacity(0.35),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hướng dẫn chụp:',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '• Đứng thẳng, toàn thân nằm trong khung hình.\n'
                    '• Ánh sáng đủ, nền phía sau đơn giản.\n'
                    '• Mặc đồ ôm vừa, không quá rộng.',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            if (_bodygramError != null) ...[
              const SizedBox(height: 6),
              Text(
                _bodygramError!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],

            const SizedBox(height: 8),

            // Nút mở camera
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _openBodyCamera,
                icon: const Icon(Icons.photo_camera_outlined),
                label: Text(
                  hasAnyOverall
                      ? 'Quét lại dữ liệu cơ thể'
                      : 'Quét dữ liệu cơ thể',
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Nút gửi dữ liệu cho AI phân tích
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isUploadingBodygram ? null : _submitBodygram,
                child: const Text('Gửi AI phân tích'),
              ),
            ),
          ],
        ),
      ),
    );

    return Column(
      children: [card, if (_isUploadingBodygram) _buildLoadingSection(context)],
    );
  }
}
