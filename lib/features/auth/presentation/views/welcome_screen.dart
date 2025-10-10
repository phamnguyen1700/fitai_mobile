import 'package:fitai_mobile/features/auth/presentation/widgets/auth_sheet.dart';
import 'package:flutter/material.dart';
import 'package:fitai_mobile/core/widgets/widgets.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _onGetStarted(BuildContext context) {
    showAppSnack(context, 'Bắt đầu ngay', AppSnackType.info);
  }

  void _onLogin(BuildContext context) {
    AuthBottomSheet.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // BG gradient nhẹ
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [cs.surface, cs.surface.withValues(alpha: 0.92)],
              ),
            ),
          ),

          // Sticker góc trên phải (tràn ra ngoài — y hệt Splash)
          Positioned(
            top: 70,
            right: -10,
            child: Transform.rotate(
              angle: -0.05,
              child: Image.asset(
                'lib/core/assets/images/sticker1.png',
                width: 250,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Sticker góc dưới trái (tràn ra ngoài — y hệt Splash)
          Positioned(
            bottom: -40,
            left: -10,
            child: Image.asset(
              'lib/core/assets/images/sticker2.png',
              width: 350,
              fit: BoxFit.cover,
            ),
          ),

          // Nội dung chính trong SafeArea (logo + nút)
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo chính
                    Image.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? 'lib/core/assets/images/logo_dark.png'
                          : 'lib/core/assets/images/logo.png',
                      width: 200,
                      fit: BoxFit.contain,
                    ),
                    // Nút CTA chính
                    AppButton(
                      label: 'Tìm hiểu thêm',
                      variant: AppButtonVariant.filled,
                      shape: AppButtonShape.square,
                      size: AppButtonSize.sm,
                      fullWidth: true,
                      onPressed: () => _onGetStarted(context),
                    ),
                    // Nút Đăng nhập
                    AppButton(
                      label: 'Đăng nhập',
                      variant: AppButtonVariant.outlined,
                      shape: AppButtonShape.square,
                      size: AppButtonSize.sm,
                      fullWidth: true,
                      onPressed: () => _onLogin(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
