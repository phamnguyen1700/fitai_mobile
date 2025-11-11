import 'package:fitai_mobile/core/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitai_mobile/core/widgets/app_scaffold.dart';

import '../../widgets/user_data.dart';
import '../../widgets/setup_container.dart';
import '../../viewmodels/profile_draft_provider.dart';
import '../../viewmodels/dietary_preference_providers.dart';
import '../../../data/models/dietary_preference_request.dart';

class SetupDietStep extends ConsumerWidget {
  const SetupDietStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(profileDraftProvider);

    // LOG
    final loc = GoRouter.of(context).routeInformationProvider.value.location;
    final stack = GoRouter.of(context)
        .routerDelegate
        .currentConfiguration
        .matches
        .map((m) => m.matchedLocation)
        .toList();
    debugPrint('[Diet] build -> loc=$loc | stack=$stack');

    return AppScaffold(
      appBar: AppAppBar(title: 'Thiết lập hồ sơ cá nhân'),
      showLegalFooter: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: SetupContainer(
                child: DietPrefsFormCard(
                  initial: draft,
                  onSubmit: (d) async {
                    // 1️⃣ Cập nhật local draft
                    ref.read(profileDraftProvider.notifier).state = d;

                    // 2️⃣ Map ProfileDraft → DTO
                    String? _firstOrNull(Set<String> set) =>
                        set.isEmpty ? null : set.first;

                    final req = DietaryPreferenceRequest(
                      mealsPerDay: d.mealsPerDay,
                      cuisineType: null,
                      allergies: null,
                      avoidIngredients: _firstOrNull(d.dietDislikes),
                      preferredIngredients: _firstOrNull(d.dietLikes),
                      notes: d.extraFoods,
                    );

                    try {
                      // 3️⃣ Gọi repo thông qua Riverpod (codegen)
                      await ref
                          .read(dietaryPreferenceRepositoryProvider)
                          .save(req);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Lưu khẩu phần ăn thành công!'),
                          ),
                        );
                        context.go('/home');
                      }
                    } catch (e, st) {
                      debugPrint('[Diet] error: $e\n$st');
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Có lỗi khi lưu khẩu phần ăn, vui lòng thử lại.',
                          ),
                        ),
                      );
                    }

                    // 4️⃣ Log debug
                    final after = GoRouter.of(
                      context,
                    ).routeInformationProvider.value.location;
                    debugPrint('[Diet] SUBMIT after go -> $after');
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
