// lib/features/process/presentation/views/progress_review_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitai_mobile/features/process/presentation/widgets/achievement_summary_card.dart';
import 'package:fitai_mobile/core/widgets/inbody_history_chart.dart'
    show InbodyRecord, InbodyHistoryChart;
import 'package:fitai_mobile/core/widgets/body_composition_donut.dart';

// Provider workout + meal (generate + days)
import 'package:fitai_mobile/features/home/presentation/viewmodels/chat_thread_provider.dart'
    as home_plan;

// Provider cho body composition pie chart
import 'package:fitai_mobile/features/daily/presentation/viewmodels/process_providers.dart';

// Provider cho AI health plan (prepare next checkpoint, next target, generate meal)
import 'package:fitai_mobile/features/process/presentation/viewmodels/ai_healthplan_providers.dart';
import 'package:fitai_mobile/features/process/presentation/viewmodels/achievement_providers.dart';

class ProgressReviewBody extends ConsumerStatefulWidget {
  final List<InbodyRecord> history;
  final VoidCallback? onBackToCheckin;
  final VoidCallback? onRequestNewPlan;

  const ProgressReviewBody({
    super.key,
    required this.history,
    this.onBackToCheckin,
    this.onRequestNewPlan,
  });

  @override
  ConsumerState<ProgressReviewBody> createState() => _ProgressReviewBodyState();
}

class _ProgressReviewBodyState extends ConsumerState<ProgressReviewBody> {
  bool _isGenerating = false;
  double _progress = 0;

  Future<void> _fakeProgress() async {
    const steps = [0.25, 0.55, 0.8, 0.92];
    for (final target in steps) {
      while (mounted && _progress < target) {
        await Future.delayed(const Duration(milliseconds: 70));
        setState(() => _progress += 0.01);
      }
      await Future.delayed(const Duration(milliseconds: 400));
    }
  }

  Future<void> _handleGeneratePlan() async {
    if (_isGenerating) return;

    final messenger = ScaffoldMessenger.of(context);

    setState(() {
      _isGenerating = true;
      _progress = 0;
    });

    _fakeProgress(); // chạy song song để tạo animation mượt

    try {
      final repo = ref.read(aiHealthPlanRepositoryProvider);

      // STEP 1 – Prepare next checkpoint (tạo draft cho workout và meal)
      final prepareRes = await repo.prepareNextCheckpoint();
      if (!prepareRes.success) {
        throw Exception(
          prepareRes.message ?? 'Không thể chuẩn bị checkpoint tiếp theo',
        );
      }

      // STEP 2 – Get next target (lấy target calories)
      final targetRes = await repo.getNextTarget();
      if (!targetRes.success || targetRes.data == null) {
        throw Exception(
          targetRes.message ?? 'Không thể lấy thông tin checkpoint tiếp theo',
        );
      }

      final targetCalories = targetRes.data!.targetCaloriesPerDay;
      if (targetCalories == null) {
        throw Exception('targetCaloriesPerDay bị null');
      }

      // STEP 3 – Generate Meal Plan với target calories
      final mealRes = await repo.generateMealPlanWithTarget(targetCalories);
      if (!mealRes.success) {
        throw Exception(mealRes.message ?? 'Generate meal plan thất bại');
      }

      // STEP 4 – Generate Workout Plan (cần draft từ step 1)
      await ref.read(home_plan.workoutPlanGenerateProvider.future);

      // STEP 5 – Load workout days
      await ref.read(home_plan.workoutPlanDaysProvider.future);

      // STEP 6 – Load meal days
      await ref.read(home_plan.mealPlanDailyMealsProvider.future);

      // Invalidate providers để refresh data
      ref.invalidate(home_plan.mealPlanGenerateProvider);
      ref.invalidate(nextCheckpointTargetProvider);

      // Jump full progress bar
      setState(() => _progress = 1.0);
      await Future.delayed(const Duration(milliseconds: 400));

      messenger.showSnackBar(
        const SnackBar(content: Text("Tạo kế hoạch tuần mới thành công!")),
      );

      widget.onRequestNewPlan?.call();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text("Tạo kế hoạch thất bại: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final history = widget.history;
    final hasHistory = history.isNotEmpty;
    final lastThree = history.length >= 3
        ? history.sublist(history.length - 3)
        : List<InbodyRecord>.from(history);

    final fatValues = lastThree.map((e) => e.pbf).toList();
    final trendText = _buildTrend(fatValues);

    // 👉 Lấy body composition data từ API
    final asyncBodyComp = ref.watch(bodyCompositionPieProvider);
    final achievementAsync = ref.watch(achievementSummaryProvider);

    // 👉 Screen: có scroll riêng, mỗi phần có container riêng
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// =====================
          /// HEADER (không có container)
          /// =====================
          Text(
            "Đánh giá tuần này",
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            "Dưới đây là đánh giá tổng quan dựa trên dữ liệu check-in gần nhất.",
            style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 16),

          /// =====================
          /// LINE CHART (có container riêng)
          /// =====================
          Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [InbodyHistoryChart(data: history)],
              ),
            ),
          ),
          const SizedBox(height: 16),

