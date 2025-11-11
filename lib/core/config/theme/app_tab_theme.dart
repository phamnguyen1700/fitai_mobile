import 'package:flutter/material.dart';

class AppTabThemes {
  static TabBarThemeData build(ColorScheme cs) {
    return TabBarThemeData(
      // Label & màu theo M3 + Figma
      labelColor: cs.primary,
      unselectedLabelColor: cs.onSurfaceVariant,
      labelStyle: const TextStyle(fontWeight: FontWeight.w700),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),

      // Gạch chân dày 2px, thụt 2 bên nhẹ
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: cs.primary, width: 2),
      ),
      indicatorSize: TabBarIndicatorSize.label,

      // Đường kẻ mảnh dưới TabBar (M3)
      dividerColor: cs.outline.withValues(alpha: 0.2),

      // Ripple/hover nhạt
      overlayColor: WidgetStatePropertyAll(cs.primary.withValues(alpha: 0.06)),

      // Nếu dùng nhiều tab và muốn cuộn thì set ở widget TabBar (isScrollable: true)
      // tabAlignment: TabAlignment.start, // (mặc định)
    );
  }
}
