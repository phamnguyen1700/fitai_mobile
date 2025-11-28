import 'package:fitai_mobile/features/auth/presentation/viewmodels/auth_providers.dart';
import 'package:fitai_mobile/features/daily/presentation/widgets/calo_count.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/today_meal_todo_card.dart';
import '../widgets/daily_date_selector.dart';
import '../widgets/daily_challenge_card.dart';
import '../viewmodels/meal_plan_providers.dart';
import 'package:fitai_mobile/core/widgets/onboarding_gate.dart';
import 'package:fitai_mobile/features/process/presentation/widgets/progress_overview_card.dart';
import 'package:fitai_mobile/core/widgets/inbody_history_chart.dart';
import 'package:fitai_mobile/features/daily/presentation/viewmodels/process_providers.dart';
import 'package:fitai_mobile/features/daily/presentation/widgets/today_workout_plan_card.dart';
import 'package:fitai_mobile/features/daily/presentation/viewmodels/workout_plan_providers.dart';

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

    final asyncWorkoutDays = ref.watch(workoutPlanDaysProvider);
    final asyncMeals = ref.watch(todayMealsProvider);
    final asyncBodyComp = ref.watch(bodyCompositionPieProvider);
    final asyncLine = ref.watch(progressLineChartProvider);

    final mealPlanStatus = ref.watch(mealPlanStatusProvider);
    final user = ref.watch(currentUserProvider);
    final tierType = ref.watch(currentTierTypeProvider);

    /// =============
    /// Gate 1: Premium+
    /// =============
    return OnboardingGate(
      onboardingStep: null,
      subscriptionProductName: tierType,
      shouldLock: (value) {
        if (value == null) return true;
        return value.toUpperCase() == 'FREE';
      },
      lockTitle: 'Chỉ dành cho gói Premium+',
      lockMessage:
          'Nâng cấp lên Premium+ để xem lịch ăn, lịch tập và theo dõi InBody mỗi ngày.',
      borderRadius: BorderRadius.zero,

      /// =============
      /// Gate 2: chưa có kế hoạch
      /// =============
      child: OnboardingGate(
        onboardingStep:
            mealPlanStatus, // 'has_plan', 'no_plan', 'error', 'loading'
        subscriptionProductName: null,
        shouldLock: (status) => status == 'no_plan',
        lockTitle: 'Chưa có kế hoạch',
        lockMessage: 'Bạn chưa có kế hoạch nào hoạt động.',

        borderRadius: BorderRadius.zero,

        child: SafeArea(
          top: false,
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

              /// ===== Date selector =====
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
                          ref.read(currentDayProvider.notifier).set(d.weekday);
                          setState(() => _selected = d);
                        },
                      ),
                    ),
                  ),
                ),
              ),

              /// ===== Meal plan =====
              SliverToBoxAdapter(
                child: asyncMeals.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Không tải được lịch ăn.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                  data: (res) => res.status == 'has_plan'
                      ? TodayMealPlan(
                          day: res.data!,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          waitingReviewMessage: user?.message,
                          onReload: () => ref.invalidate(todayMealsProvider),
                        )
                      : const SizedBox.shrink(),
                ),
              ),

              /// ===== Workout plan =====
              SliverToBoxAdapter(
                child: asyncWorkoutDays.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Không tải được lịch tập.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                  data: (days) => TodayWorkoutPlanCard(
                    days: days,
                    initialDayNumber: days.isNotEmpty
                        ? days.first.dayNumber
                        : null,
                    waitingReviewMessage: user?.message,
                  ),
                ),
              ),

              /// ===== Progress overview =====
              SliverToBoxAdapter(
                child: asyncBodyComp.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Không tải được dữ liệu cơ thể.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                  data: (pieResp) {
                    final pie = pieResp.data;
                    final fatPercent = pie?.bodyFatPercent ?? 0;
                    final musclePercent = pie?.skeletalMusclePercent ?? 0;
                    final bonePercent = pie?.remainingPercent ?? 0;

                    return asyncLine.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (_, __) => Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Không tải được lịch sử InBody.',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: cs.onSurfaceVariant),
                        ),
                      ),
                      data: (lineResp) {
                        final list =
                            lineResp.data
                                .map(
                                  (p) => InbodyRecord(
                                    checkpointNumber: p.checkpointNumber,
                                    measuredAt: p.measuredAt,
                                    weight: p.weightKg.toDouble(),
                                    smm: p.skeletalMuscleMass / 1000.0,
                                    pbf: p.fatPercent.toDouble(),
                                  ),
                                )
                                .toList()
                              ..sort(
                                (a, b) => a.checkpointNumber.compareTo(
                                  b.checkpointNumber,
                                ),
                              );

                        return ProgressOverviewCard(
                          lastUpdated: list.isNotEmpty
                              ? (list.last.measuredAt ?? DateTime.now())
                              : DateTime.now(),
                          currentWeightKg: list.isNotEmpty
                              ? list.last.weight
                              : 0.0,
                          fatPercent: fatPercent,
                          musclePercent: musclePercent,
                          bonePercent: bonePercent,
                          inbodyHistory: list,
                        );
                      },
                    );
                  },
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
        ),
      ),
    );
  }
}

/// Sticky header
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
