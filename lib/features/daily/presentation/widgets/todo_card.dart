import 'package:flutter/material.dart';
import '../../data/models/workout_plan_block.dart';
import '../../data/models/meal_models.dart';
import 'workout_plan.dart';
import 'meal_plan.dart';

class TodayTodoCard extends StatefulWidget {
  const TodayTodoCard({
    super.key,
    required this.workoutBlocks,
    required this.mealGroups,
  });

  final List<WorkoutPlanBlock> workoutBlocks;
  final List<MealGroup> mealGroups;

  @override
  State<TodayTodoCard> createState() => _TodayTodoCardState();
}

class _TodayTodoCardState extends State<TodayTodoCard>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 2, vsync: this);

  @override
  void initState() {
    super.initState();
    _tab.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget _buildTabContent() {
      // Hiển thị đúng nội dung của tab hiện tại (không dùng IndexedStack)
      if (_tab.index == 0) {
        return TodayWorkoutPlan(
          blocks: widget.workoutBlocks,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        );
      } else {
        return TodayMealPlan(
          groups: widget.mealGroups,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        );
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hôm nay cần làm',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 6),
            TabBar(
              controller: _tab,
              labelColor: cs.primary,
              unselectedLabelColor: cs.onSurfaceVariant,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: cs.primary, width: 2),
                insets: const EdgeInsets.symmetric(horizontal: 20),
              ),
              tabs: const [
                Tab(text: 'Kế hoạch tập luyện'),
                Tab(text: 'Thực đơn hôm nay'),
              ],
            ),
            const SizedBox(height: 8),

            // 🔥 Fit chiều cao theo nội dung tab hiện tại
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: _buildTabContent(),
            ),
          ],
        ),
      ),
    );
  }
}
