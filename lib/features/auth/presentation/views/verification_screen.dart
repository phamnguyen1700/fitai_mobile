import 'package:fitai_mobile/core/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitai_mobile/core/widgets/app_scaffold.dart';
import 'package:fitai_mobile/core/widgets/app_card.dart';
import 'package:fitai_mobile/core/widgets/app_button.dart';
import 'package:go_router/go_router.dart';
import 'package:fitai_mobile/core/router/app_router.dart';
import 'package:fitai_mobile/features/auth/presentation/widgets/otp.dart'; // class Otp
import 'package:fitai_mobile/features/auth/presentation/viewmodels/auth_providers.dart';

class VerificationScreen extends ConsumerWidget {
  final String? email;
  const VerificationScreen({super.key, this.email});

  void _goWelcome(BuildContext context) {
    context.goNamed(AppRoute.welcome.name);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              // Nội dung giữa màn hình + vẫn scroll được khi thiếu chỗ
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        // ✅ ép chiều cao tối thiểu bằng viewport để Center hoạt động
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Center(
                          child: AppCard(
                            color: Theme.of(context).colorScheme.surface,
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Otp(
                                  onCompleted: (code) async {
                                    if (email == null || email!.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Thiếu email để xác thực OTP.',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }
                                    await ref
                                        .read(authNotifierProvider.notifier)
                                        .verifyOtp(
                                          email: email!,
                                          otpCode: code,
                                        );
                                    final authState = ref
                                        .read(authNotifierProvider)
                                        .value;
                                    if (authState?.isAuthenticated == true) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Xác thực OTP thành công',
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        // Điều hướng sau khi xác thực thành công
                                        context.goNamed(AppRoute.welcome.name);
                                      }
                                    } else if (authState?.error != null) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Lỗi: ${authState!.error}',
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  onResend: () {
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
                                        label: 'Xác nhận',
                                        variant: AppButtonVariant.filled,
                                        onPressed: () {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text('Xác nhận OTP'),
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
