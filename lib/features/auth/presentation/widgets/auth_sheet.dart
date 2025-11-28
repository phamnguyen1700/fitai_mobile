import 'package:fitai_mobile/core/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitai_mobile/core/widgets/widgets.dart';
import 'package:fitai_mobile/core/router/app_router.dart';
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

class _AuthSheetContent extends ConsumerStatefulWidget {
  const _AuthSheetContent({super.key});

  @override
  ConsumerState<_AuthSheetContent> createState() => _AuthSheetContentState();
}

class _AuthSheetContentState extends ConsumerState<_AuthSheetContent>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    // indexIsChanging = true trong lúc user chuyển tab
    if (_tabController.indexIsChanging) {
      // 🔥 clear error mỗi lần đổi tab
      ref.read(authNotifierProvider.notifier).clearError();
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
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
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Đăng nhập'),
                Tab(text: 'Đăng ký'),
              ],
            ),
            const SizedBox(height: 16),
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

  /// Chuyển đổi error message từ API sang tiếng Việt
  String _translateError(String error) {
    final lowerError = error.toLowerCase();

    if (lowerError.contains('invalid email or password') ||
        lowerError.contains('invalid email') ||
        lowerError.contains('invalid password')) {
      return 'Email hoặc mật khẩu không đúng. Vui lòng kiểm tra lại.';
    }

    if (lowerError.contains('email is not verified') ||
        lowerError.contains('email chưa được xác thực')) {
      return 'Email chưa được xác thực. Vui lòng xác thực email trước khi đăng nhập.';
    }

    if (lowerError.contains('user not found')) {
      return 'Không tìm thấy tài khoản với email này.';
    }

    if (lowerError.contains('account locked') ||
        lowerError.contains('account disabled')) {
      return 'Tài khoản đã bị khóa. Vui lòng liên hệ hỗ trợ.';
    }

    // Nếu đã là tiếng Việt hoặc không match, trả về nguyên bản
    return error;
  }

  String? _loginPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    return null; // hợp lệ
  }

  @override
  void dispose() {
    _emailCtl.dispose();
    _passCtl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final email = _emailCtl.text.trim();
    final password = _passCtl.text;

    // Gọi login
    await ref
        .read(authNotifierProvider.notifier)
        .login(email: email, password: password, rememberMe: _rememberMe);

    final asyncAuth = ref.read(authNotifierProvider);
    final authState = asyncAuth.value; // AuthState? hoặc null

    if (!mounted) return;

    if (authState == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Có lỗi xảy ra. Vui lòng thử lại.')),
      );
      return;
    }

    // ❌ LOGIN FAIL
    if (!authState.isAuthenticated) {
      final rawErr =
          authState.error ??
          'Đăng nhập thất bại. Vui lòng kiểm tra email/mật khẩu.';

      // Map error message từ API sang tiếng Việt
      String err = _translateError(rawErr);

      // 🔥 CASE: Email chưa verify
      if (err.contains('Email is not verified') ||
          err.contains('chưa được xác thực')) {
        // Gửi lại OTP trước
        final resp = await ref
            .read(authNotifierProvider.notifier)
            .resendOtp(email: email);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                resp.success
                    ? 'Tài khoản chưa được xác thực. Đã gửi lại mã OTP, vui lòng kiểm tra email.'
                    : 'Tài khoản chưa được xác thực. Không gửi được mã OTP, thử lại sau.',
              ),
              backgroundColor: resp.success ? Colors.orange : Colors.red,
            ),
          );

          // Đóng bottom sheet
          Navigator.of(context).pop();

          // Điều hướng sang màn xác thực, truyền email + password
          context.goNamed(
            AppRoute.verification.name,
            extra: {'email': email, 'password': password},
          );
        }
        return;
      }

      // Các lỗi login khác: hiển thị message tiếng Việt
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // ✅ LOGIN OK – như code cũ
    final step = authState.user?.onboardingStep;

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

    Navigator.of(context).pop();
    context.go(target);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Đăng nhập thành công! Chào mừng ${authState.user?.email ?? 'bạn'}!',
        ),
        backgroundColor: Colors.green,
      ),
    );
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
            validator: _loginPasswordValidator,
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
                _translateError(errorText),
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
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_passCtl.text != _confirmCtl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu xác nhận không khớp'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ref.read(authNotifierProvider.notifier).clearError();

    final email = _emailCtl.text.trim();
    final password = _passCtl.text;

    await ref
        .read(authNotifierProvider.notifier)
        .register(
          email: email,
          password: password,
          passwordConfirmation: _confirmCtl.text,
        );

    final authAsync = ref.read(authNotifierProvider);
    final authState = authAsync.value;

    if (!mounted) return;

    if (authState?.error != null) {
      return;
    }

    Navigator.of(context).pop(); // đóng bottom sheet

    context.goNamed(
      AppRoute.verification.name,
      extra: {'email': email, 'password': password},
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đăng ký thành công! Vui lòng nhập mã OTP.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Lấy error chung từ authErrorProvider
    final rawError = ref.watch(authErrorProvider);

    // Map message BE → tiếng Việt cho user
    String? errorText;
    if (rawError != null && rawError.isNotEmpty) {
      if (rawError.contains('Email is already registered')) {
        errorText = 'Email này đã được đăng ký, vui lòng dùng email khác.';
      } else {
        errorText = rawError; // fallback: dùng nguyên message
      }
    }

    final isLoading = ref.watch(isAuthLoadingProvider);

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

          const SizedBox(height: 8),

          // 🔻 Hiển thị lỗi từ BE ngay dưới form
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                errorText,
                style: TextStyle(color: cs.error, fontSize: 13),
              ),
            ),

          const SizedBox(height: 8),

          AppButton(
            label: isLoading ? 'Đang đăng ký...' : 'Đăng ký',
            variant: AppButtonVariant.filled,
            fullWidth: true,
            onPressed: isLoading ? null : _submit,
          ),
        ],
      ),
    );
  }
}
