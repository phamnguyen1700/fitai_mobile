import 'package:flutter/material.dart';

/// Dark palette — giữ tính nhận diện cam, tăng tương phản chữ,
/// nền #121212 để gần Material 3.
class AppColorsDark {
  // === Brand / Seed ===
  static const Color seed = Color(0xFFFF7A00);

  // === Primary (CTA) ===
  static const Color primary = Color(0xFFFF7A00);
  static const Color onPrimary = Color(0xFF1F0A00);
  static const Color primaryContainer = Color(0xFF5A2A00); // cam đậm
  static const Color onPrimaryContainer = Color(0xFFFFDCC2);

  // === Secondary / Accent ===
  static const Color secondary = Color(0xFFFFA45B);
  static const Color onSecondary = Color(0xFF2A1707);
  static const Color secondaryContainer = Color(0xFF5B2E0E);
  static const Color onSecondaryContainer = Color(0xFFFFE9D9);

  // === Neutrals (nền & chữ) ===
  static const Color background = Color(0xFF0E0E0E);
  static const Color onBackground = Color(0xFFEAEAEA);
  static const Color surface = Color(0xFF121212);
  static const Color onSurface = Color(0xFFEAEAEA);
  static const Color surfaceVariant = Color(0xFF1E1E1E); // input fill
  static const Color onSurfaceVariant = Color(0xFFBDBDBD); // label/subtitle

  // === Outline / Divider ===
  static const Color outline = Color(0xFF3C3C3C);
  static const Color outlineVariant = Color(0xFF2A2A2A);
  static const Color shadow = Color(0x66000000); // 40% đen

  // === Status ===
  static const Color info = Color(0xFF64B5F6);
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFFD54F);
  static const Color error = Color(0xFFFF5252);
  static const Color onError = Color(0xFF1F0A0A);

  // === Text helpers ===
  static const Color textPrimary = Color(0xFFEAEAEA);
  static const Color textSecondary = Color(0xFFBDBDBD);
  static const Color textDisabled = Color(0xFF8D8D8D);

  // === Basic ===
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
}
