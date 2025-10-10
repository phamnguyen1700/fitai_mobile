import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppBarStyle { auto, surface }

/// AppBar cơ bản dùng cho hầu hết màn hình
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool? showBack;
  final VoidCallback? onBack;
  final bool showBottomDivider;
  final Color? backgroundColor;
  final double height;
  final AppBarStyle style;

  const AppAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack,
    this.onBack,
    this.showBottomDivider = true,
    this.backgroundColor,
    this.height = kToolbarHeight,
    this.style = AppBarStyle.auto,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(height + (showBottomDivider ? 1 : 0));

  bool _isSetup(String loc) {
    const setupPrefixes = [
      '/welcome',
      '/setup',
      '/profile-setup',
      '/payment',
      '/payment-processing',
      '/terms',
      '/privacy',
    ];
    return setupPrefixes.any((p) => loc == p || loc.startsWith('$p/'));
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    final cs = Theme.of(context).colorScheme;
    final dividerColor = Theme.of(context).dividerColor;
    final loc = GoRouterState.of(context).uri.toString();

    final isSetup = style == AppBarStyle.auto
        ? _isSetup(loc)
        : style == AppBarStyle.surface;
    final bg =
        backgroundColor ??
        (isSetup
            ? Theme.of(context).appBarTheme.backgroundColor ?? cs.surface
            : Theme.of(context).appBarTheme.backgroundColor ?? cs.surface);

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      titleSpacing: 0,
      backgroundColor: bg,
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      leading: (showBack ?? canPop)
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            )
          : null,
      actions: actions,
      bottom: showBottomDivider
          ? PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: dividerColor),
            )
          : null,
    );
  }
}
