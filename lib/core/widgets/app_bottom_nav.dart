// lib/core/widgets/app_bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key});

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

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final isSetup = _isSetupLocation(location);

    final bg = Material(
      color: Theme.of(context).navigationBarTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        child: SafeArea(
          top: false,
          minimum: const EdgeInsets.only(bottom: 6),
          child: isSetup ? const _TermsFooter() : const _BottomNavBar(),
        ),
      ),
    );
    return bg;
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  static const _tabs = [
    ('/home', 'Trang chủ', Icons.home_outlined, Icons.home),
    (
      '/workout',
      'Bài tập',
      Icons.fitness_center_outlined,
      Icons.fitness_center,
    ),
    ('/meal', 'Thực đơn', Icons.menu_book_outlined, Icons.menu_book),
    ('/progress', 'Tiến độ', Icons.show_chart_outlined, Icons.show_chart),
    ('/profile', 'Hồ sơ', Icons.person_outline, Icons.person),
  ];

  int _indexFrom(String loc) {
    final i = _tabs.indexWhere(
      (t) => loc == t.$1 || loc.startsWith('${t.$1}/'),
    );
    return i >= 0 ? i : 0;
  }

  @override
  Widget build(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    final idx = _indexFrom(loc);

    return NavigationBar(
      selectedIndex: idx,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: (i) {
        final path = _tabs[i].$1;
        if (loc != path) context.go(path);
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
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
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
