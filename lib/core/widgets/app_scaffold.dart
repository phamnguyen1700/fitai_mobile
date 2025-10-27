import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_bottom_nav.dart';
import 'legal_footer.dart';

/// Scaffold chung của app — nhận trực tiếp một AppBar bất kỳ.
/// Dễ tái sử dụng cho cả AppAppBar, UserHeaderAppBar, hoặc AppBar tuỳ chỉnh.
class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;

  // phần đáy
  final bool showBottomNav;
  final bool showLegalFooter;
  final bool showBottomArea;

  const AppScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.showBottomNav = false,
    this.showLegalFooter = false,
    this.showBottomArea = false,
  });

  const AppScaffold.withBottomNav({super.key, this.appBar, required this.body})
    : showBottomNav = true,
      showLegalFooter = false,
      showBottomArea = false;

  const AppScaffold.withLegalFooter({
    super.key,
    this.appBar,
    required this.body,
  }) : showBottomNav = false,
       showLegalFooter = true,
       showBottomArea = false;

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
    final bottomWidget = useBottomNav
        ? AppBottomNav()
        : (showLegalFooter ? const LegalFooter() : null);

    return Scaffold(
      extendBodyBehindAppBar: true, // để blur hoặc gradient nhìn đẹp
      appBar: appBar,
      body: SafeArea(top: true, bottom: false, child: body),
      bottomNavigationBar: bottomWidget,
    );
  }
}
