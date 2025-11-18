// lib/features/home/presentation/views/plan_preview_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitai_mobile/features/home/data/models/chat_thread_models.dart';
import 'package:fitai_mobile/features/home/presentation/viewmodels/chat_thread_provider.dart';
import 'package:fitai_mobile/features/daily/presentation/widgets/daily_date_selector.dart';
import 'package:fitai_mobile/features/home/presentation/widgets/food/meal_plan_preview_card.dart';
import 'package:fitai_mobile/features/home/presentation/viewmodels/home_state.dart';

class PlanPreviewBody extends ConsumerStatefulWidget {
  const PlanPreviewBody({super.key});

  @override
  ConsumerState<PlanPreviewBody> createState() => _PlanPreviewBodyState();
}

class _PlanPreviewBodyState extends ConsumerState<PlanPreviewBody> {
  /// Ngày gốc: hôm nay, bỏ giờ cho sạch
  late final DateTime _baseDate = DateUtils.dateOnly(DateTime.now());

  /// index ngày đang chọn (0 = hôm nay, 1 = +1 ngày, ...)
  int _selectedIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    // Lấy list 14 DailyMealPlan từ provider
    final dailyMealsAsync = ref.watch(mealPlanDailyMealsProvider);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // ===== Nội dung chính (plan preview) =====
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
                      onPressed: () =>
                          ref.refresh(mealPlanDailyMealsProvider.future),
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

                return Column(
                  children: [
                    const SizedBox(height: 8),

                    // ===== DATE PICKER: 14 ngày từ hôm nay =====
                    DailyDateSelector(
                      selectedDate: selectedDate,
                      onChanged: (date) => _onDateChanged(date, days.length),
                    ),

                    const SizedBox(height: 8),

                    // ===== NỘI DUNG PLAN THEO NGÀY =====
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await ref.refresh(mealPlanDailyMealsProvider.future);
                        },
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              child: Text(
                                'Ngày ${selectedDay.dayNumber}',
                                style: t.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Mỗi bữa ăn = 1 card preview
                            for (final meal in selectedDay.meals) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                child: MealPlanPreviewCard(
                                  meal: meal,
                                  onSelect: (m) {
                                    // TODO: gọi API đổi món ở đây
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
                                'Đây là bản preview plan của bạn. '
                                'Sau này khi cho phép đổi món, bạn có thể chọn từng bữa để điều chỉnh phù hợp hơn.',
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
        ],
      ),
    );
  }
}
