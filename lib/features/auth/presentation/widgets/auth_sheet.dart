import 'package:fitai_mobile/core/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitai_mobile/core/widgets/widgets.dart';

import 'package:fitai_mobile/features/auth/presentation/viewmodels/auth_providers.dart';

class AuthBottomSheet {
  static void show(BuildContext context) {
    AppBottomSheet.show(
      context,
      maxWidth: 480,
      builder: (ctx) => const _AuthSheetContent(),
    );
  }
}

class _AuthSheetContent extends StatefulWidget {
  const _AuthSheetContent();

  @override
  State<_AuthSheetContent> createState() => _AuthSheetContentState();
}

class _AuthSheetContentState extends State<_AuthSheetContent>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 2,
    vsync: this,
  );

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tabs: Đăng nhập / Đăng ký
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Đăng nhập'),
                Tab(text: 'Đăng ký'),
              ],
            ),
            const SizedBox(height: 16),

            // Nội dung form
            SizedBox(
              height: 360,
              child: TabBarView(
                controller: _tabController,
                children: const [_LoginForm(), _RegisterForm()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// === FORM ĐĂNG NHẬP ===
class _LoginForm extends ConsumerStatefulWidget {
  const _LoginForm();

  @override
  ConsumerState<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailCtl.dispose();
    _passCtl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Gọi login qua notifier
      await ref
          .read(authNotifierProvider.notifier)
          .login(
            email: _emailCtl.text.trim(),
            password: _passCtl.text,
            rememberMe: _rememberMe,
          );

      // Lấy state sau khi login
      final authState = ref.read(authNotifierProvider).value;

      if (authState?.isAuthenticated == true) {
        if (!mounted) return;

        // 👇 Lấy bước onboarding từ user
        final step = authState!.user?.onboardingStep;

        String target;

        switch (step) {
          case null:
          case 'None':
          case 'Profile':
            target = '/setup/overview';
            break;

          case 'BodyImage':
            target = '/setup/body';
            break;

          case 'DietaryPreference':
            target = '/setup/diet';
            break;

          default:
            target = '/home';
            break;
        }

        // Đóng bottom sheet nếu đang mở
        Navigator.of(context).pop();

        // Điều hướng đến màn tương ứng
        context.go(target);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Chào mừng bạn quay lại 👋')));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Đăng nhập thành công! Chào mừng ${authState.user?.email ?? 'bạn'}!',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final errorText = ref.watch(authErrorProvider);

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Đăng nhập',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 16),

          // Email
          AppTextField(
            controller: _emailCtl,
            label: 'Email',
            prefixIcon: Icons.email_outlined,
            hintText: 'Nhập email',
            validator: V.email(),
          ),
          const SizedBox(height: 12),

          // Mật khẩu
          AppTextField(
            controller: _passCtl,
            label: 'Mật khẩu',
            prefixIcon: Icons.lock_outline,
            hintText: 'Nhập mật khẩu',
            obscure: true,
            validator: V.password(),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) =>
                        setState(() => _rememberMe = value ?? false),
                  ),
                  Text(
                    'Ghi nhớ đăng nhập',
                    style: TextStyle(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
              TextButton(onPressed: () {}, child: const Text('Quên mật khẩu')),
            ],
          ),

          const SizedBox(height: 8),

          if (errorText != null && errorText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                errorText,
                style: TextStyle(color: cs.error, fontSize: 13),
              ),
            ),

          const SizedBox(height: 8),

          Consumer(
            builder: (context, ref, child) {
              final isLoading = ref.watch(isAuthLoadingProvider);

              return AppButton(
                label: isLoading ? 'Đang đăng nhập...' : 'Đăng nhập',
                variant: AppButtonVariant.filled,
                fullWidth: true,
                onPressed: isLoading ? null : _submit,
              );
            },
          ),
        ],
      ),
    );
  }
}

// === FORM ĐĂNG KÝ ===
class _RegisterForm extends ConsumerStatefulWidget {
  const _RegisterForm();

  @override
  ConsumerState<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<_RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  final _confirmCtl = TextEditingController();

  @override
  void dispose() {
    _emailCtl.dispose();
    _passCtl.dispose();
    _confirmCtl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Validate password confirmation
      if (_passCtl.text != _confirmCtl.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mật khẩu xác nhận không khớp'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Call API through provider
      await ref
          .read(authNotifierProvider.notifier)
          .register(
            email: _emailCtl.text.trim(),
            password: _passCtl.text,
            passwordConfirmation: _confirmCtl.text,
          );

      // Check if registration was successful -> go to OTP (verification)
      final authState = ref.read(authNotifierProvider).value;
      if (authState?.error == null) {
        if (mounted) {
          Navigator.of(context).pop(); // Close the bottom sheet
          context.go(
            '/verification',
            extra: _emailCtl.text.trim(),
          ); // Navigate to OTP screen with email
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đăng ký thành công! Vui lòng nhập mã OTP.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đăng ký thất bại: ${authState!.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Đăng ký',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 16),

          AppTextField(
            controller: _emailCtl,
            label: 'Email',
            prefixIcon: Icons.email_outlined,
            hintText: 'Nhập email',
            validator: V.email(),
          ),
          const SizedBox(height: 12),

          AppTextField(
            controller: _passCtl,
            label: 'Mật khẩu',
            prefixIcon: Icons.lock_outline,
            hintText: 'Nhập mật khẩu',
            obscure: true,
            validator: V.password(),
          ),
          Text(
            '6 ký tự trở lên bao gồm chữ cái, số và ký tự đặc biệt.',
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 12),

          AppTextField(
            controller: _confirmCtl,
            label: 'Nhập lại mật khẩu',
            prefixIcon: Icons.lock_outline,
            hintText: 'Nhập lại mật khẩu',
            obscure: true,
            validator: V.confirm(_passCtl),
          ),
          const SizedBox(height: 16),

          Consumer(
            builder: (context, ref, child) {
              final isLoading = ref.watch(isAuthLoadingProvider);

              return AppButton(
                label: isLoading ? 'Đang đăng ký...' : 'Đăng ký',
                variant: AppButtonVariant.filled,
                fullWidth: true,
                onPressed: isLoading ? null : _submit,
              );
            },
          ),
        ],
      ),
    );
  }
}
