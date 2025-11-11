import 'package:fitai_mobile/core/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/user_data.dart';
import '../../widgets/setup_container.dart';
import '../../viewmodels/profile_draft_provider.dart';
import '../../../../../core/router/app_router.dart';
import 'package:fitai_mobile/core/widgets/app_scaffold.dart';
import 'package:fitai_mobile/features/camera/body_cam_screen.dart';
import 'package:fitai_mobile/features/profile_setup/presentation/viewmodels/bodygram_providers.dart';

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

    final draft = ref.watch(profileDraftProvider);

    Future<void> openScanBody() async {
      final result = await Navigator.of(context).push<Map<String, String>>(
        MaterialPageRoute(builder: (_) => const BodyCameraScreen()),
      );

      if (result == null) {
        debugPrint('[Body] Camera canceled, no result');
        return;
      }

      final frontPath = result['frontPath'];
      final sidePath = result['sidePath'];

      debugPrint('[Body] got front=$frontPath, side=$sidePath');

      // 🔹 cập nhật vào ProfileDraft trong provider
      final d = ref.read(profileDraftProvider);
      d.frontBodyPhotoPath = frontPath;
      d.sideBodyPhotoPath = sidePath;
      ref.read(profileDraftProvider.notifier).state = d;
    }

    Future<void> onContinue() async {
      final d = ref.read(profileDraftProvider);

      if (d.frontBodyPhotoPath == null || d.sideBodyPhotoPath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Bạn cần có đủ 2 ảnh (chính diện và bên hông) trước khi tiếp tục.',
            ),
          ),
        );
        return;
      }

      try {
        final repo = ref.read(bodygramRepositoryProvider);
        await repo.uploadFromDraft(d);

        final before = GoRouter.of(
          context,
        ).routeInformationProvider.value.location;
        debugPrint('[Body] BEFORE push -> $before');

        context.pushNamed(AppRoute.setupDiet.name);

        final after = GoRouter.of(
          context,
        ).routeInformationProvider.value.location;
        debugPrint('[Body] AFTER  push -> $after');
      } catch (e, st) {
        debugPrint('[Body] upload body images error: $e\n$st');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Upload ảnh cơ thể thất bại, vui lòng thử lại.'),
          ),
        );
      }
    }

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
                child: BodyUploadCard(
                  onScanByCamera: openScanBody,
                  onContinue: onContinue,
                  frontImagePath: draft.frontBodyPhotoPath,
                  sideImagePath: draft.sideBodyPhotoPath,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
