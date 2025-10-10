import 'package:flutter/material.dart';

enum AppSnackType { success, error, info }

/// AppSnackBar — Snackbar đồng bộ màu. Gọi: showAppSnack(context, 'Saved', AppSnackType.success)
void showAppSnack(
  BuildContext context,
  String message, [
  AppSnackType type = AppSnackType.info,
]) {
  final cs = Theme.of(context).colorScheme;

  Color bg;
  IconData icon;
  switch (type) {
    case AppSnackType.success:
      bg = cs.inverseSurface;
      icon = Icons.check_circle_rounded;
      break;
    case AppSnackType.error:
      bg = cs.error;
      icon = Icons.error_rounded;
      break;
    case AppSnackType.info:
      bg = cs.inverseSurface;
      icon = Icons.info_rounded;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: bg,
      content: Row(
        children: [
          Icon(icon, color: cs.onInverseSurface),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message, style: TextStyle(color: cs.onInverseSurface)),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 2),
    ),
  );
}
