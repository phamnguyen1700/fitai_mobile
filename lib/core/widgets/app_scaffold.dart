import 'package:flutter/material.dart';
import 'app_bar.dart';
import 'app_bottom_nav.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final bool? showBack;
  final bool showBottomArea;
  final AppBarStyle appBarStyle;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.showBack,
    this.showBottomArea = true,
    this.appBarStyle = AppBarStyle.auto,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: title,
        actions: actions,
        showBack: showBack,
        style: appBarStyle,
      ),
      body: SafeArea(top: false, child: body),
      bottomNavigationBar: showBottomArea ? const AppBottomNav() : null,
    );
  }
}
