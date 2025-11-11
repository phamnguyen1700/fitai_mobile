// lib/features/profile_setup/presentation/views/profile_setup_screen.dart
import 'package:flutter/material.dart';

// import đúng đường dẫn widgets bạn đã tạo
import 'package:fitai_mobile/features/profile_setup/presentation/widgets/user_data.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  int _step = 0; // 0: overview, 1: body, 2: diet
  final _draft = ProfileDraft(); // dữ liệu tạm cho cả flow

  // ===== Handlers cho từng bước =====
  void _onOverviewSubmit(ProfileDraft d) {
    setState(() {
      _step = 1;
    });
  }

  Future<void> _pickFromLibrary() async {
    // TODO: tích hợp image_picker / file picker thực tế
    // final picker = ImagePicker();
    // final img = await picker.pickImage(source: ImageSource.gallery);
    // if (img != null) _draft.localPhotoPath = img.path;
    _draft.localPhotoPath = '/tmp/mock.jpg'; // demo
    if (mounted) setState(() {});
  }

  Future<void> _scanByCamera() async {
    // TODO: tích hợp camera
    // final img = await picker.pickImage(source: ImageSource.camera);
    // if (img != null) _draft.localPhotoPath = img.path;
    _draft.localPhotoPath = '/tmp/camera.jpg'; // demo
    if (mounted) setState(() {});
  }

  void _onBodyContinue() {
    setState(() {
      _step = 2;
    });
  }

  void _onDietSubmit(ProfileDraft d) async {
    // TODO: gọi API start AI job bằng _draft
    // final jobId = await ref.read(aiRepositoryProvider).startJob(_draft);
    // context.goNamed(AppRoute.aiProcessing.name, pathParameters: {'jobId': jobId});

    // Tạm thời: quay lại hoặc show snackbar
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hồ sơ đã gửi — bắt đầu AI Recommendation')),
    );
    Navigator.of(
      context,
    ).pop(); // hoặc replace đến màn processing như comment trên
  }

  // ===== UI theo step =====
  Widget _buildStep() {
    switch (_step) {
      case 0:
        return UserDataFormCard(
          initial: _draft,
          onSubmit: _onOverviewSubmit,
          activityLevels:
              const [], // Add missing required argument, replace with actual list if needed
        );

      case 1:
        return BodyUploadCard(
          onScanByCamera: _scanByCamera,
          onContinue: _onBodyContinue,
        );

      case 2:
        return DietPrefsFormCard(initial: _draft, onSubmit: _onDietSubmit);

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Màn có form → nên cuộn theo step để tránh tràn khi mở bàn phím
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thiết lập hồ sơ cá nhân'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_step == 0) {
              Navigator.of(context).maybePop();
            } else {
              setState(() => _step -= 1);
            }
          },
        ),
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, anim) =>
              FadeTransition(opacity: anim, child: child),
          child: SingleChildScrollView(
            key: ValueKey(_step), // để AnimatedSwitcher biết phần tử thay đổi
            padding: const EdgeInsets.only(bottom: 12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: _buildStep(),
            ),
          ),
        ),
      ),
    );
  }
}
