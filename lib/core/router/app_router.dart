// lib/core/router/app_router.dart
import 'package:fitai_mobile/core/widgets/app_bottom_nav.dart';
import 'package:fitai_mobile/features/home/presentation/viewmodels/home_state.dart';
import 'package:fitai_mobile/features/auth/presentation/views/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_scaffold.dart';

// Screens
import 'package:fitai_mobile/features/auth/presentation/views/splash_screen.dart';
import 'package:fitai_mobile/features/auth/presentation/views/welcome_screen.dart';
import 'package:fitai_mobile/features/home/presentation/views/chat.dart';
import 'package:fitai_mobile/features/ai/presentation/views/daily.dart';
import 'package:fitai_mobile/features/payment/presentation/views/payment.dart';
import 'package:fitai_mobile/features/process/presentation/views/process.dart';
import 'package:fitai_mobile/features/profile_setup/presentation/views/profile_setup_screen.dart';
import 'package:fitai_mobile/features/setting/presentation/views/setting.dart';
import 'package:fitai_mobile/features/profile_setup/presentation/views/steps/overview_step.dart';
import 'package:fitai_mobile/features/profile_setup/presentation/views/steps/body_step.dart';
import 'package:fitai_mobile/features/profile_setup/presentation/views/steps/diet_step.dart';
import 'package:fitai_mobile/features/payment/presentation/views/checkout.dart';
import 'package:fitai_mobile/features/payment/presentation/views/result.dart';

enum AppRoute {
  splash,
  welcome,
  verification,
  setupOverview,
  setupBody,
  setupDiet,
  planPreview,
}

/// Debug observer (giữ nếu bạn muốn xem log)
class RouteLogger extends NavigatorObserver {
  void _p(String s) => debugPrint('[RouteLogger] $s');
  @override
  void didPush(Route r, Route? p) =>
      _p('didPush -> ${r.settings.name ?? r} from ${p?.settings.name ?? p}');
  @override
  void didPop(Route r, Route? p) =>
      _p('didPop  -> ${r.settings.name ?? r} to ${p?.settings.name ?? p}');
  @override
  void didReplace({Route? newRoute, Route? oldRoute}) => _p(
    'didReplace old=${oldRoute?.settings.name ?? oldRoute} new=${newRoute?.settings.name ?? newRoute}',
  );
  @override
  void didRemove(Route r, Route? p) =>
      _p('didRemove -> ${r.settings.name ?? r}');
}

