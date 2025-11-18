// lib/core/widgets/user_header_appbar.dart
import 'dart:ui';
import 'package:flutter/material.dart';

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

  @override
  Size get preferredSize => Size.fromHeight(_headerH);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final canPop = Navigator.of(context).canPop();

    // 🎨 Glass color cho Light / Dark
    final glassBg = cs.brightness == Brightness.dark
        ? const Color.fromARGB(255, 255, 142, 67).withOpacity(0.1)
        : const Color.fromARGB(255, 255, 142, 67).withOpacity(0.1);

    // Viền glass rất nhẹ
    final glassBorder = cs.brightness == Brightness.dark
        ? const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1)
        : const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1);

    return AppBar(
      toolbarHeight: _headerH,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      title: null,
      bottom: null,
      automaticallyImplyLeading: false,

      leading: (showBack ?? canPop)
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            )
          : null,

      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: glassBg,
              border: Border(bottom: BorderSide(color: glassBorder, width: 1)),
            ),
            child: SafeArea(
              top: true,
              bottom: false,
              child: SizedBox(height: _headerH, child: header),
            ),
          ),
        ),
      ),
      actions: actions,
    );
  }
}
