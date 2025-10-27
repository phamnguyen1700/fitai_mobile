// lib/features/setting/presentation/widgets/notification_group.dart
import 'package:flutter/material.dart';

class NotificationGroup extends StatefulWidget {
  const NotificationGroup({super.key});

  @override
  State<NotificationGroup> createState() => _NotificationGroupState();
}

class _NotificationGroupState extends State<NotificationGroup> {
  bool _all = false;
  bool _remindWorkout = false;
  bool _remindWater = false;
  bool _remindMeal = false;
  bool _remindWeighIn = false;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SwitchRow(
          label: 'Bật tắt cả thông báo',
          value: _all,
          onChanged: (v) => setState(() => _all = v),
        ),
        // 4 lời nhắc chia thành 2 cột × 2 hàng
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 4, // kiểm soát tỉ lệ
          children: [
            _CheckRow(
              label: 'Nhắc tập luyện',
              value: _remindWorkout,
              onChanged: (v) => setState(() => _remindWorkout = v),
            ),
            _CheckRow(
              label: 'Nhắc uống nước',
              value: _remindWater,
              onChanged: (v) => setState(() => _remindWater = v),
            ),
            _CheckRow(
              label: 'Nhắc bữa ăn',
              value: _remindMeal,
              onChanged: (v) => setState(() => _remindMeal = v),
            ),
            _CheckRow(
              label: 'Check-in cân nặng',
              value: _remindWeighIn,
              onChanged: (v) => setState(() => _remindWeighIn = v),
            ),
          ],
        ),
      ],
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: t.bodyLarge),
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: value,
            onChanged: onChanged,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}

class _CheckRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _CheckRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Transform.scale(
          scale: 0.8,
          child: Checkbox(
            value: value,
            onChanged: (v) => onChanged(v ?? false),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        Flexible(child: Text(label, style: t.bodySmall)),
      ],
    );
  }
}
