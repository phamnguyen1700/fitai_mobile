import 'package:flutter/material.dart';

/// Light palette — bám sát Figma: cam chủ đạo, nền trắng/xám nhạt,
/// chữ đen/xám, viền mảnh.
class AppColors {
  // === Brand / Seed ===
  static const Color seed = Color(
    0xFFFF7A00,
  ); // nếu Figma là #FF6400 -> đổi tại đây

  // === Primary (CTA) ===
  static const Color primary = Color(0xFFFF7A00);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFFFE5CC); // cam nhạt/peach
  static const Color onPrimaryContainer = Color(0xFF3A1E00);

  // === Secondary / Accent (dùng cho chip, tag, subtle fills) ===
  static const Color secondary = Color(0xFFFFA45B);
  static const Color onSecondary = Color(0xFF342210);
  static const Color secondaryContainer = Color(0xFFFFE9D9);
  static const Color onSecondaryContainer = Color(0xFF37210B);

  // === Neutrals (nền & chữ) ===
  static const Color background = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF1F1F1F);
  static const Color surface = Color(0xFFF7F7F7); // card/page bg theo Figma
  static const Color onSurface = Color(0xFF1F1F1F);
  static const Color surfaceVariant = Color(0xFFEFEFEF); // input fill nhẹ
  static const Color onSurfaceVariant = Color(0xFF6B6B6B); // label/subtitle

  // === Outline / Divider ===
  static const Color outline = Color(0xFFDDDDDD);
  static const Color outlineVariant = Color.fromARGB(255, 255, 250, 250);
  static const Color shadow = Color(0x19000000); // 10% đen

  // === Status ===
  static const Color info = Color(0xFF1890FF);
  static const Color success = Color(0xFF00C851);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFDA1E28);
  static const Color onError = Color(0xFFFFFFFF);

  // === Text helpers (tiện dùng ngoài ColorScheme) ===
  static const Color textPrimary = Color(0xFF1F1F1F);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textDisabled = Color(0xFF9E9E9E);

  // === Basic ===
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
}
