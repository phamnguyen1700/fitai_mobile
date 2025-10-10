import 'package:flutter/material.dart';

/// AppDialog helpers — hiển thị dialog xác nhận / thông báo theo M3.
///
/// Ví dụ:
/// final ok = await showAppConfirm(context, title: 'Xác nhận', message: 'Thanh toán?');
Future<bool?> showAppConfirm(
  BuildContext context, {
  String? title,
  String? message,
  String confirmText = 'Đồng ý',
  String cancelText = 'Hủy',
}) {
  final cs = Theme.of(context).colorScheme;
  return showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: title == null ? null : Text(title),
      content: message == null ? null : Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelText),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmText),
        ),
      ],
      backgroundColor: cs.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}

/// Thông báo đơn giản (OK)
Future<void> showAppAlert(
  BuildContext context, {
  String? title,
  required String message,
  String buttonText = 'OK',
}) {
  final cs = Theme.of(context).colorScheme;
  return showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      title: title == null ? null : Text(title),
      content: Text(message),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: Text(buttonText),
        ),
      ],
      backgroundColor: cs.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
