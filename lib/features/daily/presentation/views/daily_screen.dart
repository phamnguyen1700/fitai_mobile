import 'package:fitai_mobile/features/daily/presentation/widgets/calo_count.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/today_meal_todo_card.dart';
import '../widgets/daily_date_selector.dart';
import '../widgets/daily_challenge_card.dart';
import '../viewmodels/meal_plan_providers.dart';
import '../../data/models/progress_item.dart';
import '../../data/models/workout_plan_block.dart';
import 'package:fitai_mobile/features/process/presentation/widgets/progress_overview_card.dart';

class DailyScreen extends ConsumerStatefulWidget {
  const DailyScreen({super.key});

  @override
  ConsumerState<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends ConsumerState<DailyScreen> {
  DateTime _selected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final asyncMeals = ref.watch(todayMealsProvider);

    // ===== Mock data =====
    final workoutItems = <ProgressItem>[
      ProgressItem(title: 'Ngực', done: 5, total: 5, checked: true),
      ProgressItem(title: 'Tay', done: 1, total: 2),
      ProgressItem(
        title: 'Uống nước',
        done: 1,
        total: 2,
        unit: 'L',
        isMetric: true,
      ),
      ProgressItem(
        title: 'Ngủ',
        done: 7,
        total: 8,
        unit: 'giờ',
        isMetric: true,
      ),
    ];
    final mealItems = <ProgressItem>[
      ProgressItem(
        title: 'Sáng',
        done: 2,
        total: 2,
        unit: 'món',
        checked: true,
      ),
      ProgressItem(title: 'Trưa', done: 0, total: 2, unit: 'món'),
      ProgressItem(title: 'Bữa phụ', done: 0, total: 2, unit: 'món'),
    ];

    final workoutBlocks = <WorkoutPlanBlock>[
      WorkoutPlanBlock(
        title: 'Tập ngực',
        leftStat: 'Bench press',
        rightStat: '3 × 12',
        progress: 0.5,
        calories: 500,
        levels: const ['Người mới', 'Trung cấp', 'Nâng cao'],
        videoTitle: 'Bench press – Beginner',
        videoThumb:
            'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=1200',
        category: 'Ngực',
        sets: 3,
        reps: 12,
        checked: true,
      ),
      WorkoutPlanBlock(
        title: 'Cardio',
        leftStat: 'Chạy tại chỗ',
        rightStat: '20 phút',
        progress: 0.25,
        calories: 300,
        levels: const ['Người mới', 'Trung cấp', 'Nâng cao'],
        videoTitle: 'Cardio tại chỗ – Beginner',
        videoThumb:
            'https://images.unsplash.com/photo-1558611848-73f7eb4001a1?w=1200',
        category: 'Cardio',
        minutes: 20,
      ),
    ];
    // ======================

    // ❌ Không bọc Scaffold nữa, để AppScaffold bên ngoài lo
    return SafeArea(
      top: false, // vì AppScaffold + AppBar đã chiếm phần top
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: DailyChallengeCard(
                deadline: TimeOfDay(hour: 9, minute: 0),
                participants: [
                  AssetImage('lib/core/assets/images/sticker1.png'),
                  AssetImage('lib/core/assets/images/sticker1.png'),
                  AssetImage('lib/core/assets/images/sticker1.png'),
                ],
                totalParticipants: 7,
                illustration: AssetImage(
                  'lib/core/assets/images/challenge.png',
                ),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: false,
            delegate: _StickyDateSelectorDelegate(
              extent: 120,
              child: ColoredBox(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: DailyDateSelector(
                    selectedDate: _selected,
                    onChanged: (d) {
                      final dayNum = d.weekday; // Monday=1 → Sunday=7
                      ref.read(currentDayProvider.notifier).set(dayNum);

                      setState(() => _selected = d);
                    },
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: asyncMeals.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Lỗi mạng. Vui lòng thử lại.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ),
              data: (day) => TodayMealPlan(
                day: day,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: ProgressOverviewCard(
              lastUpdated: DateTime(2025, 9, 16),
              currentWeightKg: 67.2,
              fatPercent: 18.5,
              musclePercent: 38.0,
              bonePercent: 12.0,
            ),
          ),
          SliverToBoxAdapter(
            child: CaloCount(
              goal: 2500,
              consumed: 2000,
              size: 88,
              thickness: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class _StickyDateSelectorDelegate extends SliverPersistentHeaderDelegate {
  _StickyDateSelectorDelegate({required double extent, required this.child})
    : minExtent = extent,
      maxExtent = extent;

  @override
  final double minExtent;
  @override
  final double maxExtent;
  final Widget child;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => SizedBox.expand(child: child);

  @override
  bool shouldRebuild(covariant _StickyDateSelectorDelegate old) =>
      old.minExtent != minExtent ||
      old.maxExtent != maxExtent ||
      old.child != child;
}
