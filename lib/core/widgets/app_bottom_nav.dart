// lib/core/widgets/app_bottom_nav.dart
import 'package:fitai_mobile/core/config/theme/header_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitai_mobile/core/widgets/app_icons.dart';
import 'dart:ui';

class AppBottomNav extends StatelessWidget {
  AppBottomNav({super.key});

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

  /// Lấy current location an toàn cho go_router 12+ và trong ShellRoute
  String _currentLocation(BuildContext context) {
    final info = GoRouter.of(context).routeInformationProvider.value;
    return info.uri.toString();
  }

  @override
  Widget build(BuildContext context) {
    final location = _currentLocation(context);
    final isSetup = _isSetupLocation(location);

    final theme = Theme.of(context);
    final borderColor = theme.dividerColor;

    if (isSetup) {
      return const SizedBox.shrink();
    }

    final ht = theme.extension<AppHeaderTheme>();
    final sigma = ht?.blurSigma ?? 12.0;

    // 👇 giống logic trong AppAppBar
    final baseColor = theme.colorScheme.surface;
    final glassColor = Color.alphaBlend(
      const Color.fromARGB(31, 128, 128, 128), // xám nhạt phủ lên
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
            child: const SafeArea(
              top: false,
              bottom: true,
              child: _BottomNavBar(
                currentLocationOf: _currentLocationForBottomNav,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Workaround để truyền static function vào const _BottomNavBar
  static String _currentLocationForBottomNav(BuildContext context) {
    final info = GoRouter.of(context).routeInformationProvider.value;
    return info.uri.toString();
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.currentLocationOf});

  final String Function(BuildContext) currentLocationOf;

  static const _tabs = [
    ('/home', 'Trang chủ', AppIcons.homeOutline, AppIcons.home),
    ('/daily', 'Kế hoạch', AppIcons.workoutOutline, AppIcons.workout),
    ('/progress', 'Tiến độ', AppIcons.progressOutline, AppIcons.progress),
    ('/profile', 'Hồ sơ', AppIcons.profileOutline, AppIcons.profile),
  ];

  int _indexFrom(String loc) {
    final i = _tabs.indexWhere(
      (t) => loc == t.$1 || loc.startsWith('${t.$1}/'),
    );
    return i >= 0 ? i : 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = currentLocationOf(context);
    final idx = _indexFrom(loc);

    // Lấy shell nếu đang trong StatefulShellRoute
    final shell = StatefulNavigationShell.maybeOf(context);

    return NavigationBar(
      // 👇 vì bên ngoài đã có glassColor nên để transparent
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,

      selectedIndex: idx,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: (i) {
        if (shell != null) {
          shell.goBranch(i, initialLocation: false);
        } else {
          final path = _tabs[i].$1;
          context.go(path);
        }
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
