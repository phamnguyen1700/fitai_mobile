// lib/core/widgets/user_header_appbar.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../config/theme/header_theme.dart';

class UserHeaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSizeWidget header;
  final List<Widget>? actions;
  final bool? showBack;
  final VoidCallback? onBack;

  const UserHeaderAppBar({
    super.key,
    required this.header,
    this.actions,
    this.showBack,
    this.onBack,
  });

  double get _headerH => header.preferredSize.height;

  // ❗ Không cộng status bar vào đây
  @override
  Size get preferredSize => Size.fromHeight(_headerH);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPop = Navigator.of(context).canPop();

    final ht = theme.extension<AppHeaderTheme>();
    final glassColor =
        ht?.backdropColor ?? theme.colorScheme.surface.withOpacity(0.5);
    final sigma = ht?.blurSigma ?? 12.0;

    return AppBar(
      toolbarHeight: _headerH,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      centerTitle: false,
      title: null,
      bottom: null,

      leading: (showBack ?? canPop)
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            )
          : null,
      actions: actions,

      // flexibleSpace chỉ làm nền + blur; SafeArea đẩy nội dung khỏi status bar
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: Container(
            color: glassColor,
            child: SafeArea(
              top: true,
              bottom: false,
              child: SizedBox(height: _headerH, child: header),
            ),
          ),
        ),
      ),
    );
  }
}
