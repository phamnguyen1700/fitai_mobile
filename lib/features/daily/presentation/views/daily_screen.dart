import 'package:fitai_mobile/features/daily/presentation/widgets/calo_count.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/today_meal_todo_card.dart';
import '../widgets/daily_date_selector.dart';
import '../widgets/daily_challenge_card.dart';
import '../viewmodels/meal_plan_providers.dart';

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

          // ===== Meal plan =====
          SliverToBoxAdapter(
            child: asyncMeals.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(16),
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

                /// 🔁 Upload ảnh xong thì refetch lại todayMealsProvider
                onReload: () {
                  ref.invalidate(todayMealsProvider);
                },
              ),
            ),
          ),

          // ===== Workout plan =====
          SliverToBoxAdapter(
            child: asyncWorkoutDays.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Không tải được lịch tập. Vui lòng thử lại.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ),
              data: (days) => TodayWorkoutPlanCard(
                days: days,
                initialDayNumber: days.isNotEmpty ? days.first.dayNumber : null,
              ),
            ),
          ),
          // ===== Progress overview (pie chart + line chart) =====
          SliverToBoxAdapter(
            child: asyncBodyComp.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Không tải được dữ liệu cơ thể. Vui lòng thử lại.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ),
              data: (pieResp) {
                final pieData = pieResp.data;

                // nếu API trả null data thì fallback 0
                final fatPercent = pieData?.bodyFatPercent ?? 0;
                final musclePercent = pieData?.skeletalMusclePercent ?? 0;

                // Ở UI hiện tại đang đặt tên là bonePercent,
                // nhưng backend trả remainingPercent → dùng tạm cho phần “khác”.
                final bonePercent = pieData?.remainingPercent ?? 0;

                // Cần cả line chart → lồng thêm asyncLine
                return asyncLine.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Không tải được lịch sử InBody. Vui lòng thử lại.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                  data: (lineResp) {
                    // Map từ ProgressLineChartResponse → List<InbodyRecord>
                    final inbodyHistory =
                        lineResp.data
                            .map(
                              (p) => InbodyRecord(
                                checkpointNumber: p.checkpointNumber,
                                measuredAt: p.measuredAt,
                                weight: p.weightKg.toDouble(),
                                // giả sử skeletalMuscleMass là gram → đổi sang kg
                                smm: p.skeletalMuscleMass / 1000.0,
                                // hiện đang dùng fatMassKg như % (API sẽ sửa sau)
                                pbf: p.fatPercent.toDouble(),
                              ),
                            )
                            .toList()
                          ..sort(
                            (a, b) => a.checkpointNumber.compareTo(
                              b.checkpointNumber,
                            ),
                          );

                    final currentWeightKg = inbodyHistory.isNotEmpty
                        ? inbodyHistory.last.weight
                        : 0.0;

                    return ProgressOverviewCard(
                      lastUpdated: inbodyHistory.isNotEmpty
                          ? (inbodyHistory.last.measuredAt ?? DateTime.now())
                          : DateTime.now(),
                      currentWeightKg: currentWeightKg,
                      fatPercent: fatPercent,
                      musclePercent: musclePercent,
                      bonePercent: bonePercent,
                      inbodyHistory: inbodyHistory,
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
