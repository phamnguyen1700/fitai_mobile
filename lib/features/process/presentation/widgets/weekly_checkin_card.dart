import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitai_mobile/features/camera/camera_level_guide_screen.dart';
import '../../data/models/checkpoint_note_models.dart';
import '../viewmodels/checkpoint_note_providers.dart';
import 'package:fitai_mobile/features/process/presentation/viewmodels/bodygram_providers.dart';

class WeeklyCheckInCard extends ConsumerStatefulWidget {
  final String title; // fallback nếu không có checkpointNumber
  final double progress; // 0.0 – 1.0
  final VoidCallback? onPickWeek;
  final String? lastWeekImageUrl;

  /// Chiều cao hiện tại lấy từ profile (cm)
  final double? initialHeight;

  /// Số lần / số checkpoint
  final int? checkpointNumber;

  /// Message trạng thái từ API
  final String? statusMessage;

  /// 🆕 Callback khi lưu + upload + analyze xong
  final VoidCallback? onCompleted;

  const WeeklyCheckInCard({
    super.key,
    this.title = 'Check-in định kì lần:',
    this.progress = 0.0,
    this.onPickWeek,
    this.lastWeekImageUrl,
    this.checkpointNumber,
    this.statusMessage,
    this.initialHeight,
    this.onCompleted,
  });

  @override
  ConsumerState<WeeklyCheckInCard> createState() => _WeeklyCheckInCardState();
}

class _WeeklyCheckInCardState extends ConsumerState<WeeklyCheckInCard> {
  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  bool _remindWeekly = false;
  bool _sendEmail = false;

  // path ảnh thực tế sau khi quét body
  String? _frontImagePath;
  String? _sideImagePath;
  bool _isUploadingBodygram = false;

  @override
  void initState() {
    super.initState();

    if (widget.initialHeight != null) {
      _heightCtrl.text = widget.initialHeight!.toStringAsFixed(0);
    }
  }

  @override
  void didUpdateWidget(covariant WeeklyCheckInCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialHeight != null &&
        widget.initialHeight != oldWidget.initialHeight) {
      _heightCtrl.text = widget.initialHeight!.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  InputDecoration _numInputDeco(
    BuildContext context, {
    required String label,
    String? suffixText,
  }) {
    final cs = Theme.of(context).colorScheme;

    return InputDecoration(
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      suffixText: suffixText,
      filled: true,
      fillColor: cs.surface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    );
  }

  Widget _buildWeightField(BuildContext context) {
    return TextField(
      controller: _weightCtrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: _numInputDeco(
        context,
        label: 'Cân nặng hiện tại',
        suffixText: 'kg',
      ),
    );
  }

  Widget _buildHeightField(BuildContext context) {
    return TextField(
      controller: _heightCtrl,
      readOnly: true,
      decoration: _numInputDeco(
        context,
        label: 'Chiều cao hiện tại',
        suffixText: 'cm',
      ),
    );
  }

  Future<void> _openBodyCamera() async {
    final result = await Navigator.of(context, rootNavigator: true)
        .push<Map<String, dynamic>?>(
          MaterialPageRoute(
            builder: (_) => const CameraLevelGuideScreen(),
            fullscreenDialog: true,
          ),
        );

    if (result == null) return;

    final front = result['frontPath'] as String?;
    final side = result['sidePath'] as String?;

    if (!mounted) return;

    setState(() {
      _frontImagePath = front;
      _sideImagePath = side;
    });
  }

  Future<void> _submitNote() async {
    final note = _noteCtrl.text.trim();

    // 0) VALIDATE NOTE / REMINDER
    if (note.isEmpty && !_remindWeekly && !_sendEmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hãy nhập ghi chú hoặc bật ít nhất một lời nhắc.'),
        ),
      );
      return;
    }

