import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'meal_demo_selector_button.dart';
import '../../../data/models/meal_demo_models.dart';
import '../../viewmodels/meal_demo_provider.dart';

class MealDemoSection extends ConsumerStatefulWidget {
  const MealDemoSection({super.key});

  @override
  ConsumerState<MealDemoSection> createState() => _MealDemoSectionState();
}

class _MealDemoSectionState extends ConsumerState<MealDemoSection> {
  int _demoIndex = 0; // chọn plan nào trong /mealdemo

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    // Lấy list meal demo (planName, goal, maxDailyCalories,...)
    final asyncDemos = ref.watch(mealDemoItemsProvider());

    return asyncDemos.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(12),
        child: LinearProgressIndicator(),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(12),
        child: Text('Lỗi tải thực đơn mẫu: $e'),
      ),
      data: (demos) {
        if (demos.isEmpty) return const SizedBox.shrink();

        _demoIndex = _demoIndex.clamp(0, demos.length - 1);
        final selected = demos[_demoIndex];

        // Khi chọn plan khác → provider family đổi key → tự gọi lại API
        final asyncDetails = ref.watch(
          mealDemoMenusProvider(selected.id ?? ''),
        );

        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Tiêu đề + info plan =====
              Text(
                'Thực đơn mẫu · ${selected.planName ?? "—"}',
                style: t.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Mục tiêu: ${selected.goal ?? "—"}'
                ' · Tối đa ~${selected.maxDailyCalories ?? 0} kcal/ngày',
                style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 12),

              // ===== Nút mở bottom sheet chọn plan (giống workout) =====
              MealDemoSelectorButton(
                demos: demos,
                selectedIndex: _demoIndex,
                onPicked: (i) {
                  setState(() => _demoIndex = i);
                },
              ),
              const SizedBox(height: 12),

              // ===== Danh sách menuNumber =====
              asyncDetails.when(
                loading: () => const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: LinearProgressIndicator(),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Lỗi tải menu: $e'),
                ),
                data: (menus) {
                  if (menus.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Chưa có thực đơn mẫu cho plan này.',
                        style: t.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [for (final menu in menus) _MenuCard(menu: menu)],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MenuCard extends StatelessWidget {
  final MealDemoDetail menu;

  const _MenuCard({required this.menu});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    final kcal = (menu.totalCalories ?? 0).toStringAsFixed(1);
    final carbs = (menu.totalCarbs ?? 0).toStringAsFixed(1);
    final protein = (menu.totalProtein ?? 0).toStringAsFixed(1);
    final fat = (menu.totalFat ?? 0).toStringAsFixed(1);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Header menuNumber có nền primary =====
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'Menu ${menu.menuNumber ?? "-"}',
              style: t.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onPrimary,
              ),
            ),
          ),
          const SizedBox(height: 6),

          // ===== Tổng macro: C/P/F bên trái, kcal bên phải =====
          Row(
            children: [
              // C, P, F (trái)
              Expanded(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    _MacroDot(
                      color: Colors.orangeAccent,
                      label: 'Carb: ${carbs}g',
                      textStyle: t.bodySmall,
                    ),
                    _MacroDot(
                      color: Colors.lightGreenAccent,
                      label: 'Protein: ${protein}g',
                      textStyle: t.bodySmall,
                    ),
                    _MacroDot(
                      color: Colors.cyanAccent,
                      label: 'Fat: ${fat}g',
                      textStyle: t.bodySmall,
                    ),
                  ],
                ),
              ),

              // kcal (phải)
              _MacroDot(
                color: cs.primary,
                label: '$kcal kcal',
                textStyle: t.bodySmall,
              ),
            ],
          ),

          const SizedBox(height: 12),
          Divider(color: cs.outlineVariant, height: 16),

          // ===== Danh sách từng session =====
          for (final session in menu.sessions ?? []) ...[
            _SessionTable(session: session),
            const SizedBox(height: 8),
            Divider(color: cs.outlineVariant.withOpacity(0.4), height: 16),
          ],
          if ((menu.sessions ?? []).isEmpty)
            Text(
              'Chưa có món cho menu này.',
              style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
        ],
      ),
    );
  }
}

class _SessionTable extends StatelessWidget {
  final MealSession session;

  const _SessionTable({required this.session});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    final ingredients = session.ingredients ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // tên session
        Text(
          session.sessionName ?? 'Bữa',
          style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),

        if (ingredients.isEmpty)
          Text(
            'Chưa có nguyên liệu.',
            style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          )
        else ...[
          for (final ing in ingredients)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  // Tên món sát trái
                  Expanded(child: Text(ing.name ?? 'Món', style: t.bodySmall)),

                  // weight sát phải
                  Text(
                    '${ing.weight ?? 0}g',
                    style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }
}

class _MacroDot extends StatelessWidget {
  final Color color;
  final String label;
  final TextStyle? textStyle;

  const _MacroDot({required this.color, required this.label, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: textStyle),
      ],
    );
  }
}
