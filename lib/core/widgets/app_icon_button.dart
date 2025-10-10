import 'package:flutter/material.dart';

enum AppIconButtonVariant { plain, filled, filledTonal, outlined }

/// AppIconButton — bọc IconButton theo 4 biến thể M3.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = AppIconButtonVariant.plain,
    this.tooltip,
  });

  final Icon icon;
  final VoidCallback? onPressed;
  final AppIconButtonVariant variant;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case AppIconButtonVariant.filled:
        return IconButton.filled(
          onPressed: onPressed,
          icon: icon,
          tooltip: tooltip,
        );
      case AppIconButtonVariant.filledTonal:
        return IconButton.filledTonal(
          onPressed: onPressed,
          icon: icon,
          tooltip: tooltip,
        );
      case AppIconButtonVariant.outlined:
        return IconButton.outlined(
          onPressed: onPressed,
          icon: icon,
          tooltip: tooltip,
        );
      case AppIconButtonVariant.plain:
        return IconButton(onPressed: onPressed, icon: icon, tooltip: tooltip);
    }
  }
}
