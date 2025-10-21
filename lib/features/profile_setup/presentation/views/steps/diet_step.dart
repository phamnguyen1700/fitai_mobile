import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/user_data.dart';
import '../../widgets/setup_container.dart';
import '../../viewmodels/profile_draft_provider.dart';
import 'package:fitai_mobile/core/widgets/app_scaffold.dart';

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
      title: 'Thiết lập hồ sơ cá nhân',
      showLegalFooter: true,
      showBack: true,
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
                    ref.read(profileDraftProvider.notifier).state = d;
                    final before = GoRouter.of(
                      context,
                    ).routeInformationProvider.value.location;
                    debugPrint('[Diet] SUBMIT before go -> $before');
                    context.go('/workout');
                    final after = GoRouter.of(
                      context,
                    ).routeInformationProvider.value.location;
                    debugPrint('[Diet] SUBMIT  after go -> $after');
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
