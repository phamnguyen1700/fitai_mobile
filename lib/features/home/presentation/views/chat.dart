// lib/features/home/presentation/views/chat.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitai_mobile/features/home/presentation/viewmodels/home_state.dart';
import 'package:fitai_mobile/features/home/presentation/views/plan_preview_screen.dart'
    show PlanPreviewBody;

class HomeHostScreen extends ConsumerWidget {
  const HomeHostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(homeViewProvider);

    // Khi view = plan → hiển thị PlanPreviewBody
    if (view == HomeView.plan) {
      return const PlanPreviewBody();
    }

    return const _ChatWidget();
  }
}

/// Chat + nút mở plan
class _ChatWidget extends ConsumerWidget {
  const _ChatWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: cs.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outlineVariant),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.auto_awesome, color: cs.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kế hoạch cá nhân đã sẵn sàng',
                          style: t.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Tôi đã chuẩn bị bản demo 3 ngày. Bạn muốn xem chi tiết hơn chứ?',
                          style: t.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () =>
                              ref.read(homeViewProvider.notifier).state =
                                  HomeView.plan,
                          child: Text(
                            'Xem chi tiết',
                            style: t.bodyMedium?.copyWith(
                              color: cs.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              icon: const Icon(Icons.auto_graph_rounded),
              label: const Text('Xem Plan Preview'),
              onPressed: () =>
                  ref.read(homeViewProvider.notifier).state = HomeView.plan,
            ),
          ),
        ],
      ),
    );
  }
}
