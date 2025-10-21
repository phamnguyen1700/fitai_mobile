// lib/features/home/presentation/views/plan_preview_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/widgets/plan/plan_header.dart';
import '../../presentation/widgets/plan/plan_cta.dart';
import '../../presentation/widgets/plan/plan_note.dart';
import '../../presentation/widgets/food/meal_day_card.dart';
import '../../presentation/widgets/workout/workout_day_card.dart';
import '../../presentation/widgets/workout/exercise_video_tile.dart';

class PlanPreviewBody extends StatefulWidget {
  const PlanPreviewBody({super.key});
  @override
  State<PlanPreviewBody> createState() => _PlanPreviewBodyState();
}

class _PlanPreviewBodyState extends State<PlanPreviewBody> {
  int _planIndex = 0; // workout: 0=3 buổi, 1=4 buổi
  int _mealIndex = 0; // meal:    0=Nam,    1=Nữ
  int _selectedDay = 0;

  @override
  Widget build(BuildContext context) {
    final plan = _planIndex == 0 ? DemoWorkout.plan3 : DemoWorkout.plan4;
    final days = plan.days;
    final mealDays = _mealIndex == 0 ? DemoFood.maleDays : DemoFood.femaleDays;

    final safeIndex = days.isEmpty ? 0 : _selectedDay.clamp(0, days.length - 1);
    final videos = days.isEmpty
        ? const <(String, String)>[]
        : days[safeIndex].videos;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: PlanHeader(
            workoutIndex: _planIndex,
            onWorkoutChanged: (i) => setState(() {
              _planIndex = i;
              _selectedDay = 0;
            }),
            mealIndex: _mealIndex,
            onMealChanged: (i) => setState(() => _mealIndex = i),
          ),
        ),

        // Pills workout
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index.isOdd) return const SizedBox(height: 4);
            final i = index ~/ 2;
            return WorkoutDayCard(
              dayTitle: days[i].title,
              exercises: days[i].summary,
              isSelected: _selectedDay == i,
              onTap: () => setState(() => _selectedDay = i),
            );
          }, childCount: days.isEmpty ? 0 : days.length * 2 - 1),
        ),

        // Meals
        for (final d in mealDays)
          SliverToBoxAdapter(
            child: MealDayCard(dayTitle: d.$1, meals: d.$2),
          ),

        // Videos
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
        if (days.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Video hướng dẫn — ${days[safeIndex].title}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        for (final v in videos)
          SliverToBoxAdapter(
            child: ExerciseVideoTile(title: v.$1, thumbUrl: v.$2),
          ),

        const SliverToBoxAdapter(
          child: PlanLimitNote(
            viewLimits: ['3 ngày đầu (Workout)', '1 ngày đầu (Meal)'],
            benefits: [
              'Kế hoạch 30 ngày cá nhân hóa',
              'Video hướng dẫn chi tiết',
              'Thực đơn kèm calo, protein, carb, fat',
            ],
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 12)),
        SliverToBoxAdapter(
          child: PlanCTA(
            text: 'Mua gói Premium',
            onPressed: () =>
                context.push('/payment'), // hoặc context.go('/payment')
          ),
        ),
      ],
    );
  }
}

/* ================= DEMO DATA ================= */

/// MealGroup/MealItem: giữ như file meal_day_card.dart của bạn
class DemoFood {
  // Nam ~ 2300 kcal/ngày
  static final maleDays = <(String, List<MealGroup>)>[
    (
      'Day 1',
      [
        MealGroup('Sáng', [
          MealItem('Yogurt + trái cây', {
            'Sữa chua Hy Lạp': '150g',
            'Chuối': '1 quả',
            'Hạt chia': '12g',
          }),
        ]),
        MealGroup('Trưa', [_saladChicken(200, 200, 150)]),
        MealGroup('Tối', [
          MealItem('Cơm gạo lứt + cá hồi', {
            'Cá hồi': '180g',
            'Gạo lứt': '160g',
            'Rau củ': '200g',
          }),
        ]),
      ],
    ),
    (
      'Day 2',
      [
        MealGroup('Sáng', [
          MealItem('Bánh mì nguyên cám', {
            'Bánh mì': '3 lát',
            'Bơ đậu phộng': '20g',
          }),
        ]),
        MealGroup('Trưa', [
          MealItem('Tôm xào rau', {'Tôm': '260g', 'Rau cải': '250g'}),
        ]),
        MealGroup('Tối', [
          MealItem('Bowl protein', {
            'Gạo lứt': '180g',
            'Ức gà': '200g',
            'Bơ': '60g',
          }),
        ]),
      ],
    ),
  ];

  // Nữ ~ 1600 kcal/ngày
  static final femaleDays = <(String, List<MealGroup>)>[
    (
      'Day 1',
      [
        MealGroup('Sáng', [
          MealItem('Yogurt + trái cây', {
            'Sữa chua Hy Lạp': '120g',
            'Chuối': '1/2 quả',
            'Hạt chia': '10g',
          }),
        ]),
        MealGroup('Trưa', [_saladChicken(160, 120, 120)]),
        MealGroup('Tối', [
          MealItem('Cơm gạo lứt + cá hồi', {
            'Cá hồi': '140g',
            'Gạo lứt': '110g',
            'Rau củ': '150g',
          }),
        ]),
      ],
    ),
    (
      'Day 2',
      [
        MealGroup('Sáng', [
          MealItem('Bánh mì nguyên cám', {
            'Bánh mì': '2 lát',
            'Bơ đậu phộng': '15g',
          }),
        ]),
        MealGroup('Trưa', [
          MealItem('Tôm xào rau', {'Tôm': '200g', 'Rau cải': '200g'}),
        ]),
        MealGroup('Tối', [
          MealItem('Bowl protein', {
            'Gạo lứt': '140g',
            'Ức gà': '160g',
            'Bơ': '40g',
          }),
        ]),
      ],
    ),
  ];

