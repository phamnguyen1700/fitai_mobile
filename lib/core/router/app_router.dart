// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Shell UI
import '../widgets/app_scaffold.dart';

// Screens
import 'package:fitai_mobile/features/auth/presentation/views/splash_screen.dart';
import 'package:fitai_mobile/features/auth/presentation/views/welcome_screen.dart';
import 'package:fitai_mobile/features/ai/presentation/views/chat.dart';
import 'package:fitai_mobile/features/daily/presentation/views/daily.dart';
import 'package:fitai_mobile/features/payment/presentation/views/payment.dart';
import 'package:fitai_mobile/features/process/presentation/views/process.dart';
import 'package:fitai_mobile/features/profile/presentation/views/profile.dart';
import 'package:fitai_mobile/features/setting/presentation/views/setting.dart';

enum AppRoute { splash, welcome }

/// demo: trạng thái đăng nhập – thay bằng auth provider thật của bạn
final isLoggedInProvider = StateProvider<bool>((_) => false);

final _rootKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  // Khi auth thay đổi, router sẽ refresh
  ref.listen<bool>(isLoggedInProvider, (_, __) {});

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/',

    routes: [
      // ====== Splash / Welcome (ngoài shell) ======
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

      // ====== Payment flow (ngoài bottom nav) ======
      GoRoute(
        path: '/payment',
        pageBuilder: (ctx, st) => _fade(
          const AppScaffold(
            title: 'Thanh toán',
            body: PaymentScreen(),
            // Vẫn để showBottomArea=true: AppBottomNav sẽ tự hiện footer điều khoản
            showBottomArea: true,
          ),
        ),
        routes: [
          GoRoute(
            path: 'process',
            pageBuilder: (ctx, st) => _fade(
              const AppScaffold(
                title: 'Thanh toán',
                body: ProcessScreen(),
                showBottomArea: true,
              ),
            ),
          ),
        ],
      ),

      // ====== SHELL 5 TAB (giữ state từng tab) ======
      // Sử dụng các đường dẫn đã trùng với AppBottomNav:
      // /home, /workout, /meal, /progress, /profile
      StatefulShellRoute.indexedStack(
        branches: [
          _tabBranch(
            path: '/home',
            title: 'Trang chủ',
            builder: (ctx, st) => const DailyScreen(),
          ),
          _tabBranch(
            path: '/workout',
            title: 'AI Coach',
            builder: (ctx, st) => const ChatScreen(),
          ),
          _tabBranch(
            path: '/meal',
            title: 'Cài đặt',
            builder: (ctx, st) => const SettingScreen(),
          ),
          _tabBranch(
            path: '/progress',
            title: 'Tiến độ',
            builder: (ctx, st) => const ProcessScreen(),
          ),
          _tabBranch(
            path: '/profile',
            title: 'Hồ sơ',
            builder: (ctx, st) => const ProfileScreen(),
          ),
        ],
        // builder không cần Scaffold vì mỗi branch đã dùng AppScaffold
        builder: (ctx, state, navShell) => navShell,
      ),
    ],

    // Redirect (ví dụ)
    redirect: (context, state) {
      final onSplash = state.matchedLocation == '/';
      if (onSplash) return null; // để splash tự điều hướng
      // final loggedIn = ref.read(isLoggedInProvider);
      // if (!loggedIn && state.matchedLocation.startsWith('/profile')) return '/welcome';
      return null;
    },

    errorPageBuilder: (context, state) => _fade(
      Scaffold(body: Center(child: Text('Route error: ${state.error}'))),
    ),
  );
});

// Helper: tạo branch tab sử dụng AppScaffold (AppBar + BottomNav)
StatefulShellBranch _tabBranch({
  required String path,
  required String title,
  required Widget Function(BuildContext, GoRouterState) builder,
}) {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: path,
        pageBuilder: (ctx, st) => _fade(
          AppScaffold(
            title: title,
            body: builder(ctx, st),
            showBottomArea: true, // hiển thị BottomNav ở các tab chính
          ),
        ),
        // Có thể thêm child routes cho từng tab tại đây
      ),
    ],
  );
}

/// Transition mặc định (fade)
CustomTransitionPage _fade(Widget child) => CustomTransitionPage(
  child: child,
  transitionsBuilder: (context, animation, secondaryAnimation, child) =>
      FadeTransition(opacity: animation, child: child),
);
