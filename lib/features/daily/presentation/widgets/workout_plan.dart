// lib/features/home/presentation/widgets/workout/today_workout_plan.dart
import 'package:flutter/material.dart';
import '../../data/models/workout_plan_block.dart';

class TodayWorkoutPlan extends StatefulWidget {
  const TodayWorkoutPlan({
    super.key,
    required this.blocks,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.shrinkWrap = true,
    this.physics = const NeverScrollableScrollPhysics(),
  });

  final List<WorkoutPlanBlock> blocks;

  /// Cho phép tuỳ chỉnh nhưng mặc định đã để “không scroll”
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  @override
  State<TodayWorkoutPlan> createState() => _TodayWorkoutPlanState();
}

class _TodayWorkoutPlanState extends State<TodayWorkoutPlan> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListView.separated(
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics, // <- không scroll (mặc định)
      itemCount: widget.blocks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final b = widget.blocks[i];

        return Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outlineVariant),
          ),
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // tiêu đề + checkbox
              Row(
                children: [
                  Checkbox(
                    value: b.checked,
                    onChanged: (v) => setState(() => b.checked = v ?? false),
                    activeColor: cs.primary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                      vertical: -4,
                    ),
                  ),
                  Text(
                    b.title,
                    style: TextStyle(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(b.leftStat), Text(b.rightStat)],
              ),
              const SizedBox(height: 6),

              Text(
                '${b.calories} Calo',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 6),

              // progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: b.progress.clamp(0, 1).toDouble(),
                  minHeight: 8,
                  backgroundColor: cs.surfaceVariant,
                ),
              ),
              const SizedBox(height: 10),

              // 🔹 TẠM THỜI: chỉ hiển thị thumbnail, chưa play video
              if (b.videoThumb.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(b.videoThumb, fit: BoxFit.cover),
                        const Center(
                          child: Icon(
                            Icons.play_circle_fill,
                            color: Colors.white,
                            size: 56,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
