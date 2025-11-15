import 'package:flutter/material.dart';
import 'package:fitai_mobile/features/home/data/models/workout_demo_models.dart';

class WorkoutPlanSelectorButton extends StatelessWidget {
  final List<WorkoutDemo> plans;
  final int selectedIndex;
  final ValueChanged<int> onPicked;

  const WorkoutPlanSelectorButton({
    super.key,
    required this.plans,
    required this.selectedIndex,
    required this.onPicked,
  });

  @override
  Widget build(BuildContext context) {
    final label = plans.isEmpty
        ? 'Chưa có lịch mẫu'
        : plans[selectedIndex].planName;

    return OutlinedButton.icon(
      onPressed: () => _open(context),
      icon: const Icon(Icons.list_alt_rounded, size: 18),
      label: Text(label),
    );
  }

  Future<void> _open(BuildContext context) async {
    if (plans.isEmpty) return;
    final picked = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: plans.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final p = plans[i];
            return RadioListTile<int>(
              value: i,
              groupValue: selectedIndex,
              title: Text(p.planName),
              subtitle: Text('Số ngày: ${p.days.length}'),
              onChanged: (v) => Navigator.pop(ctx, v),
            );
          },
        ),
      ),
    );
    if (picked != null) onPicked(picked);
  }
}
