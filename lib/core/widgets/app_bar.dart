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

  String _currentLocation(BuildContext context) {
    // ✅ dùng uri thay vì location (không deprecated, hoạt động trong ShellRoute)
    final info = GoRouter.of(context).routeInformationProvider.value;
    return info.uri.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final canPop = Navigator.of(context).canPop();

    final bg = backgroundColor;

    final bottomDivider = showBottomDivider
        ? const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(height: 1, thickness: 1),
          )
        : null;

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: bg,
      centerTitle: true,
      titleSpacing: 0,
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
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
          ? const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(height: 1, thickness: 1),
            )
          : null,
    );
  }
}
