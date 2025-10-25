import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitai_mobile/core/router/app_router.dart';
import '../providers/auth_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a small delay for better UX, then check auth state
    Future.delayed(const Duration(milliseconds: 1500), () {
      _checkAuthAndNavigate();
    });
  }

  void _checkAuthAndNavigate() {
    final authState = ref.read(authNotifierProvider);
    
    authState.when(
      loading: () {
        // If still loading, wait a bit more and check again
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _checkAuthAndNavigate();
        });
      },
      error: (_, __) {
        // On error, go to welcome
        if (mounted) context.goNamed(AppRoute.welcome.name);
      },
      data: (data) {
        if (mounted) {
          if (data.isAuthenticated) {
            context.goNamed(AppRoute.home.name);
          } else {
            context.goNamed(AppRoute.welcome.name);
          }
        }
      },
    );
  }

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? 'lib/core/assets/images/logo_dark.png'
                        : 'lib/core/assets/images/logo.png',
                    // đây là hình logo chính (hình người nâng tạ)
                    width: 280, // bạn có thể tinh chỉnh để khớp tỉ lệ figma
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 32),
                  // Loading indicator
                  Consumer(
                    builder: (context, ref, child) {
                      final authState = ref.watch(authNotifierProvider);
                      return authState.when(
                        loading: () => CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            cs.primary,
                          ),
                        ),
                        error: (_, __) => const SizedBox.shrink(),
                        data: (_) => const SizedBox.shrink(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
