// lib/features/process/presentation/views/new_plan_preview_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ====== MODELS dùng chung ====== //
import 'package:fitai_mobile/features/home/data/models/chat_thread_models.dart'
    show DailyMealPlan, WorkoutPlanDay;

// ====== PROVIDERS cũ: workout + meal generate thường ====== //
import 'package:fitai_mobile/features/home/presentation/viewmodels/chat_thread_provider.dart'
    as home_plan;

// ====== PROVIDERS mới: healthplan (prepare + next target + generate-with-target) ====== //
import 'package:fitai_mobile/features/process/presentation/viewmodels/ai_healthplan_providers.dart'
    as health_plan;

// ====== WIDGETS DÙNG LẠI ====== //
import 'package:fitai_mobile/features/daily/presentation/widgets/daily_date_selector.dart';
import 'package:fitai_mobile/features/home/presentation/widgets/food/meal_plan_preview_card.dart';
import 'package:fitai_mobile/features/home/presentation/widgets/workout/workout_card.dart';
import 'package:fitai_mobile/features/home/presentation/widgets/workout/exercise_video.dart';

// Tổng quan tuần + banner
import 'package:fitai_mobile/features/process/presentation/widgets/weekly_overview_card.dart';
import 'package:fitai_mobile/features/process/presentation/widgets/pro_coach_upgrade_banner.dart';

class NewPlanPreviewBody extends ConsumerStatefulWidget {
  const NewPlanPreviewBody({super.key, this.onBack, this.onConfirm});

  final VoidCallback? onBack;
  final VoidCallback? onConfirm;

  @override
  ConsumerState<NewPlanPreviewBody> createState() => _NewPlanPreviewBodyState();
}

class _NewPlanPreviewBodyState extends ConsumerState<NewPlanPreviewBody> {
  /// Ngày gốc: hôm nay, bỏ giờ cho sạch
  late final DateTime _baseDate = DateUtils.dateOnly(DateTime.now());

  int _selectedMealIndex = 0;
  int _selectedWorkoutIndex = 0;

  DateTime _dateFromIndex(int index) {
    return _baseDate.add(Duration(days: index));
  }

