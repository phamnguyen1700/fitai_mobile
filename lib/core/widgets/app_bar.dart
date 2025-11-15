// lib/core/widgets/app_bar.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../config/theme/header_theme.dart';

enum AppBarStyle { auto, surface }

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool? showBack;
  final VoidCallback? onBack;
  final bool showBottomDivider;
  final double height;
  final Color? backgroundColor;
  final AppBarStyle style;

  const AppAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack,
    this.onBack,
    this.showBottomDivider = true,
    this.height = kToolbarHeight,
    this.backgroundColor,
    this.style = AppBarStyle.auto,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(height + (showBottomDivider ? 1 : 0));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPop = Navigator.of(context).canPop();
    final baseColor = backgroundColor ?? theme.colorScheme.surface;

    final ht = theme.extension<AppHeaderTheme>();

    final glassColor = Color.alphaBlend(
      const Color.fromARGB(31, 128, 128, 128), // xám nhạt phủ lên
      baseColor.withOpacity(0.5), // độ trong suốt thấp
    );

    final sigma = ht?.blurSigma ?? 12.0;

    return AppBar(
      toolbarHeight: height,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent, // glass
      flexibleSpace: ClipRect(
        // blur nền AppBar
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: Container(color: glassColor),
        ),
      ),
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
