import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitai_mobile/core/router/app_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _goToWelcome(BuildContext context) {
    context.goNamed(AppRoute.welcome.name);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _goToWelcome(context),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // BG gradient nhẹ
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [cs.surface, cs.surface.withValues(alpha: .92)],
                ),
              ),
            ),

            // Sticker góc trên phải (tràn khỏi khung)
            Positioned(
              top: 90, // đẩy ra khỏi khung để chỉ thấy 1 phần
              right: -10,
              child: Transform.rotate(
                angle: -0.05, // xoay nhẹ cho tự nhiên (tuỳ chọn)
                child: Image.asset(
                  'lib/core/assets/images/sticker1.png',
                  width: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Sticker góc dưới trái (tràn khỏi khung)
            Positioned(
              bottom: 0,
              left: -10,
              child: Image.asset(
                'lib/core/assets/images/sticker2.png',
                width: 350,
                fit: BoxFit.cover,
              ),
            ),

            Center(
              child: Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? 'lib/core/assets/images/logo_dark.png'
                    : 'lib/core/assets/images/logo.png',
                // đây là hình logo chính (hình người nâng tạ)
                width: 280, // bạn có thể tinh chỉnh để khớp tỉ lệ figma
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