  void _onMealDateChanged(DateTime newDate, int maxDays) {
    final diff = newDate.difference(_baseDate).inDays;
    final clamped = diff.clamp(0, maxDays - 1);
    if (clamped != _selectedMealIndex) {
      setState(() => _selectedMealIndex = clamped);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    // ✅ Meal plan từ healthplan (7–14 ngày, generate-with-target)
    final dailyMealsAsync = ref.watch(health_plan.mealPlanDaysProvider);

    // ✅ Workout plan từ flow cũ (vẫn tái sử dụng)
    final workoutDaysAsync = ref.watch(home_plan.workoutPlanDaysProvider);

    // ✅ Next target cho tuần mới (expectedWeightChange, calories, ...)
    final nextTargetAsync = ref.watch(health_plan.nextCheckpointTargetProvider);

    return dailyMealsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Không tải được meal plan.\n$err',
              textAlign: TextAlign.center,
              style: t.bodyMedium,
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () {
                // Refresh cả flow healthplan
                ref.refresh(health_plan.mealPlanGenerateProvider.future);
                ref.refresh(health_plan.mealPlanDaysProvider);
                ref.refresh(health_plan.nextCheckpointTargetProvider);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
      data: (List<DailyMealPlan> days) {
        if (days.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Chưa có meal plan để preview.',
                style: t.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        // ===== MEAL: map index -> day trong list =====
        final maxIndex = days.length - 1;
        final safeIndex = _selectedMealIndex.clamp(0, maxIndex);
        final selectedDay = days[safeIndex];
        final selectedDate = _dateFromIndex(safeIndex);

        // Tuần mới kết thúc sau N ngày của plan (7 hoặc 14)
        final weekEndDate = _baseDate.add(Duration(days: days.length));

        // Target cho checkpoint tiếp theo (có thể null nếu đang load / lỗi)
        final nextTarget = nextTargetAsync.asData?.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ===== TỔNG QUAN TUẦN MỚI =====
              WeeklyOverviewCard(
                weekEndDate: weekEndDate,
                expectedWeightChangeKg: nextTarget?.expectedWeightChangeKg,
                startWeightKg: nextTarget?.startWeightKg,
                targetWeightKg: nextTarget?.targetWeightKg,
                // backend trả int? => convert sang double? nếu cần
                targetCaloriesPerDay: nextTarget?.targetCaloriesPerDay
                    ?.toDouble(),
                goalText: nextTarget?.goalText ?? 'Tổng quan kế hoạch tuần mới',
                nutritionText: nextTarget?.nutritionText,
              ),

              const SizedBox(height: 16),

              // ===== DATE PICKER (MEAL) =====
              DailyDateSelector(
                selectedDate: selectedDate,
                onChanged: (date) => _onMealDateChanged(date, days.length),
              ),

              const SizedBox(height: 8),

              // ---------- MEAL PLAN ---------- //
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Text(
                  'Ngày ${selectedDay.dayNumber} - Meal plan',
                  style: t.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 4),

              for (final meal in selectedDay.meals) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: MealPlanPreviewCard(
                    meal: meal,
                    onSelect: (m) {
                      // TODO: sau này cho phép đổi món
                    },
                  ),
                ),
              ],

              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Đây là bản preview meal plan của bạn. '
                  'Sau này khi cho phép đổi món, bạn có thể chọn từng bữa để điều chỉnh phù hợp hơn.',
                  style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ),
              const SizedBox(height: 24),

              // ---------- WORKOUT PLAN ---------- //
              workoutDaysAsync.when(
                loading: () => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 8),
                      Text('Đang tải lịch tập...', style: t.bodyMedium),
                    ],
                  ),
                ),
                error: (err, st) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Không tải được lịch tập.\n$err',
                        style: t.bodyMedium?.copyWith(color: cs.error),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () => ref.refresh(
                          home_plan.workoutPlanGenerateProvider.future,
                        ),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Thử lại'),
                      ),
                    ],
                  ),
                ),
                data: (List<WorkoutPlanDay> workoutDays) {
                  if (workoutDays.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        'Chưa có lịch tập để preview.',
                        style: t.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    );
                  }

                  final maxWorkoutIndex = workoutDays.length - 1;
                  final safeWorkoutIndex = _selectedWorkoutIndex.clamp(
                    0,
                    maxWorkoutIndex,
                  );
                  final selectedWorkoutDay = workoutDays[safeWorkoutIndex];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Lịch tập của bạn',
                          style: t.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Thẻ từng ngày
                      for (
                        int index = 0;
                        index < workoutDays.length;
                        index++
                      ) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          child: WorkoutDayCard(
                            dayTitle: 'Day ${workoutDays[index].dayNumber}',
                            featuredTitle:
                                workoutDays[index].sessionName ?? 'Buổi tập',
                            totalExercises: workoutDays[index].exercises.length,
                            isSelected: index == safeWorkoutIndex,
                            onTap: () {
                              setState(() {
                                _selectedWorkoutIndex = index;
                              });
                            },
                          ),
                        ),
                      ],

                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Bài tập ngày ${selectedWorkoutDay.dayNumber}',
                          style: t.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // List bài tập của ngày đang chọn
                      for (final ex in selectedWorkoutDay.exercises) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: ExerciseVideo(
                            title: ex.name,
                            thumbUrl: '',
                            category: ex.category ?? 'Khác',
                            sets: ex.sets,
                            reps: ex.reps,
                            minutes: ex.durationMinutes,
                            videoUrl: ex.videoUrl,
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),

              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Đây là bản preview plan của bạn. '
                  'Sau này khi cho phép đổi món / chỉnh lịch tập, bạn có thể chọn từng bữa và từng bài tập để điều chỉnh phù hợp hơn.',
                  style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ),
              const SizedBox(height: 32),

              // Banner upsell Pro Coach
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ProCoachUpgradeBanner(
                  onTap: () {
                    Navigator.of(context).pushNamed('/subscription');
                  },
                ),
              ),
              const SizedBox(height: 24),

              /// ===== NÚT QUAY LẠI + XÁC NHẬN =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          if (widget.onBack != null) {
                            widget.onBack!();
                          } else {
                            Navigator.of(context).maybePop();
                          }
                        },
                        child: const Text('Quay lại'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          if (widget.onConfirm != null) {
                            widget.onConfirm!();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Đã xác nhận kế hoạch tuần mới ✅',
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text('Xác nhận kế hoạch'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}
