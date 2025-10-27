import 'package:fitai_mobile/core/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fitai_mobile/core/widgets/app_scaffold.dart';
import 'package:fitai_mobile/core/widgets/app_card.dart';
import 'package:fitai_mobile/core/widgets/app_button.dart';
import 'package:fitai_mobile/features/auth/presentation/views/welcome_screen.dart';
import 'package:fitai_mobile/features/auth/presentation/widgets/otp.dart'; // class Otp

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  void _goWelcome(BuildContext context) {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const WelcomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
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
                                  onCompleted: (code) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Code: $code')),
                                    );
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