final isLoggedInProvider = StateProvider<bool>((_) => false);
final _rootKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  ref.listen<bool>(isLoggedInProvider, (_, __) {});
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    observers: [RouteLogger()],

    routes: [
      // ===== Splash / Welcome =====
      GoRoute(
        path: '/',
        name: AppRoute.splash.name,
        pageBuilder: (c, s) => _fade(s, const SplashScreen()),
      ),
      GoRoute(
        path: '/welcome',
        name: AppRoute.welcome.name,
        pageBuilder: (c, s) => _fade(s, const WelcomeScreen()),
      ),
      GoRoute(
        path: '/verification',
        name: AppRoute.verification.name,
        pageBuilder: (c, s) => _fade(s, const VerificationScreen()),
      ),

      // ===== Setup flow (PHẲNG HÓA) =====
      // gõ /setup -> tự nhảy /setup/overview
      GoRoute(
        path: '/setup',
        parentNavigatorKey: _rootKey,
        redirect: (_, __) => '/setup/overview',
      ),
      GoRoute(
        path: '/setup/overview',
        name: AppRoute.setupOverview.name,
        parentNavigatorKey: _rootKey,
        pageBuilder: (c, s) => _fade(s, const SetupOverviewStep()),
      ),
      GoRoute(
        path: '/setup/body',
        name: AppRoute.setupBody.name,
        parentNavigatorKey: _rootKey,
        pageBuilder: (c, s) => _fade(s, const SetupBodyStep()),
      ),
      GoRoute(
        path: '/setup/diet',
        name: AppRoute.setupDiet.name,
        parentNavigatorKey: _rootKey,
        pageBuilder: (c, s) => _fade(s, const SetupDietStep()),
      ),

      // ===== Payment (ngoài shell) =====
      GoRoute(
        path: '/payment',
        parentNavigatorKey: _rootKey,
        pageBuilder: (c, s) => _fade(
          s,
          const PaymentScreen(), // màn chọn gói
        ),
        routes: [
          GoRoute(
            path: 'checkout',
            parentNavigatorKey: _rootKey,
            pageBuilder: (c, s) => _fade(
              s,
              CheckoutScreen(), // màn checkout
            ),
          ),
          GoRoute(
            path: 'processing',
            parentNavigatorKey: _rootKey,
            pageBuilder: (c, s) => _fade(
              s,
              ProcessScreen(), // bạn đã có
            ),
          ),
          GoRoute(
            path: 'result/:status',
            parentNavigatorKey: _rootKey,
            pageBuilder: (c, s) {
              final ok = s.pathParameters['status'] == 'success';
              return _fade(s, PaymentResultScreen(success: ok));
            },
          ),
        ],
      ),

      // ===== SHELL 5 TAB =====
      StatefulShellRoute.indexedStack(
        branches: [
          _tabBranch(
            path: '/home',
            title: 'AI Coach',
            wrapScaffold: false, // <— quan trọng
            builder: (ctx, st) => Consumer(
              builder: (context, ref, _) {
                final view = ref.watch(homeViewProvider);
                return AppScaffold(
                  // <-- Chỉ Scaffold này cho /home
                  title: 'AI Coach',
                  showBack: view == HomeView.plan,
                  showBottomArea: false,
                  body: PopScope(
                    canPop: view != HomeView.plan,
                    onPopInvokedWithResult: (didPop, result) {
                      if (!didPop && view == HomeView.plan) {
                        ref.read(homeViewProvider.notifier).state =
                            HomeView.chat;
                      }
                    },
                    child: const HomeHostScreen(),
                  ),
                );
              },
            ),
          ),
          _tabBranch(
            path: '/workout',
            title: 'AI Coach',
            builder: (c, s) => const DailyScreen(),
          ),
          _tabBranch(
            path: '/meal',
            title: 'Cài đặt',
            builder: (c, s) => const SettingScreen(),
          ),
          _tabBranch(
            path: '/progress',
            title: 'Tiến độ',
            builder: (c, s) => const ProcessScreen(),
          ),
          _tabBranch(
            path: '/profile',
            title: 'Hồ sơ',
            builder: (c, s) => const ProfileSetupScreen(),
          ),
        ],
        builder: (ctx, state, navShell) =>
            Scaffold(body: navShell, bottomNavigationBar: AppBottomNav()),
      ),
    ],

    errorPageBuilder: (c, s) => _fade(
      s,
      Scaffold(body: Center(child: Text('Route error: ${s.error}'))),
    ),
  );
});

// 3) Sửa _tabBranch: thêm flag wrapScaffold (mặc định true)
StatefulShellBranch _tabBranch({
  required String path,
  required String title,
  required Widget Function(BuildContext, GoRouterState) builder,
  bool wrapScaffold = true, // <—
}) {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: path,
        pageBuilder: (ctx, st) {
          final child = builder(ctx, st);
          return _fade(
            st,
            wrapScaffold
                ? AppScaffold(
                    // các tab thường vẫn được bọc
                    title: title,
                    showBack: false,
                    body: child,
                    showBottomArea: false,
                  )
                : child, // /home: không bọc nữa
          );
        },
      ),
    ],
  );
}

CustomTransitionPage _fade(GoRouterState state, Widget child) =>
    CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondary, child) =>
          FadeTransition(opacity: animation, child: child),
    );
