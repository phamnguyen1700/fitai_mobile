import 'package:fitai_mobile/core/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitai_mobile/core/widgets/app_scaffold.dart';
import 'package:fitai_mobile/core/widgets/app_card.dart';
import 'package:fitai_mobile/core/widgets/app_button.dart';
import 'package:go_router/go_router.dart';
import 'package:fitai_mobile/core/router/app_router.dart';
import 'package:fitai_mobile/features/auth/presentation/widgets/otp.dart';
import 'package:fitai_mobile/features/auth/presentation/viewmodels/auth_providers.dart';

class VerificationScreen extends ConsumerWidget {
  final String? email;
  final String? password; // 👈 password vừa đăng ký

  const VerificationScreen({
    super.key,
    required this.email,
    required this.password,
  });

  void _goWelcome(BuildContext context) {
    context.goNamed(AppRoute.welcome.name);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isAuthLoadingProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _goWelcome(context);
        }
      },
      child: AppScaffold(
        appBar: AppAppBar(title: 'Xác thực tài khoản'),
        showBottomArea: false,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Center(
                          child: AppCard(
                            color: Theme.of(context).colorScheme.surface,
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Otp(
                                  // ✅ Nhập đủ số → verify + auto login
                                  onCompleted: (code) async {
                                    FocusScope.of(context).unfocus();
                                    final messenger = ScaffoldMessenger.of(
                                      context,
                                    );

                                    if (email == null || email!.isEmpty) {
                                      messenger.showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Thiếu email để xác thực OTP.',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    // 1. Gọi verify OTP
                                    final ok = await ref
                                        .read(authNotifierProvider.notifier)
                                        .verifyOtp(
                                          email: email!,
                                          otpCode: code,
                                        );

                                    if (!ok) {
                                      final err =
                                          ref.read(authErrorProvider) ??
                                          'Mã OTP không hợp lệ.';
                                      if (context.mounted) {
                                        messenger.showSnackBar(
                                          SnackBar(
                                            content: Text(err),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                      return;
                                    }

                                    // 2. Verify OTP OK ⇒ auto login nếu có password
                                    if (password == null || password!.isEmpty) {
                                      // fallback: đã verify nhưng không có pass để login
                                      if (context.mounted) {
                                        messenger.showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Tài khoản đã được kích hoạt. Vui lòng đăng nhập lại.',
                                            ),
                                          ),
                                        );
                                        context.goNamed(AppRoute.welcome.name);
                                      }
                                      return;
                                    }

                                    await ref
                                        .read(authNotifierProvider.notifier)
                                        .login(
                                          email: email!,
                                          password: password!,
                                          rememberMe: true,
                                        );

                                    final authState = ref
                                        .read(authNotifierProvider)
                                        .value;

                                    if (authState?.isAuthenticated == true) {
                                      if (context.mounted) {
                                        messenger.showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Xác thực & đăng nhập thành công!',
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        // ✅ Auto đi tới /home
                                        context.go('/home');
                                      }
                                    } else {
                                      final err =
                                          authState?.error ??
                                          'Đăng nhập sau khi xác thực thất bại.';
                                      if (context.mounted) {
                                        messenger.showSnackBar(
                                          SnackBar(
                                            content: Text(err),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  onResend: () {
                                    // TODO: sau này gọi API resend OTP ở đây
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Đã gửi lại mã xác thực'),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppButton(
                                        label: 'Hủy',
                                        variant: AppButtonVariant.outlined,
                                        onPressed: () => _goWelcome(context),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: AppButton(
                                        label: isLoading
                                            ? 'Đang xử lý...'
                                            : 'Xác nhận',
                                        variant: AppButtonVariant.filled,
                                        onPressed: isLoading
                                            ? null
                                            : () {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Mã OTP sẽ được xác thực tự động khi bạn nhập đủ số.',
                                                    ),
                                                  ),
                                                );
                                              },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        showLegalFooter: true,
      ),
    );
  }
}