  static MealItem _saladChicken(num ga, num khoai, num rau) => MealItem(
    'Salad ức gà',
    {'Ức gà': '${ga}g', 'Khoai lang': '${khoai}g', 'Rau xanh': '${rau}g'},
  );
}

class WorkoutPlan {
  final String label;
  final List<WorkoutDay> days;
  const WorkoutPlan(this.label, this.days);
}

class WorkoutDay {
  final String title;
  final List<ExerciseItem> summary;
  final List<(String, String)> videos;
  const WorkoutDay(this.title, this.summary, this.videos);
}

class DemoWorkout {
  static final plan3 = WorkoutPlan('3 buổi / tuần', [
    WorkoutDay(
      'Push',
      [
        ExerciseItem(
          'Cardio',
          'https://picsum.photos/seed/push1/800/450',
          '30 phút',
        ),
        ExerciseItem(
          'Bench press',
          'https://picsum.photos/seed/push2/800/450',
          '3×12 reps',
        ),
      ],
      [
        ('Warm-up vai — 5 phút', 'https://picsum.photos/seed/pushv1/800/450'),
        ('Bench press cơ bản', 'https://picsum.photos/seed/pushv2/800/450'),
        (
          'Dumbbell shoulder press',
          'https://picsum.photos/seed/pushv3/800/450',
        ),
      ],
    ),
    WorkoutDay(
      'Pull',
      [
        ExerciseItem(
          'Cardio',
          'https://picsum.photos/seed/pull1/800/450',
          '30 phút',
        ),
        ExerciseItem(
          'Barbell row',
          'https://picsum.photos/seed/pull2/800/450',
          '3×10 reps',
        ),
      ],
      [
        (
          'Kéo xô rộng — hướng dẫn',
          'https://picsum.photos/seed/pullv1/800/450',
        ),
        ('Barbell row đúng form', 'https://picsum.photos/seed/pullv2/800/450'),
        ('Face pull dây cáp', 'https://picsum.photos/seed/pullv3/800/450'),
      ],
    ),
    WorkoutDay(
      'Legs',
      [
        ExerciseItem(
          'Cardio',
          'https://picsum.photos/seed/legs1/800/450',
          '30 phút',
        ),
        ExerciseItem(
          'Squat',
          'https://picsum.photos/seed/legs2/800/450',
          '3×12 reps',
        ),
      ],
      [
        (
          'Squat cơ bản — Beginner',
          'https://picsum.photos/seed/legsv1/800/450',
        ),
        ('Romanian deadlift', 'https://picsum.photos/seed/legsv2/800/450'),
        ('Lunge tiến — kỹ thuật', 'https://picsum.photos/seed/legsv3/800/450'),
      ],
    ),
  ]);

  static final plan4 = WorkoutPlan('4 buổi / tuần', [
    WorkoutDay(
      'Upper A',
      [
        ExerciseItem(
          'Cardio',
          'https://picsum.photos/seed/uppera1/800/450',
          '15 phút',
        ),
        ExerciseItem(
          'Incline press',
          'https://picsum.photos/seed/uppera2/800/450',
          '3×12',
        ),
      ],
      [
        (
          'Incline dumbbell press',
          'https://picsum.photos/seed/upperav1/800/450',
        ),
        (
          'Cable fly — ngực trên',
          'https://picsum.photos/seed/upperav2/800/450',
        ),
        ('Lat pulldown', 'https://picsum.photos/seed/upperav3/800/450'),
      ],
    ),
    WorkoutDay(
      'Lower A',
      [
        ExerciseItem(
          'Cardio',
          'https://picsum.photos/seed/lowera1/800/450',
          '15 phút',
        ),
        ExerciseItem(
          'Front squat',
          'https://picsum.photos/seed/lowera2/800/450',
          '4×8',
        ),
      ],
      [
        (
          'Front squat — hướng dẫn',
          'https://picsum.photos/seed/lowerav1/800/450',
        ),
        ('Leg press', 'https://picsum.photos/seed/lowerav2/800/450'),
        ('Calf raise', 'https://picsum.photos/seed/lowerav3/800/450'),
      ],
    ),
    WorkoutDay(
      'Upper B',
      [
        ExerciseItem(
          'Cardio',
          'https://picsum.photos/seed/upperb1/800/450',
          '15 phút',
        ),
        ExerciseItem(
          'Overhead press',
          'https://picsum.photos/seed/upperb2/800/450',
          '3×10',
        ),
      ],
      [
        ('Overhead press', 'https://picsum.photos/seed/upperbv1/800/450'),
        ('Seated row', 'https://picsum.photos/seed/upperbv2/800/450'),
        ('Triceps pushdown', 'https://picsum.photos/seed/upperbv3/800/450'),
      ],
    ),
    WorkoutDay(
      'Lower B',
      [
        ExerciseItem(
          'Cardio',
          'https://picsum.photos/seed/lowerb1/800/450',
          '15 phút',
        ),
        ExerciseItem(
          'Deadlift',
          'https://picsum.photos/seed/lowerb2/800/450',
          '3×5',
        ),
      ],
      [
        ('Deadlift cơ bản', 'https://picsum.photos/seed/lowerbv1/800/450'),
        ('Hip thrust', 'https://picsum.photos/seed/lowerbv2/800/450'),
        ('Leg curl', 'https://picsum.photos/seed/lowerbv3/800/450'),
      ],
    ),
  ]);
}
