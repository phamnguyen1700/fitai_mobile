import 'package:flutter/material.dart';

class WeeklyCheckInCard extends StatefulWidget {
  final String title; // ví dụ: 'Weekly Check-in (Tuần 3/12)'
  final double progress; // 0.0 – 1.0, ví dụ: 0.30
  final VoidCallback? onPickWeek; // mở date/week picker sau này
  final String? lastWeekImageUrl; // ảnh tuần trước (nếu có)

  const WeeklyCheckInCard({
    super.key,
    this.title = 'Weekly Check-in (Tuần 3/12)',
    this.progress = 0.30,
    this.onPickWeek,
    this.lastWeekImageUrl,
  });

  @override
  State<WeeklyCheckInCard> createState() => _WeeklyCheckInCardState();
}

class _WeeklyCheckInCardState extends State<WeeklyCheckInCard> {
  // controllers
  final _weightCtrl = TextEditingController();
  final _waistCtrl = TextEditingController();
  final _hipCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  bool _remindWeekly = false;
  bool _sendEmail = false;

  @override
  void dispose() {
    _weightCtrl.dispose();
    _waistCtrl.dispose();
    _hipCtrl.dispose();
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
    required String hint,
    String? suffixText,
  }) {
    final cs = Theme.of(context).colorScheme;
    return InputDecoration(
      hintText: hint,
      suffixText: suffixText,
      filled: true,
      fillColor: cs.surface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final p = widget.progress.clamp(0.0, 1.0);
    final percent = (p * 100).round();

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
                    widget.title,
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

            // Progress bar + % text
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
            Text(
              '$percent% Hoàn thành kế hoạch',
              style: tt.bodySmall?.copyWith(color: cs.primary),
            ),

            // ========= Inputs =========
            _sectionTitle(context, 'Nhập thông số'),
            TextField(
              controller: _weightCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: _numInputDeco(
                context,
                hint: 'Nhập cân nặng hiện tại (kg)',
                suffixText: 'kg',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _waistCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: _numInputDeco(
                context,
                hint: 'Nhập vòng eo (cm)',
                suffixText: 'cm',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _hipCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: _numInputDeco(
                context,
                hint: 'Nhập vòng mông (cm)',
                suffixText: 'cm',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'AI sẽ phân tích thay đổi % mỡ để điều chỉnh thực đơn.',
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),

            // ========= Upload ảnh =========
            _sectionTitle(context, 'Upload ảnh'),
            Row(
              children: [
                // Ảnh tuần trước
                _ImageTile(
                  label: 'Ảnh tuần trước',
                  imageUrl:
                      widget.lastWeekImageUrl ??
                      'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?q=80&w=800&auto=format&fit=crop',
                ),
                const SizedBox(width: 12),
                // Upload tuần này
                const _UploadTile(label: 'Thêm ảnh tuần này'),
              ],
            ),

            // ========= Lời nhắc =========
            _sectionTitle(context, 'Lời nhắc'),
            Padding(
              padding: const EdgeInsets.only(top: 0), // bỏ khoảng trống thừa
              child: Column(
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      visualDensity:
                          VisualDensity.compact, // ✅ thu nhỏ chiều cao
                    ),
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
                    data: Theme.of(context).copyWith(
                      visualDensity: VisualDensity.compact, // ✅ đồng bộ spacing
                    ),
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

            // ===== Submit row =====
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: () {
                  // TODO: gọi notifier để submit
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã lưu Weekly Check-in')),
                  );
                },
                child: const Text('Lưu cập nhật'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tile hiển thị ảnh (tuần trước)
class _ImageTile extends StatelessWidget {
  final String label;
  final String imageUrl;
  const _ImageTile({required this.label, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            imageUrl,
            width: 92,
            height: 92,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
        ),
      ],
    );
  }
}

/// Tile upload ảnh tuần này (mock)
class _UploadTile extends StatelessWidget {
  final String label;
  const _UploadTile({required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            // TODO: mở picker
          },
          child: Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: const Center(child: Icon(Icons.add, size: 28)),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
        ),
      ],
    );
  }
}
