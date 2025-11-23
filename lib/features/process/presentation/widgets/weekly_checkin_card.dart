import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitai_mobile/features/camera/camera_level_guide_screen.dart';
import '../../data/models/checkpoint_note_models.dart';
import '../viewmodels/checkpoint_note_providers.dart';

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

  const WeeklyCheckInCard({
    super.key,
    this.title = 'Check-in định kì lần:',
    this.progress = 0.0,
    this.onPickWeek,
    this.lastWeekImageUrl,
    this.checkpointNumber,
    this.statusMessage,
    this.initialHeight,
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

  // 🆕 path ảnh thực tế sau khi quét body
  String? _frontImagePath;
  String? _sideImagePath;

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

  Widget _buildWeightField(context) {
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

  Widget _buildHeightField(context) {
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

  /// 🆕 Gọi API lưu note + lời nhắc
  Future<void> _submitNote() async {
    final note = _noteCtrl.text.trim();

    // tuỳ bạn: có thể bắt buộc note không rỗng hoặc 1 trong 2 checkbox phải bật
    if (note.isEmpty && !_remindWeekly && !_sendEmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hãy nhập ghi chú hoặc bật ít nhất một lời nhắc.'),
        ),
      );
      return;
    }

    final req = CheckpointNoteRequest(
      remindWeekly: _remindWeekly,
      sendReportEmail: _sendEmail,
      note: note,
    );

    final controller = ref.read(checkpointNoteControllerProvider.notifier);

    final success = await controller.submitNote(req);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã lưu Weekly Check-in')));
      // tuỳ bạn: có muốn clear note không?
      // _noteCtrl.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lưu thất bại, vui lòng thử lại.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final p = widget.progress.clamp(0.0, 1.0);
    final percent = (p * 100).round();

    // Nếu có checkpointNumber thì ghép vào sau title – VD: "Check-in định kì lần: 1"
    final titleText = widget.checkpointNumber != null
        ? '${widget.title} ${widget.checkpointNumber}'
        : widget.title;

    // Text trạng thái: ưu tiên message từ API, fallback về "% hoàn thành"
    final statusText = widget.statusMessage ?? '$percent% Hoàn thành kế hoạch';

    // responsive: màn hẹp → 2 hàng, màn rộng → 1 hàng
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool isNarrow = shortestSide < 360;

    // 🆕 trạng thái ảnh
    final hasFront = _frontImagePath != null && _frontImagePath!.isNotEmpty;
    final hasSide = _sideImagePath != null && _sideImagePath!.isNotEmpty;
    final hasAny = hasFront || hasSide;

    // 🆕 trạng thái saving từ controller
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
            // Header: title + calendar
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

            // Progress bar + status text
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
              // ----- CHƯA CÓ ẢNH → ảnh mẫu + hướng dẫn -----
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
              // ----- ĐÃ CÓ ẢNH → hiển thị ảnh thật -----
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

            // Hộp hướng dẫn (giữ chung cho cả 2 trạng thái)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest.withOpacity(0.35),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
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
                onPressed: isSaving ? null : _submitNote,
                child: isSaving
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
