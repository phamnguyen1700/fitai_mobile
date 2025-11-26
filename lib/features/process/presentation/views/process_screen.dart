import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitai_mobile/features/auth/presentation/viewmodels/auth_providers.dart';
import '../widgets/weekly_checkin_card.dart';
import '../viewmodels/completion_providers.dart';

// dùng InbodyRecord từ core
import 'package:fitai_mobile/core/widgets/inbody_history_chart.dart'
    show InbodyRecord;

// Review card
import 'package:fitai_mobile/features/process/presentation/views/progress_review_screen.dart';
import 'package:fitai_mobile/features/process/presentation/views/new_plan_preview_screen.dart';

// 👉 import providers cho achievement
import 'package:fitai_mobile/features/process/presentation/viewmodels/achievement_providers.dart';

// 👉 import provider cho progress line chart (có chứa image URLs)
import 'package:fitai_mobile/features/daily/presentation/viewmodels/process_providers.dart';

/// ⭐️ trạng thái đang hiển thị màn nào
enum ProcessViewState { weekly, review, newPlan }

class ProcessScreen extends ConsumerStatefulWidget {
  const ProcessScreen({super.key});

  @override
  ConsumerState<ProcessScreen> createState() => _ProcessScreenState();
}

class _ProcessScreenState extends ConsumerState<ProcessScreen> {
  final _scrollController = ScrollController();

  /// Mặc định hiện weekly check-in hay review tuỳ bạn
  ProcessViewState _viewState = ProcessViewState.weekly;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showWeekly() {
    setState(() => _viewState = ProcessViewState.weekly);
  }

  void _showReview() {
    setState(() => _viewState = ProcessViewState.review);
  }

  void _showNewPlan() {
    setState(() => _viewState = ProcessViewState.newPlan);
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(previousCompletionDataProvider);
    final authState = ref.watch(authNotifierProvider);

    // ⭐ achievement
    final achievementAsync = ref.watch(achievementSummaryProvider);

    // 👉 Lấy progress line chart data (có chứa image URLs)
    final asyncLineChart = ref.watch(progressLineChartProvider);

    final user = authState.value?.user;
    final userHeight = user?.height;
    final userWeight = user?.weight ?? 70.0;

    return asyncData.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Lỗi: $err')),
      data: (data) {
        // 👉 Nếu đã chuyển sang màn New Plan thì trả về NewPlanPreview như 1 screen riêng
        if (_viewState == ProcessViewState.newPlan) {
          return const NewPlanPreviewBody();
        }

        final completionPercent = data?.completionPercent;
        final checkpointNumber = data?.checkpointNumber;
        final message = data?.message;

        final progress = completionPercent == null
            ? 0.0
            : (completionPercent.clamp(0, 100) / 100.0);

        // 👉 Lấy history từ API (có chứa image URLs)
        return asyncLineChart.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, st) => Center(child: Text('Lỗi tải lịch sử: $err')),
          data: (lineResp) {
            // Map từ ProgressLineChartResponse → List<InbodyRecord> (có image URLs)
            final hist =
                lineResp.data
                    .map(
                      (p) => InbodyRecord(
                        checkpointNumber: p.checkpointNumber,
                        measuredAt: p.measuredAt,
                        weight: p.weightKg.toDouble(),
                        smm: p.skeletalMuscleMass / 1000.0,
                        pbf: p.fatPercent.toDouble(),
                        frontImageUrl: p.frontImageUrl,
                        rightImageUrl: p.rightImageUrl,
                      ),
                    )
                    .toList()
                  ..sort(
                    (a, b) => a.checkpointNumber.compareTo(b.checkpointNumber),
                  );

            return ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                if (_viewState == ProcessViewState.weekly)
                  WeeklyCheckInCard(
                    progress: progress,
                    checkpointNumber: checkpointNumber,
                    statusMessage: message,
                    initialHeight: userHeight,
                    onCompleted: () {
                      // fetch achievement + chuyển sang màn review
                      ref.invalidate(achievementSummaryProvider);
                      ref.invalidate(progressLineChartProvider);
                      _showReview();
                    },
                  ),

                if (_viewState == ProcessViewState.review)
                  ProgressReviewBody(
                    history: hist,
                    achievementSummary: achievementAsync.value,
                    onBackToCheckin: _showWeekly,
                    onRequestNewPlan: _showNewPlan,
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
