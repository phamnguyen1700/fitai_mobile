import 'package:flutter/material.dart';

/// AppLoadingOverlay — phủ màn hình với vòng quay, dùng cho các hành động chờ.
/// final handle = AppLoadingOverlay.show(context);
/// ... await api ...
/// handle.close();
class AppLoadingOverlay {
  AppLoadingOverlay._(this._entry);
  final OverlayEntry _entry;

  static AppLoadingOverlay show(BuildContext context, {String? message}) {
    final cs = Theme.of(context).colorScheme;
    final entry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          ModalBarrier(
            color: Colors.black.withValues(alpha: 0.12),
            dismissible: false,
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 4),
                  CircularProgressIndicator(color: cs.primary),
                  if (message != null) ...[
                    const SizedBox(height: 12),
                    Text(message, style: TextStyle(color: cs.onSurface)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(entry);
    return AppLoadingOverlay._(entry);
  }

  void close() => _entry.remove();
}
