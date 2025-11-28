import 'package:fitai_mobile/core/status/bodygram_error.dart';
import 'package:fitai_mobile/core/widgets/app_bar.dart';
import 'package:fitai_mobile/features/camera/camera_level_guide_screen.dart';
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

class SetupBodyStep extends ConsumerStatefulWidget {
  const SetupBodyStep({super.key});

  @override
  ConsumerState<SetupBodyStep> createState() => _SetupBodyStepState();
}

class _SetupBodyStepState extends ConsumerState<SetupBodyStep> {
  bool _isUploading = false;
  String? _bodygramError;

  String _bodygramErrorMessage(Object error) {
    if (error is BodygramAnalyzeException) {
      return error.status.explanation;
    }
    return 'Upload ảnh cơ thể thất bại, vui lòng thử lại.';
  }

  @override
  Widget build(BuildContext context) {
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
      // Clear lỗi khi quét lại
      setState(() => _bodygramError = null);

      final result = await Navigator.of(context, rootNavigator: true)
          .push<Map<String, dynamic>?>(
            MaterialPageRoute(
              builder: (_) => const CameraLevelGuideScreen(),
              fullscreenDialog: true,
            ),
          );

      if (result == null) {
        debugPrint('[Body] Camera canceled, no result');
        return;
      }

      final frontPath = result['frontPath'] as String?;
      final sidePath = result['sidePath'] as String?;

      debugPrint('[Body] got front=$frontPath, side=$sidePath');

      final currentDraft = ref.read(profileDraftProvider);
      final updatedDraft = currentDraft.copyWith(
        frontBodyPhotoPath: frontPath,
        sideBodyPhotoPath: sidePath,
      );
      ref.read(profileDraftProvider.notifier).state = updatedDraft;

      debugPrint(
        '[Body] Updated draft - front: '
        '${updatedDraft.frontBodyPhotoPath}, side: ${updatedDraft.sideBodyPhotoPath}',
      );

      if (mounted) {
        setState(() => _bodygramError = null);
      }
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

      // Clear lỗi và bắt đầu upload
      setState(() {
        _bodygramError = null;
        _isUploading = true;
      });

      try {
        final repo = ref.read(bodygramRepositoryProvider);
        await repo.uploadFromDraft(d);

        if (!mounted) return;

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

        if (!mounted) return;

        final errorMessage = _bodygramErrorMessage(e);
        final currentDraft = ref.read(profileDraftProvider);
        final clearedDraft = currentDraft.copyWith(
          clearFrontPhoto: true,
          clearSidePhoto: true,
        );
        setState(() {
          _bodygramError = errorMessage;
          _isUploading = false;
        });
        ref.read(profileDraftProvider.notifier).state = clearedDraft;
      } finally {
        if (mounted && _isUploading) {
          setState(() => _isUploading = false);
        }
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
                  bodygramError: _bodygramError,
                  isLoading: _isUploading,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
