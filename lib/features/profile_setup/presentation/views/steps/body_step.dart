import 'package:fitai_mobile/core/widgets/legal_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/user_data.dart';
import '../../widgets/setup_container.dart';
import '../../viewmodels/profile_draft_provider.dart';
import '../../../../../core/router/app_router.dart';
import 'package:fitai_mobile/core/widgets/app_scaffold.dart';

class SetupBodyStep extends ConsumerWidget {
  const SetupBodyStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // LOG
    final loc = GoRouter.of(context).routeInformationProvider.value.location;
    final stack = GoRouter.of(context)
        .routerDelegate
        .currentConfiguration
        .matches
        .map((m) => m.matchedLocation)
        .toList();
    debugPrint('[Body] build -> loc=$loc | stack=$stack');

    Future<void> pickFromLibrary() async {
      final d = ref.read(profileDraftProvider);
      d.localPhotoPath = '/tmp/mock.jpg';
      ref.read(profileDraftProvider.notifier).state = d;
      debugPrint('[Body] set localPhotoPath=/tmp/mock.jpg');
    }

    Future<void> scanByCamera() async {
      final d = ref.read(profileDraftProvider);
      d.localPhotoPath = '/tmp/camera.jpg';
      ref.read(profileDraftProvider.notifier).state = d;
      debugPrint('[Body] set localPhotoPath=/tmp/camera.jpg');
    }

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
                child: BodyUploadCard(
                  onPickFromLibrary: pickFromLibrary,
                  onScanByCamera: scanByCamera,
                  onContinue: () {
                    final before = GoRouter.of(
                      context,
                    ).routeInformationProvider.value.location;
                    debugPrint('[Body] BEFORE push -> $before');
                    context.pushNamed(AppRoute.setupDiet.name);
                    final after = GoRouter.of(
                      context,
                    ).routeInformationProvider.value.location;
                    debugPrint('[Body] AFTER  push -> $after');
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
