import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitai_mobile/features/auth/presentation/viewmodels/auth_providers.dart';
import 'package:fitai_mobile/core/widgets/onboarding_gate.dart';
import '../widgets/weekly_checkin_card.dart';
import '../viewmodels/completion_providers.dart';
import 'package:fitai_mobile/core/widgets/inbody_history_chart.dart'
    show InbodyRecord;
import 'package:fitai_mobile/features/process/presentation/views/progress_review_screen.dart';
import 'package:fitai_mobile/features/process/presentation/views/new_plan_preview_screen.dart';
import 'package:fitai_mobile/features/process/presentation/viewmodels/achievement_providers.dart';
import 'package:fitai_mobile/features/daily/presentation/viewmodels/process_providers.dart';

enum ProcessViewState { weekly, review, newPlan }

class ProcessScreen extends ConsumerStatefulWidget {
  const ProcessScreen({super.key});

  @override
  ConsumerState<ProcessScreen> createState() => _ProcessScreenState();
}

class _ProcessScreenState extends ConsumerState<ProcessScreen> {
  final _scrollController = ScrollController();

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
    final user = authState.value?.user;
    final userHeight = user?.height;
    final onboardingStep = user?.onboardingStep?.toLowerCase();

    const checkpointLockMessage =
        'Chưa tới ngày checkpoint, bạn vui lòng quay lại sau.';

    return asyncData.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Lỗi: $err')),
      data: (data) {
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
        final asyncLineChart = ref.watch(progressLineChartProvider);

        return asyncLineChart.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, st) => Center(child: Text('Lỗi tải lịch sử: $err')),
          data: (lineResp) {
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

            final tierType = ref.watch(currentTierTypeProvider);
            final status = ref.watch(
              checkpointStatusProvider,
            ); // 🔒 Gate 1: Premium
            // 🔒 Gate 1 — Premium
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

              // 🔒 Gate 2 — Không có plan
              child: OnboardingGate(
                onboardingStep: null,
                subscriptionProductName: status, // TRUYỀN STATUS vào
                shouldLock: (s) => s == 'no_plan' || s == 'error',
                lockTitle: 'Chưa có kế hoạch',
                lockMessage: 'Bạn chưa có kế hoạch nào hoạt động.',
                borderRadius: BorderRadius.zero,

                // 🔒 Gate 3 — Checkpoint chưa tới
                child: OnboardingGate(
                  onboardingStep: onboardingStep,
                  subscriptionProductName: null,
                  shouldLock: (step) => step != 'checkpoint',
                  lockTitle: 'Chưa tới ngày checkpoint',
                  lockMessage: message ?? checkpointLockMessage,
                  borderRadius: BorderRadius.zero,

                  child: ListView(
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
                            ref.invalidate(achievementSummaryProvider);
                            ref.invalidate(progressLineChartProvider);
                            _showReview();
                          },
                        ),

                      if (_viewState == ProcessViewState.review)
                        ProgressReviewBody(
                          history: hist,
                          onBackToCheckin: _showWeekly,
                          onRequestNewPlan: _showNewPlan,
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
