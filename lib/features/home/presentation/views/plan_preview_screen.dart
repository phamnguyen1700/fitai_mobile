// lib/features/home/presentation/views/plan_preview_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitai_mobile/features/home/presentation/viewmodels/home_state.dart';
import 'package:fitai_mobile/features/home/data/models/chat_thread_models.dart';
import 'package:fitai_mobile/features/home/presentation/viewmodels/chat_thread_provider.dart';
import 'package:fitai_mobile/features/daily/presentation/widgets/daily_date_selector.dart';
import 'package:fitai_mobile/features/home/presentation/widgets/food/meal_plan_preview_card.dart';

// Workout widgets
import 'package:fitai_mobile/features/home/presentation/widgets/workout/workout_card.dart';
import 'package:fitai_mobile/features/home/presentation/widgets/workout/exercise_video.dart';

class PlanPreviewBody extends ConsumerStatefulWidget {
  const PlanPreviewBody({super.key});

  @override
  ConsumerState<PlanPreviewBody> createState() => _PlanPreviewBodyState();
}

class _PlanPreviewBodyState extends ConsumerState<PlanPreviewBody> {
  /// Ngày gốc: hôm nay, bỏ giờ cho sạch
  late final DateTime _baseDate = DateUtils.dateOnly(DateTime.now());

  /// index ngày MEAL đang chọn (0 = hôm nay, 1 = +1 ngày, ...)
  int _selectedIndex = 0;

  /// index ngày WORKOUT đang chọn
  int _selectedWorkoutIndex = 0;

  /// trạng thái bấm nút xác nhận
  bool _isConfirming = false;

  DateTime _dateFromIndex(int index) {
    return _baseDate.add(Duration(days: index));
  }

  void _onDateChanged(DateTime newDate, int maxDays) {
    final diff = newDate.difference(_baseDate).inDays;
    final clamped = diff.clamp(0, maxDays - 1);
    if (clamped != _selectedIndex) {
      setState(() => _selectedIndex = clamped);
    }
  }

  Future<void> _onConfirmPressed() async {
    if (_isConfirming) return;

    setState(() => _isConfirming = true);
    final messenger = ScaffoldMessenger.of(context);

    try {
      // 1) Lấy data generate sẵn
      final workoutDays = await ref.read(workoutPlanDaysProvider.future);
      final mealDays = await ref.read(mealPlanDailyMealsProvider.future);

      if (workoutDays.isEmpty || mealDays.isEmpty) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              'Plan chưa đầy đủ để kích hoạt. Vui lòng thử lại sau.',
            ),
          ),
        );
        return;
      }

      // 2) Lưu workout plan
      final workoutSaver = ref.read(
        workoutPlanSaveAllControllerProvider.notifier,
      );
      await workoutSaver.saveFromGenerateDays(workoutDays);

      // 3) Lưu meal plan
      final mealSaver = ref.read(mealPlanSaveBatchControllerProvider.notifier);
      await mealSaver.saveFromGenerateDays(mealDays);

      // 4) Activate plan
      final activator = ref.read(
        aiHealthPlanActivateControllerProvider.notifier,
      );
      final activateResp = await activator.activate();

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            activateResp.data.isNotEmpty
                ? activateResp.data
                : 'Đã kích hoạt plan thành công!',
          ),
        ),
      );

      // ✅ Clear cache plan nếu muốn
      ref.invalidate(workoutPlanGenerateProvider);
      ref.invalidate(workoutPlanDaysProvider);
      ref.invalidate(mealPlanGenerateProvider);
      ref.invalidate(mealPlanDailyMealsProvider);

      // ✅ QUAY VỀ MÀN CHAT (message list)
      if (mounted) {
        ref.read(homeViewProvider.notifier).state = HomeView.chat;
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra khi lưu & kích hoạt plan: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isConfirming = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    // ✅ Meal plan
    final dailyMealsAsync = ref.watch(mealPlanDailyMealsProvider);

    // ✅ Workout plan
    final workoutDaysAsync = ref.watch(workoutPlanDaysProvider);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Expanded(
            child: dailyMealsAsync.when(
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
                        ref.invalidate(mealPlanDailyMealsProvider);
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
                        style: t.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final maxIndex = days.length - 1;
                final safeIndex = _selectedIndex.clamp(0, maxIndex);
                final selectedDay = days[safeIndex];
                final selectedDate = _dateFromIndex(safeIndex);
                final firstDate = _baseDate; // ngày bắt đầu plan (hôm nay)
                final lastDate = _baseDate.add(Duration(days: days.length - 1));
                return Column(
                  children: [
                    const SizedBox(height: 8),

                    // ===== DATE PICKER (MEAL) =====
                    DailyDateSelector(
                      selectedDate: selectedDate,
                      onChanged: (date) => _onDateChanged(date, days.length),
                      firstDate: firstDate,
                      lastDate: lastDate,
                    ),

                    const SizedBox(height: 8),

                    // ===== BODY =====
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          ref.invalidate(mealPlanDailyMealsProvider);
                          ref.invalidate(workoutPlanDaysProvider);
                        },

                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            // ---------- MEAL PLAN ----------
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              child: Text(
                                'Ngày ${selectedDay.dayNumber} - Meal plan',
                                style: t.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
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
                                    // TODO: đổi món
                                  },
                                ),
                              ),
                            ],

                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                'Đây là bản preview meal plan của bạn. '
                                'Sau này khi cho phép đổi món, bạn có thể chọn từng bữa để điều chỉnh phù hợp hơn.',
                                style: t.bodySmall?.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // ---------- WORKOUT PLAN ----------
                            workoutDaysAsync.when(
                              loading: () => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Đang tải lịch tập...',
                                      style: t.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                              error: (err, st) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Không tải được lịch tập.\n$err',
                                      style: t.bodyMedium?.copyWith(
                                        color: cs.error,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextButton.icon(
                                      onPressed: () => ref.refresh(
                                        workoutPlanGenerateProvider.future,
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
                                final safeWorkoutIndex = _selectedWorkoutIndex
                                    .clamp(0, maxWorkoutIndex);
                                final selectedWorkoutDay =
                                    workoutDays[safeWorkoutIndex];

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Text(
                                        'Lịch tập của bạn',
                                        style: t.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    // ==== CÁC THẺ NGÀY RENDER DỌC TỪ TRÊN XUỐNG ====
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
                                          dayTitle:
                                              'Day ${workoutDays[index].dayNumber}',
                                          featuredTitle:
                                              workoutDays[index].sessionName ??
                                              'Buổi tập',
                                          totalExercises: workoutDays[index]
                                              .exercises
                                              .length,
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
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Text(
                                        'Bài tập ngày ${selectedWorkoutDay.dayNumber}',
                                        style: t.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    // ==== LIST VIDEO CỦA NGÀY ĐANG CHỌN ====
                                    for (final ex
                                        in selectedWorkoutDay.exercises) ...[
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                'Đây là bản preview plan của bạn. '
                                'Sau này khi cho phép đổi món / chỉnh lịch tập, bạn có thể chọn từng bữa và từng bài tập để điều chỉnh phù hợp hơn.',
                                style: t.bodySmall?.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 8),
          SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isConfirming ? null : _onConfirmPressed,
                icon: _isConfirming
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: Text(
                  _isConfirming
                      ? 'Đang lưu & kích hoạt plan...'
                      : 'Xác nhận & kích hoạt plan',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
