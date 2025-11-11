import 'package:fitai_mobile/features/daily/presentation/widgets/calo_count.dart';
import 'package:flutter/material.dart';

import '../widgets/daily_date_selector.dart';
import '../widgets/daily_challenge_card.dart';
import '../widgets/daily_progress_card.dart';
import '../widgets/todo_card.dart';

import '../models/progress_item.dart';
import '../models/meal_models.dart';
import '../models/workout_models.dart';
import 'package:fitai_mobile/features/process/presentation/widgets/progress_overview_card.dart';

class DailyScreen extends StatefulWidget {
  const DailyScreen({super.key});
  @override
  State<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  DateTime _selected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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
        leftStat: 'Nâng tạ',
        rightStat: '2 set 15 lần',
        progress: 0.5,
        calories: 500,
        levels: const ['Người mới', 'Trung cấp', 'Nâng cao'],
        videoTitle: 'Nâng tạ – Beginner',
        videoThumb:
            'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=1200',
        checked: true,
      ),
      WorkoutPlanBlock(
        title: 'Cardio',
        leftStat: 'Chạy tại chỗ',
        rightStat: '5km',
        progress: 0.25,
        calories: 500,
        levels: const ['Người mới', 'Trung cấp', 'Nâng cao'],
        videoTitle: 'Squat cơ bản – Beginner',
        videoThumb:
            'https://images.unsplash.com/photo-1558611848-73f7eb4001a1?w=1200',
      ),
    ];
    final mealGroups = <MealGroup>[
      MealGroup('Sáng', [
        MealItem('Bánh mì', {'Bánh mì': '2 lát'}),
        MealItem('Trứng', {'Trứng': '1 quả'}),
      ]),
      MealGroup('Trưa', [
        MealItem('Ức gà & khoai', {
          'Ức gà': '300g',
          'Khoai lang': '200g',
          'Rau xanh': '100g',
        }),
      ]),
      MealGroup('Bữa phụ', [
        MealItem('Salad cá ngừ', {'Calo': '350'}),
      ]),
    ];
    // ======================

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: DailyChallengeCard(
                  deadline: TimeOfDay(hour: 9, minute: 0),
                  participants: const [
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
                      onChanged: (d) => setState(() => _selected = d),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: DailyProgressCard(
                  title: 'Daily Progress',
                  activeColor: cs.primary,
                  workoutItems: workoutItems,
                  mealItems: mealItems,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: TodayTodoCard(
                workoutBlocks: workoutBlocks,
                mealGroups: mealGroups,
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
                goal: 2500, // kcal mục tiêu/ngày
                consumed: 2000, // đã nạp
                size: 88, // tuỳ chỉnh vòng tròn (mặc định 96)
                thickness: 9, // độ dày vòng
              ),
            ),
          ],
        ),
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
