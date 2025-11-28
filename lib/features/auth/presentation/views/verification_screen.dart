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

class VerificationScreen extends ConsumerStatefulWidget {
  final String? email;
  final String? password;

  const VerificationScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  String _currentOtp = '';
  bool get _isOtpFilled => _currentOtp.length >= 6;

  void _goWelcome(BuildContext context) {
    context.goNamed(AppRoute.welcome.name);
  }

  Future<void> _verifyCode(BuildContext context, String code) async {
    final email = widget.email;
    final messenger = ScaffoldMessenger.of(context);

    if (email == null || email.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Thiếu email để xác thực OTP.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final ok = await ref
        .read(authNotifierProvider.notifier)
        .verifyOtp(email: email, otpCode: code);

    if (!ok) {
      final err = ref.read(authErrorProvider) ?? 'Mã OTP không hợp lệ.';
      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(err), backgroundColor: Colors.red),
        );
      }
      return;
    }

    if (widget.password == null || widget.password!.isEmpty) {
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
        .login(email: email, password: widget.password!, rememberMe: true);

    final authState = ref.read(authNotifierProvider).value;

    if (authState?.isAuthenticated == true) {
      if (context.mounted) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Xác thực & đăng nhập thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/setup/overview');
      }
    } else {
      final err = authState?.error ?? 'Đăng nhập sau khi xác thực thất bại.';
      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(err), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                                  onCompleted: (code) async {
                                    FocusScope.of(context).unfocus();
                                    await _verifyCode(context, code);
                                  },
                                  onResend: () async {
                                    final messenger = ScaffoldMessenger.of(
                                      context,
                                    );

                                    if (widget.email == null ||
                                        widget.email!.isEmpty) {
                                      messenger.showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Không thể gửi lại OTP vì thiếu email.',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    final resp = await ref
                                        .read(authNotifierProvider.notifier)
                                        .resendOtp(email: widget.email!);

                                    if (!context.mounted) return;

                                    messenger.showSnackBar(
                                      SnackBar(
                                        content: Text(resp.message),
                                        backgroundColor: resp.success
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    );
                                  },
                                  onCodeChanged: (code) {
                                    setState(() => _currentOtp = code);
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
                                            : () async {
                                                if (!_isOtpFilled) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Vui lòng nhập đủ 6 số trước khi xác nhận.',
                                                      ),
                                                    ),
                                                  );
                                                  return;
                                                }
                                                FocusScope.of(
                                                  context,
                                                ).unfocus();
                                                await _verifyCode(
                                                  context,
                                                  _currentOtp,
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
