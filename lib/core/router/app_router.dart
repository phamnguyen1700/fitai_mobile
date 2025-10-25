import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Screens
import 'package:fitai_mobile/features/auth/presentation/views/splash_screen.dart';
import 'package:fitai_mobile/features/auth/presentation/views/welcome_screen.dart';
import 'package:fitai_mobile/features/home/presentation/views/home_screen.dart';
// Auth providers
import 'package:fitai_mobile/features/auth/presentation/providers/auth_providers.dart';

enum AppRoute { splash, welcome, home }

/// GoRouter provider – để dùng được Riverpod trong redirect/refresh
final goRouterProvider = Provider<GoRouter>((ref) {
  // Listen to auth state changes to trigger router refresh
  ref.listen<AsyncValue<AuthState>>(authNotifierProvider, (previous, next) {
    // This will cause the router to re-evaluate redirects when auth state changes
  });

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
      GoRoute(
        path: '/home',
        name: AppRoute.home.name,
        pageBuilder: (context, state) => _fade(const HomeScreen()),
      ),
    ],

    // Redirect logic based on auth state
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      
      final onSplash = state.matchedLocation == '/';
      final onWelcome = state.matchedLocation == '/welcome';
      final onHome = state.matchedLocation == '/home';
      
      // Let splash screen handle initial navigation
      if (onSplash) return null;
      
      return authState.when(
        // While loading, don't redirect to avoid premature redirects
        loading: () => null,
        // On error, treat as not authenticated
        error: (_, __) {
          if (onHome) return '/welcome';
          return null;
        },
        // When data is available, make redirect decisions
        data: (data) {
          final isAuthenticated = data.isAuthenticated;
          
          // If authenticated and on welcome, go to home
          if (isAuthenticated && onWelcome) return '/home';
          
          // If not authenticated and on home, go to welcome
          if (!isAuthenticated && onHome) return '/welcome';
          
          return null;
        },
      );
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
