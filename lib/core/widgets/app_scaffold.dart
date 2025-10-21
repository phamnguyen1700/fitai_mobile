// lib/core/widgets/app_scaffold.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_bar.dart';
import 'app_bottom_nav.dart';
import 'legal_footer.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final bool? showBack;

  /// MỚI: chọn phần đáy
  final bool showBottomNav; // AppBottomNav (tab chính)
  final bool showLegalFooter; // Footer điều khoản
  final bool showBottomArea;

  final AppBarStyle appBarStyle;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.showBack,
    this.showBottomNav = false,
    this.showLegalFooter = false,
    this.showBottomArea = false, // để không phá code cũ
    this.appBarStyle = AppBarStyle.auto,
  });

  /// Named constructors cho gọn
  const AppScaffold.withBottomNav({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.showBack,
    this.appBarStyle = AppBarStyle.auto,
  }) : showBottomNav = true,
       showLegalFooter = false,
       showBottomArea = false;

  const AppScaffold.withLegalFooter({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.showBack,
    this.appBarStyle = AppBarStyle.auto,
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

    // Đừng gọi setSystemUIOverlayStyle ở nơi rebuild liên tục trong app lớn.
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

    // Backwards-compat: nếu dev vẫn truyền showBottomArea=true
    final useBottomNav = showBottomNav || showBottomArea;
    final bottomWidget = useBottomNav
        ? AppBottomNav()
        : (showLegalFooter ? const LegalFooter() : null);

    return Scaffold(
      appBar: AppAppBar(
        title: title,
        actions: actions,
        showBack: showBack,
        style: appBarStyle,
      ),
      body: SafeArea(top: false, bottom: false, child: body),
      bottomNavigationBar: bottomWidget,
    );
  }
}
