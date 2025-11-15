// lib/features/home/presentation/views/plan_preview_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/workout_demo_models.dart';
import '../../data/models/meal_demo_models.dart';
import '../viewmodels/workout_demo_provider.dart';
import 'package:fitai_mobile/features/home/presentation/viewmodels/meal_demo_provider.dart';
import 'package:fitai_mobile/features/home/presentation/widgets/food/meal_demo_section.dart';
import '../widgets/workout/workout_card.dart';
import '../widgets/workout/exercise_video.dart';
import '../widgets/workout/workout_plan_selector.dart';
import '../widgets/plan/plan_note.dart';

class PlanPreviewBody extends StatefulWidget {
  const PlanPreviewBody({super.key});

  @override
  State<PlanPreviewBody> createState() => _PlanPreviewBodyState();
}

class _PlanPreviewBodyState extends State<PlanPreviewBody> {
  int _planIndex = 0;
  int _dayIndex = 0;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Consumer(
      builder: (context, ref, _) {
        // 1) Workout demo
        final workoutAsync = ref.watch(workoutDemoListProvider);

        return workoutAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Lỗi workout demo: $e')),
          data: (res) {
            final plans = res?.data ?? const <WorkoutDemo>[];
            if (plans.isEmpty) {
              return const Center(child: Text('Chưa có Workout Demo'));
            }

            _planIndex = _planIndex.clamp(0, plans.length - 1);
            final plan = plans[_planIndex];

            if (plan.days.isEmpty) {
              // không có ngày tập nhưng vẫn show meal + quảng cáo
              return _buildWithMealSection(
                context,
                ref,
                t,
                plans: plans,
                plan: plan,
                hasWorkoutDays: false,
              );
            }

            _dayIndex = _dayIndex.clamp(0, plan.days.length - 1);

            return _buildWithMealSection(
              context,
              ref,
              t,
              plans: plans,
              plan: plan,
              hasWorkoutDays: true,
            );
          },
        );
      },
    );
  }

  /// Ghép phần MEAL DEMO (menu) + WORKOUT DEMO (lịch tập)
  Widget _buildWithMealSection(
    BuildContext context,
    WidgetRef ref,
    TextTheme t, {
    required List<WorkoutDemo> plans,
    required WorkoutDemo plan,
    required bool hasWorkoutDays,
  }) {
    // 2) Meal demo list
    final mealListAsync = ref.watch(
      mealDemoItemsProvider(pageNumber: 1, pageSize: 15),
    );

    return mealListAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Lỗi meal demo: $e')),
      data: (mealList) {
        MealDemo? selectedMeal;
        if (mealList.isNotEmpty) {
          // tạm thời chọn meal demo đầu tiên
          selectedMeal = mealList.first;
        }

        if (selectedMeal == null) {
          // Không có meal demo → chỉ render workout như cũ
          return _buildWorkoutOnly(context, t, plans, plan, hasWorkoutDays);
        }

        // 3) Lấy list menu của meal demo đã chọn
        final menusAsync = ref.watch(mealDemoMenusProvider(selectedMeal.id));

        return menusAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Lỗi menu: $e')),
          data: (menus) {
            final day = hasWorkoutDays ? plan.days[_dayIndex] : null;

            return CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: MealDemoSection()),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // ===== WORKOUT SECTION – LỊCH TẬP SAU =====
                if (hasWorkoutDays) ...[
                  // 1) selector plan
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Workout Demo · Chọn lịch mẫu',
                            style: t.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          WorkoutPlanSelectorButton(
                            plans: plans,
                            selectedIndex: _planIndex,
                            onPicked: (i) => setState(() {
                              _planIndex = i;
                              _dayIndex = 0;
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 2) pills ngày tập
                  SliverList.builder(
                    itemCount: plan.days.length,
                    itemBuilder: (_, i) {
                      final d = plan.days[i];
                      final first = d.exercises.isNotEmpty
                          ? d.exercises.first
                          : null;

                      final featuredTitle = first?.name ?? '—';
                      final featuredMeta = _meta(
                        first?.sets,
                        first?.reps,
                        first?.minutes,
                      );
                      final totalExercises = d.exercises.length;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: WorkoutDayCard(
                          dayTitle: d.dayName,
                          featuredTitle: featuredTitle,
                          featuredMeta: featuredMeta,
                          totalExercises: totalExercises,
                          isSelected: i == _dayIndex,
                          onTap: () => setState(() => _dayIndex = i),
                        ),
                      );
                    },
                  ),

                  // 3) list bài tập trong ngày
                  SliverList.builder(
                    itemCount: plan.days[_dayIndex].exercises.length,
                    itemBuilder: (_, i) {
                      final e = plan.days[_dayIndex].exercises[i];
                      return ExerciseVideoTile(
                        title: e.name ?? 'Bài tập',
                        thumbUrl: e.videoUrl ?? '',
                        category: e.category?.name ?? '—',
                        sets: e.sets,
                        reps: e.reps,
                        minutes: e.minutes,
                        videoUrl: e.videoUrl,
                      );
                    },
                  ),
                ] else
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('Lịch này chưa có ngày tập.'),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // 4) QUẢNG CÁO + NÚT PREMIUM
                SliverToBoxAdapter(
                  child: PlanLimitNote(
                    benefits: const [
                      'Kế hoạch 30 ngày cá nhân hóa',
                      'Video hướng dẫn chi tiết',
                      'Thực đơn kèm calo, protein, carb, fat',
                    ],
                    buttonText: 'Mua gói Premium',
                    onPressed: () => GoRouter.of(context).push('/payment'),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// fallback khi không có meal demo
  Widget _buildWorkoutOnly(
    BuildContext context,
    TextTheme t,
    List<WorkoutDemo> plans,
    WorkoutDemo plan,
    bool hasWorkoutDays,
  ) {
    if (!hasWorkoutDays) {
      return ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Text('Workout Demo · Chọn lịch mẫu', style: t.titleMedium),
          const SizedBox(height: 8),
          WorkoutPlanSelectorButton(
            plans: plans,
            selectedIndex: _planIndex,
            onPicked: (i) => setState(() {
              _planIndex = i;
              _dayIndex = 0;
            }),
          ),
          const SizedBox(height: 24),
          const Text('Lịch này chưa có ngày tập.'),
          const SizedBox(height: 24),
          PlanLimitNote(
            benefits: const [
              'Kế hoạch 30 ngày cá nhân hóa',
              'Video hướng dẫn chi tiết',
              'Thực đơn kèm calo, protein, carb, fat',
            ],
            buttonText: 'Mua gói Premium',
            onPressed: () => GoRouter.of(context).push('/payment'),
          ),
        ],
      );
    }

    final day = plan.days[_dayIndex];

    return CustomScrollView(
      slivers: [
        // selector plan
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Workout Demo · Chọn lịch mẫu', style: t.titleMedium),
                const SizedBox(height: 8),
                WorkoutPlanSelectorButton(
                  plans: plans,
                  selectedIndex: _planIndex,
                  onPicked: (i) => setState(() {
                    _planIndex = i;
                    _dayIndex = 0;
                  }),
                ),
              ],
            ),
          ),
        ),

        // pills
        SliverList.builder(
          itemCount: plan.days.length,
          itemBuilder: (_, i) {
            final d = plan.days[i];
            final first = d.exercises.isNotEmpty ? d.exercises.first : null;

            final featuredTitle = first?.name ?? '—';
            final featuredMeta = _meta(
              first?.sets,
              first?.reps,
              first?.minutes,
            );
            final totalExercises = d.exercises.length;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: WorkoutDayCard(
                dayTitle: d.dayName,
                featuredTitle: featuredTitle,
                featuredMeta: featuredMeta,
                totalExercises: totalExercises,
                isSelected: i == _dayIndex,
                onTap: () => setState(() => _dayIndex = i),
              ),
            );
          },
        ),

        // exercises
        SliverList.builder(
          itemCount: day.exercises.length,
          itemBuilder: (_, i) {
            final e = day.exercises[i];
            return ExerciseVideoTile(
              title: e.name ?? 'Bài tập',
              thumbUrl: e.videoUrl ?? '',
              category: e.category?.name ?? '—',
              sets: e.sets,
              reps: e.reps,
              minutes: e.minutes,
              videoUrl: e.videoUrl,
            );
          },
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 12)),

        SliverToBoxAdapter(
          child: PlanLimitNote(
            benefits: const [
              'Kế hoạch 30 ngày cá nhân hóa',
              'Video hướng dẫn chi tiết',
              'Thực đơn kèm calo, protein, carb, fat',
            ],
            buttonText: 'Mua gói Premium',
            onPressed: () => GoRouter.of(context).push('/payment'),
          ),
        ),
      ],
    );
  }

  String _meta(int? sets, int? reps, int? minutes) {
    if (minutes != null && minutes > 0) return '$minutes phút';
    if (sets != null && reps != null) return '$sets sets × $reps reps';
    return '';
  }
}
