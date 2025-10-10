import 'package:flutter/material.dart';

class AppBottomSheet {
  AppBottomSheet._(); // no instance

  /// Modal Bottom Sheet theo M3
  /// - Hỗ trợ full-height (isScrollControlled)
  /// - Giới hạn maxWidth trên tablet/desktop
  /// - Tự dùng theme từ BottomSheetThemeData
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    bool isScrollControlled = true,
    bool enableDrag = true,
    bool useSafeArea = true,
    double? maxWidth = 720, // null = không giới hạn
  }) {
    final bs = Theme.of(context).bottomSheetTheme;

    return showModalBottomSheet<T>(
      context: context,
      useSafeArea: useSafeArea,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      showDragHandle: false,
      backgroundColor: bs.modalBackgroundColor ?? bs.backgroundColor,
      shape:
          bs.shape ??
          const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: bs.modalElevation ?? bs.elevation,
      constraints: (isScrollControlled && maxWidth != null)
          ? BoxConstraints(maxWidth: maxWidth)
          : null,
      builder: (ctx) {
        // Đẩy nội dung lên khi mở bàn phím
        final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: builder(ctx),
        );
      },
    );
  }

  /// Sheet kéo được (DraggableScrollableSheet) – tiện cho list dài / form dài.
  /// Dùng khi muốn UI kéo từ 30% -> 90% màn hình.
  static Future<T?> showScrollable<T>(
    BuildContext context, {
    required Widget Function(BuildContext context, ScrollController controller)
    builder,
    double initialChildSize = 0.5,
    double minChildSize = 0.3,
    double maxChildSize = 0.9,
    bool useSafeArea = true,
    double? maxWidth = 720,
  }) {
    return show<T>(
      context,
      useSafeArea: useSafeArea,
      isScrollControlled: true,
      maxWidth: maxWidth,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: initialChildSize,
          minChildSize: minChildSize,
          maxChildSize: maxChildSize,
          builder: (ctx, controller) {
            return builder(ctx, controller);
          },
        );
      },
    );
  }
}
