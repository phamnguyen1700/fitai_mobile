import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_scaffold.dart';
import '../widgets/app_bar.dart';
import '../widgets/user_header_appbar.dart';
import '../widgets/app_bottom_nav.dart';
import '_header_builder.dart';

// ===== Screens =====
import 'package:fitai_mobile/features/auth/presentation/views/splash_screen.dart';
import 'package:fitai_mobile/features/auth/presentation/views/welcome_screen.dart';
import 'package:fitai_mobile/features/auth/presentation/views/verification_screen.dart';
import 'package:fitai_mobile/features/profile_setup/presentation/views/steps/overview_step.dart';
import 'package:fitai_mobile/features/profile_setup/presentation/views/steps/body_step.dart';
import 'package:fitai_mobile/features/profile_setup/presentation/views/steps/diet_step.dart';
import 'package:fitai_mobile/features/payment/presentation/views/subscriptions_screen.dart';
import 'package:fitai_mobile/features/payment/presentation/views/checkout_screen.dart';
import 'package:fitai_mobile/features/payment/presentation/views/result_screen.dart';
import 'package:fitai_mobile/features/process/presentation/views/process_screen.dart';
import 'package:fitai_mobile/features/daily/presentation/views/daily_screen.dart';
import 'package:fitai_mobile/features/setting/presentation/views/setting.dart';
import 'package:fitai_mobile/features/home/presentation/views/chat_screen.dart';
import 'package:fitai_mobile/features/home/presentation/viewmodels/home_state.dart';

enum AppRoute {
  splash,
  welcome,
  verification,
  setupOverview,
  setupBody,
  setupDiet,
  planDemo,
}

/// Debug logger
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
        pageBuilder: (c, s) {
          String? email;
          String? password;

          final extra = s.extra;

          if (extra is Map) {
            // kỳ vọng: { 'email': String, 'password': String }
            email = extra['email'] as String?;
            password = extra['password'] as String?;
          } else if (extra is String) {
            // fallback cũ: chỉ có email
            email = extra;
          }

          return _fade(s, VerificationScreen(email: email, password: password));
        },
      ),

      // ===== Setup flow =====
      GoRoute(path: '/setup', redirect: (_, __) => '/setup/overview'),
      GoRoute(
        path: '/setup/overview',
        name: AppRoute.setupOverview.name,
        pageBuilder: (c, s) => _fade(s, const SetupOverviewStep()),
      ),
      GoRoute(
        path: '/setup/body',
        name: AppRoute.setupBody.name,
        pageBuilder: (c, s) => _fade(s, const SetupBodyStep()),
      ),
      GoRoute(
        path: '/setup/diet',
        name: AppRoute.setupDiet.name,
        pageBuilder: (c, s) => _fade(s, const SetupDietStep()),
      ),

      // ===== Payment flow =====
      //
      // Lưu ý: deep link từ Stripe đang có dạng:
      //   fitaiplanning://payment/result/success
      // Flutter Router sẽ parse route mặc định thành `/result/success`
      // (bỏ phần `payment` vì đó là host), nên ta cần 1 route
      // `/result/:status` để tránh lỗi "no routes for location: /result/success".
      // Route này chỉ việc redirect sang route chuẩn `/payment/result/:status`.
      GoRoute(
        path: '/result/:status',
        redirect: (context, state) {
          final status = state.pathParameters['status'];
          if (status == null) return '/';
          return '/payment/result/$status';
        },
      ),

      GoRoute(
        path: '/payment',
        pageBuilder: (c, s) => _fade(s, const SubscriptionsScreen()),
        routes: [
          GoRoute(
            path: 'checkout',
            pageBuilder: (c, s) => _fade(s, const CheckoutScreen()),
          ),
          GoRoute(
            path: 'processing',
            pageBuilder: (c, s) => _fade(s, const ProcessScreen()),
          ),
          GoRoute(
            path: 'result/:status',
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
          // --- HOME ---
          _tabBranch(
            path: '/home',
            builder: (ctx, st) => Consumer(
              builder: (context, ref, _) {
                final view = ref.watch(homeViewProvider);

                final isSubView =
                    view == HomeView.planDemo || view == HomeView.planPreview;

                // Đổi title nếu thích
                final title = switch (view) {
                  HomeView.planDemo => 'Plan demo',
                  HomeView.planPreview => 'Meal plan cá nhân hóa',
                  _ => 'AI Coach',
                };

                return AppScaffold(
                  appBar: AppAppBar(
                    title: title,
                    showBack: isSubView, // <<< có back cho cả planPreview
                  ),
                  body: PopScope(
                    canPop: !isSubView,
                    onPopInvokedWithResult: (didPop, result) {
                      if (!didPop && isSubView) {
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

          // --- WORKOUT ---
          _tabBranch(
            path: '/daily',
            builder: (ctx, st) => Consumer(
              builder: (context, ref, _) {
                final header = buildUserHeaderFor(ref, '/daily');
                return AppScaffold(
                  appBar: UserHeaderAppBar(header: header!),
                  body: const DailyScreen(),
                );
              },
            ),
          ),

          // --- PROGRESS ---
          _tabBranch(
            path: '/progress',
            builder: (ctx, st) => Consumer(
              builder: (context, ref, _) {
                final header = buildUserHeaderFor(ref, '/progress');
                return AppScaffold(
                  appBar: UserHeaderAppBar(header: header!),
                  body: const ProcessScreen(),
                );
              },
            ),
          ),

          // --- PROFILE ---
          _tabBranch(
            path: '/profile',
            builder: (ctx, st) => AppScaffold(
              appBar: const AppAppBar(title: 'Hồ sơ'),
              body: const SettingScreen(),
            ),
          ),
        ],
        builder: (context, state, navigationShell) {
          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: AppBottomNav(navigationShell: navigationShell),
          );
        },
      ),
    ],

    errorPageBuilder: (c, s) => _fade(
      s,
      Scaffold(body: Center(child: Text('Route error: ${s.error}'))),
    ),
  );
});

/// ===== TAB BRANCH BUILDER =====
StatefulShellBranch _tabBranch({
  required String path,
  required Widget Function(BuildContext, GoRouterState) builder,
}) {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: path,
        pageBuilder: (ctx, st) => _fade(st, builder(ctx, st)),
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