    // 1) VALIDATE CÂN NẶNG
    final weightText = _weightCtrl.text.trim().replaceAll(',', '.');
    if (weightText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hãy nhập cân nặng hiện tại trước khi lưu.'),
        ),
      );
      return;
    }

    final double? weight = double.tryParse(weightText);
    if (weight == null || weight <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cân nặng không hợp lệ.')));
      return;
    }

    // 2) VALIDATE ẢNH BODYGRAM
    final hasFront = _frontImagePath != null && _frontImagePath!.isNotEmpty;
    final hasSide = _sideImagePath != null && _sideImagePath!.isNotEmpty;

    if (!hasFront || !hasSide) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Hãy quét đủ 2 ảnh chính diện và bên hông trước khi lưu.',
          ),
        ),
      );
      return;
    }

    // 3) PARSE CHIỀU CAO
    final heightText = _heightCtrl.text.trim().replaceAll(',', '.');
    final double? height = double.tryParse(heightText);

    if (height == null || height <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Chiều cao không hợp lệ.')));
      return;
    }

    // 4) LƯU NOTE + LỜI NHẮC
    final req = CheckpointNoteRequest(
      remindWeekly: _remindWeekly,
      sendReportEmail: _sendEmail,
      note: note,
    );

    final controller = ref.read(checkpointNoteControllerProvider.notifier);
    final success = await controller.submitNote(req);

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lưu ghi chú thất bại, vui lòng thử lại.'),
        ),
      );
      return;
    }

    // 5) NOTE OK → GỌI BODYGRAM
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã lưu Weekly Check-in, đang gửi Bodygram...'),
      ),
    );

    setState(() => _isUploadingBodygram = true);

    try {
      final repo = ref.read(bodygramRepositoryProvider);

      await repo.uploadFromWeeklyCheckin(
        height: height,
        weight: weight,
        frontPhotoPath: _frontImagePath!,
        sidePhotoPath: _sideImagePath!,
      );

      if (!mounted) return;

      // Snackbar báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã gửi dữ liệu Bodygram để AI phân tích.'),
        ),
      );

      // 🆕 báo cho màn ngoài biết là xong (để scroll / highlight overview)
      widget.onCompleted?.call();
    } catch (e, st) {
      debugPrint('[WeeklyCheckIn] upload Bodygram ERROR: $e\n$st');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gửi dữ liệu Bodygram thất bại: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isUploadingBodygram = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final p = widget.progress.clamp(0.0, 1.0);
    final percent = (p * 100).round();

    final titleText = widget.checkpointNumber != null
        ? '${widget.title} ${widget.checkpointNumber}'
        : widget.title;

    final statusText = widget.statusMessage ?? '$percent% Hoàn thành kế hoạch';

    final shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool isNarrow = shortestSide < 360;

    final hasFront = _frontImagePath != null && _frontImagePath!.isNotEmpty;
    final hasSide = _sideImagePath != null && _sideImagePath!.isNotEmpty;
    final hasAny = hasFront || hasSide;

    final noteState = ref.watch(checkpointNoteControllerProvider);
    final isSaving = noteState.isLoading;

    return Card(
      elevation: 0,
      color: cs.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    titleText,
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: widget.onPickWeek,
                  icon: const Icon(Icons.event_note_rounded),
                  tooltip: 'Chọn tuần',
                ),
              ],
            ),

            // Progress bar + status
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(999),
              ),
              clipBehavior: Clip.hardEdge,
              child: LinearProgressIndicator(
                color: cs.primary,
                value: p,
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 8),
            Text(statusText, style: tt.bodySmall?.copyWith(color: cs.primary)),

            // ========= Nhập thông số =========
            _sectionTitle(context, 'Nhập thông số'),
            if (isNarrow) ...[
              _buildWeightField(context),
              const SizedBox(height: 10),
              _buildHeightField(context),
            ] else ...[
              Row(
                children: [
                  Expanded(child: _buildWeightField(context)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildHeightField(context)),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Text(
              'AI sẽ phân tích BMI và % mỡ dự kiến từ cân nặng & chiều cao để điều chỉnh thực đơn.',
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),

            // ========= Quét dữ liệu cơ thể =========
            _sectionTitle(context, 'Quét dữ liệu cơ thể'),

            if (!hasAny) ...[
              // CHƯA CÓ ẢNH → ảnh mẫu
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
                            child: Image.asset(
                              'lib/core/assets/images/front.png',
                              height: 150,
                              fit: BoxFit.contain,
                            ),
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
                            child: Image.asset(
                              'lib/core/assets/images/right.png',
                              height: 150,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Bên hông',
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
            ] else ...[
              // ĐÃ CÓ ẢNH → hiển thị ảnh thật
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
                            child: hasFront
                                ? Image.file(
                                    File(_frontImagePath!),
                                    height: 150,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: 150,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: cs.surfaceContainerHighest,
                                    ),
                                    child: const Icon(
                                      Icons.person_outline,
                                      size: 40,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Chính diện (đã quét)',
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
                            child: hasSide
                                ? Image.file(
                                    File(_sideImagePath!),
                                    height: 150,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: 150,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: cs.surfaceContainerHighest,
                                    ),
                                    child: const Icon(
                                      Icons.person_outline,
                                      size: 40,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Bên hông (đã quét)',
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
            ],

            // Hộp hướng dẫn
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
            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _openBodyCamera,
                icon: const Icon(Icons.photo_camera_outlined),
                label: Text(
                  hasAny ? 'Quét lại dữ liệu cơ thể' : 'Quét dữ liệu cơ thể',
                ),
              ),
            ),

            // ========= Lời nhắc =========
            _sectionTitle(context, 'Lời nhắc'),
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Column(
                children: [
                  Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(visualDensity: VisualDensity.compact),
                    child: CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: _remindWeekly,
                      onChanged: (v) =>
                          setState(() => _remindWeekly = v ?? false),
                      title: const Text('Nhắc tôi cập nhật hằng tuần'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                  Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(visualDensity: VisualDensity.compact),
                    child: CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: _sendEmail,
                      onChanged: (v) => setState(() => _sendEmail = v ?? false),
                      title: const Text('Gửi báo cáo qua email'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                ],
              ),
            ),

            // ========= Ghi chú =========
            _sectionTitle(context, 'Ghi chú cảm nhận'),
            Text(
              'Hôm nay bạn cảm thấy thế nào?',
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _noteCtrl,
              maxLines: 4,
              maxLength: 1000,
              decoration: InputDecoration(
                hintText: 'Ghi chú',
                alignLabelWithHint: true,
                filled: true,
                fillColor: cs.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: (isSaving || _isUploadingBodygram)
                    ? null
                    : _submitNote,
                child: (isSaving || _isUploadingBodygram)
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Lưu cập nhật'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
