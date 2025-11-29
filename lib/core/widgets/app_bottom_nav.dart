// lib/core/widgets/app_bottom_nav.dart
import 'dart:ui';

import 'package:fitai_mobile/core/config/theme/header_theme.dart';
import 'package:fitai_mobile/core/widgets/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _setupPrefixes = <String>[
    '/welcome',
    '/setup',
    '/profile-setup',
    '/payment',
    '/payment-processing',
    '/terms',
    '/privacy',
  ];

  bool _isSetupLocation(String loc) =>
      _setupPrefixes.any((p) => loc == p || loc.startsWith('$p/'));

  /// Lấy current location an toàn cho go_router 12+
  String _currentLocation(BuildContext context) {
    final info = GoRouter.of(context).routeInformationProvider.value;
    return info.uri.toString();
  }

  @override
  Widget build(BuildContext context) {
    final location = _currentLocation(context);
    final isSetup = _isSetupLocation(location);

    // Nếu đang ở các màn setup/onboarding thì không render bottom nav
    if (isSetup) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final borderColor = theme.dividerColor;

    final ht = theme.extension<AppHeaderTheme>();
    final sigma = ht?.blurSigma ?? 12.0;

    final baseColor = theme.colorScheme.surface;
    final glassColor = Color.alphaBlend(
      const Color.fromARGB(31, 173, 173, 173), // xám nhạt phủ lên
      baseColor.withOpacity(0.5), // độ trong suốt thấp
    );

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: Material(
          color: glassColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.zero),
          ),
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: borderColor)),
            ),
            child: SafeArea(
              top: false,
              bottom: true,
              child: _BottomNavBar(navigationShell: navigationShell),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _tabs = [
    ('/home', 'Trang chủ', AppIcons.homeOutline, AppIcons.home),
    ('/daily', 'Kế hoạch', AppIcons.workoutOutline, AppIcons.workout),
    ('/progress', 'Tiến độ', AppIcons.progressOutline, AppIcons.progress),
    ('/profile', 'Hồ sơ', AppIcons.profileOutline, AppIcons.profile),
  ];

  @override
  Widget build(BuildContext context) {
    // ✅ selected index luôn sync với shell
    final idx = navigationShell.currentIndex;

    return NavigationBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      selectedIndex: idx,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: (i) {
        navigationShell.goBranch(i, initialLocation: false);
      },
      destinations: [
        for (final t in _tabs)
          NavigationDestination(
            icon: Icon(t.$3),
            selectedIcon: Icon(t.$4),
            label: t.$2,
          ),
      ],
    );
  }
}
