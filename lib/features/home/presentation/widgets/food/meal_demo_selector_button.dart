import 'package:flutter/material.dart';
import '../../../data/models/meal_demo_models.dart';

class MealDemoSelectorButton extends StatelessWidget {
  final List<MealDemo> demos;
  final int selectedIndex;
  final ValueChanged<int> onPicked;

  const MealDemoSelectorButton({
    super.key,
    required this.demos,
    required this.selectedIndex,
    required this.onPicked,
  });

  @override
  Widget build(BuildContext context) {
    final label = demos.isEmpty
        ? 'Chưa có thực đơn'
        : (demos[selectedIndex].planName ?? 'Thực đơn mẫu');

    return OutlinedButton.icon(
      onPressed: () => _open(context),
      icon: const Icon(Icons.restaurant_menu, size: 18),
      label: Text(label),
    );
  }

  Future<void> _open(BuildContext context) async {
    if (demos.isEmpty) return;

    final picked = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: demos.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final d = demos[i];

            return RadioListTile<int>(
              value: i,
              groupValue: selectedIndex,
              title: Text(d.planName ?? 'Thực đơn ${i + 1}'),
              subtitle: Text('Tối đa ~${d.maxDailyCalories ?? 0} kcal/ngày'),
              onChanged: (v) => Navigator.pop(ctx, v),
            );
          },
        ),
      ),
    );

    if (picked != null) {
      onPicked(picked);
    }
  }
}
