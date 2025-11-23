import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitai_mobile/features/auth/presentation/viewmodels/auth_providers.dart';
import '../widgets/weekly_checkin_card.dart';
import '../viewmodels/completion_providers.dart';

class ProcessScreen extends ConsumerWidget {
  const ProcessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(previousCompletionDataProvider);
    final authState = ref.watch(authNotifierProvider);

    final userHeight = authState.value?.user?.height;

    return asyncData.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Lỗi: $err')),
      data: (data) {
        final completionPercent = data?.completionPercent;
        final checkpointNumber = data?.checkpointNumber;
        final message = data?.message;

        final progress = completionPercent == null
            ? 0.0
            : (completionPercent.clamp(0, 100) / 100.0);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            WeeklyCheckInCard(
              progress: progress,
              checkpointNumber: checkpointNumber,
              statusMessage: message,

              initialHeight: userHeight,
            ),

            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
