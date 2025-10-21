// lib/core/widgets/app_bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitai_mobile/core/widgets/app_icons.dart';

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

    return Material(
      color: Colors.transparent,
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
          bottom:
              true, // tôn trọng gesture area, nền cùng màu => nhìn vẫn “sát”
          child: isSetup
              ? const _TermsFooter()
              : _BottomNavBar(currentLocationOf: _currentLocation),
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.currentLocationOf});
  final String Function(BuildContext) currentLocationOf;

  static const _tabs = [
    ('/home', 'Trang chủ', AppIcons.homeOutline, AppIcons.home),
    ('/workout', 'Bài tập', AppIcons.workoutOutline, AppIcons.workout),
    ('/meal', 'Thực đơn', AppIcons.mealOutline, AppIcons.meal),
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
    final loc = currentLocationOf(context);
    final idx = _indexFrom(loc);

    // Lấy shell nếu đang trong StatefulShellRoute
    final shell = StatefulNavigationShell.maybeOf(context);

    return NavigationBar(
      selectedIndex: idx,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: (i) {
        if (shell != null) {
          // ✅ chuyển tab đúng chuẩn, giữ backstack từng tab
          shell.goBranch(i, initialLocation: false);
        } else {
          // Fallback nếu không ở trong shell
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

class _TermsFooter extends StatelessWidget {
  const _TermsFooter();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme.bodySmall;
    final muted = textStyle?.copyWith(color: cs.onSurfaceVariant);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => context.go('/terms'),
                child: Text('Điều khoản sử dụng', style: textStyle),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('|', style: muted),
              ),
              InkWell(
                onTap: () => context.go('/privacy'),
                child: Text('Chính sách bảo mật', style: textStyle),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Copyright©FitAIPlaning. All rights reserved.',
            style: muted,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
