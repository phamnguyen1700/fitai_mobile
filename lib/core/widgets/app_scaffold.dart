// lib/core/widgets/app_scaffold.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'app_bottom_nav.dart';
import 'legal_footer.dart';

class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;

  // phần đáy
  final bool showBottomNav;
  final bool showLegalFooter;
  final bool showBottomArea;

  final StatefulNavigationShell? navigationShell;

  const AppScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.showBottomNav = false,
    this.showLegalFooter = false,
    this.showBottomArea = false,
    this.navigationShell,
  });

  const AppScaffold.withBottomNav({
    super.key,
    this.appBar,
    required this.body,
    required this.navigationShell,
  }) : showBottomNav = true,
       showLegalFooter = false,
       showBottomArea = false;

  const AppScaffold.withLegalFooter({
    super.key,
    this.appBar,
    required this.body,
  }) : showBottomNav = false,
       showLegalFooter = true,
       showBottomArea = false,
       navigationShell = null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final navBg =
        theme.navigationBarTheme.backgroundColor ??
        theme.bottomNavigationBarTheme.backgroundColor ??
        theme.colorScheme.surface;

    // Set màu status bar / navigation bar
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: navBg,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
      ),
    );

    // Đáy: bottom nav hoặc legal footer
    final useBottomNav = showBottomNav || showBottomArea;

    // đảm bảo không quên truyền shell
    assert(
      !useBottomNav || navigationShell != null,
      'navigationShell is required when using bottom nav',
    );

    final bottomWidget = useBottomNav
        ? AppBottomNav(navigationShell: navigationShell!)
        : (showLegalFooter ? const LegalFooter() : null);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: SafeArea(top: true, bottom: false, child: body),
      bottomNavigationBar: bottomWidget,
    );
  }
}