          /// =====================
          /// PHOTO COMPARE (có container riêng)
          /// =====================
          Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Ảnh đối chiếu", style: tt.titleSmall),
                  const SizedBox(height: 12),
                  if (hasHistory)
                    Column(
                      children: List.generate(
                        history.length,
                        (index) => Padding(
                          padding: EdgeInsets.only(
                            bottom: index == history.length - 1 ? 0 : 16,
                          ),
                          child: _checkpointPhotoSet(
                            context,
                            record: history[index],
                          ),
                        ),
                      ),
                    )
                  else
                    Text(
                      "Chưa có đủ dữ liệu để hiển thị ảnh đối chiếu.",
                      style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          /// =====================
          /// PIE CHART – PBF (có container riêng)
          /// =====================
          Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Inbody Composition", style: tt.titleSmall),
                  const SizedBox(height: 12),
                  asyncBodyComp.when(
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (e, _) => Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Không tải được dữ liệu cơ thể. Vui lòng thử lại.',
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                    data: (pieResp) {
                      final pieData = pieResp.data;

                      // Nếu API trả null data thì fallback 0
                      final fatPercent = pieData?.bodyFatPercent ?? 0;
                      final musclePercent = pieData?.skeletalMusclePercent ?? 0;
                      final bonePercent = pieData?.remainingPercent ?? 0;

                      return Column(
                        children: [
                          Center(
                            child: BodyCompositionDonut(
                              fatPercent: fatPercent,
                              musclePercent: musclePercent,
                              bonePercent: bonePercent,
                              size: 180,
                              centerHole: 36,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildLegend(context, lastThree, fatValues),
                          const SizedBox(height: 14),
                          Text(
                            trendText,
                            style: tt.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: cs.primary,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          /// =====================
          /// ACHIEVEMENT SUMMARY (có container riêng)
          /// =====================
          achievementAsync.when(
            data: (summary) => AchievementSummaryCard(summary: summary),
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Không tải được thành tích: $e',
                style: tt.bodySmall?.copyWith(color: cs.error),
              ),
            ),
          ),
          const SizedBox(height: 16),

          /// =====================
          /// ACTION AREA (không có container)
          /// =====================
          if (!_isGenerating)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onBackToCheckin,
                    child: const Text("Quay lại"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _handleGeneratePlan,
                    child: const Text("Nhận kế hoạch tuần mới"),
                  ),
                ),
              ],
            )
          else
            _buildLoadingSection(context),
        ],
      ),
    );
  }

  /// =======================
  /// Loading Section
  /// =======================
  Widget _buildLoadingSection(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          "Đang tạo kế hoạch tuần mới...",
          style: t.bodyMedium?.copyWith(color: cs.primary),
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: _progress,
          backgroundColor: cs.primary.withOpacity(0.15),
          valueColor: AlwaysStoppedAnimation(cs.primary),
          minHeight: 4,
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  /// =======================
  /// Legend
  /// =======================
  Widget _buildLegend(
    BuildContext context,
    List<InbodyRecord> three,
    List<double> fatValues,
  ) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Wrap(
      spacing: 16,
      runSpacing: 4,
      children: List.generate(fatValues.length, (i) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: i == 0
                    ? cs.primary
                    : i == 1
                    ? cs.primaryContainer
                    : cs.secondary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              "Lần đo ${three[i].checkpointNumber} – "
              "${fatValues[i].toStringAsFixed(1)}%",
              style: tt.bodySmall,
            ),
          ],
        );
      }),
    );
  }

  /// =======================
  Widget _checkpointPhotoSet(
    BuildContext context, {
    required InbodyRecord record,
  }) {
    final tt = Theme.of(context).textTheme;
    final infoText =
        "Lần đo ${record.checkpointNumber} – ${record.weight.toStringAsFixed(1)}kg";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          infoText,
          style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _photoTile(
                context,
                label: 'Chính diện',
                photoUrl: record.frontImageUrl,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _photoTile(
                context,
                label: 'Mặt cạnh (R)',
                photoUrl: record.rightImageUrl,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _photoTile(
    BuildContext context, {
    required String label,
    required String? photoUrl,
  }) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: photoUrl == null
              ? AspectRatio(
                  aspectRatio: 9 / 16,
                  child: Container(
                    color: cs.surfaceVariant,
                    child: const Icon(Icons.person, size: 40),
                  ),
                )
              : Image.network(
                  photoUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        const SizedBox(height: 6),
        Text(label, style: tt.bodySmall),
      ],
    );
  }

  /// =======================
  /// Trend Text
  /// =======================
  String _buildTrend(List<double> pbf) {
    if (pbf.length < 2) return "Chưa đủ dữ liệu để đánh giá xu hướng.";

    final diff = pbf.last - pbf.first;

    if (diff <= -2) return "Xu hướng giảm mạnh → rất tích cực 👏";
    if (diff < 0) return "PBF đang giảm nhẹ → tiếp tục duy trì!";
    if (diff.abs() < 1) return "PBF giữ ổn định → khá tốt!";
    return "PBF tăng → cần xem lại dinh dưỡng và tập luyện.";
  }
}
