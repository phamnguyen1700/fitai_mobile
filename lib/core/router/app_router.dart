import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Screens
import 'package:fitai_mobile/features/auth/presentation/views/splash_screen.dart';
import 'package:fitai_mobile/features/auth/presentation/views/welcome_screen.dart';
// import các màn khác khi có: login, signup, home,...

enum AppRoute { splash, welcome /*, login, signup, home*/ }

/// (Ví dụ) trạng thái đăng nhập – thay bằng auth provider thật của bạn
final isLoggedInProvider = StateProvider<bool>((_) => false);

/// GoRouter provider – để dùng được Riverpod trong redirect/refresh
final goRouterProvider = Provider<GoRouter>((ref) {
  // Khi auth thay đổi, router sẽ refresh
  ref.listen<bool>(isLoggedInProvider, (_, __) {});

  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.splash.name,
        pageBuilder: (context, state) => _fade(const SplashScreen()),
      ),
      GoRoute(
        path: '/welcome',
        name: AppRoute.welcome.name,
        pageBuilder: (context, state) => _fade(const WelcomeScreen()),
      ),
      // Thêm route khác:
      // GoRoute(path: '/login', name: AppRoute.login.name, pageBuilder: ...),
      // GoRoute(path: '/home', name: AppRoute.home.name, pageBuilder: ...),
    ],

    // (Tùy chọn) redirect toàn cục – ví dụ nếu đã login thì bỏ qua welcome
    redirect: (context, state) {
      final loggedIn = ref.read(isLoggedInProvider);
      final onSplash = state.matchedLocation == '/';
      if (onSplash) return null; // để splash tự quyết định

      // ví dụ: nếu đã login mà đang ở /welcome thì chuyển về /home
      // if (loggedIn && state.matchedLocation == '/welcome') return '/home';
      return null;
    },

    errorPageBuilder: (context, state) => _fade(
      Scaffold(body: Center(child: Text('Route error: ${state.error}'))),
    ),
  );
});

/// Transition mặc định (fade)
CustomTransitionPage _fade(Widget child) => CustomTransitionPage(
  child: child,
  transitionsBuilder: (context, animation, secondaryAnimation, child) =>
      FadeTransition(opacity: animation, child: child),
);
