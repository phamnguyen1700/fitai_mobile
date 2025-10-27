import 'package:fitai_mobile/core/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/user_data.dart';
import '../../widgets/setup_container.dart';
import '../../viewmodels/profile_draft_provider.dart';
import '../../../../../core/router/app_router.dart';
import 'package:fitai_mobile/core/widgets/app_scaffold.dart';

class SetupOverviewStep extends ConsumerWidget {
  const SetupOverviewStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(profileDraftProvider);

    // LOG: location & matched stack
    final loc = GoRouter.of(context).routeInformationProvider.value.location;
    final stack = GoRouter.of(context)
        .routerDelegate
        .currentConfiguration
        .matches
        .map((m) => m.matchedLocation)
        .toList();
    debugPrint('[Overview] build -> loc=$loc | stack=$stack');

    return AppScaffold(
      appBar: AppAppBar(title: 'Thiết lập hồ sơ cá nhân'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: SetupContainer(
                child: UserDataFormCard(
                  initial: draft,
                  onSubmit: (d) {
                    ref.read(profileDraftProvider.notifier).state = d;
                    final before = GoRouter.of(
                      context,
                    ).routeInformationProvider.value.location;
                    debugPrint('[Overview] BEFORE push -> $before');
                    context.pushNamed(AppRoute.setupBody.name);
                    final after = GoRouter.of(
                      context,
                    ).routeInformationProvider.value.location;
                    debugPrint('[Overview] AFTER  push -> $after');
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      showLegalFooter: true,
    );
  }
}
