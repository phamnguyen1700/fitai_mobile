// lib/core/components/app_button.dart
import 'package:flutter/material.dart';

class AppButtonThemes {
  static RoundedRectangleBorder _shape() =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));

  static ElevatedButtonThemeData elevated(ColorScheme cs) =>
      ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(44)),
          shape: WidgetStatePropertyAll(_shape()),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return cs.primary.withValues(alpha: 0.12);
            }
            return cs.primary;
          }),
          foregroundColor: WidgetStatePropertyAll(cs.onPrimary),
          elevation: const WidgetStatePropertyAll(1),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      );

  // Giữ Filled mặc định theo M3 (primary). Tonal sẽ dùng FilledButton.tonal()
  static FilledButtonThemeData filled(ColorScheme cs) => FilledButtonThemeData(
    style: ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size.fromHeight(44)),
      shape: WidgetStatePropertyAll(_shape()),
      textStyle: const WidgetStatePropertyAll(
        TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
  );

  static OutlinedButtonThemeData outlined(ColorScheme cs) =>
      OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(44)),
          shape: WidgetStatePropertyAll(_shape()),
          side: WidgetStatePropertyAll(BorderSide(color: cs.primary)),
          foregroundColor: WidgetStatePropertyAll(cs.primary),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      );

  static TextButtonThemeData text(ColorScheme cs) => TextButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStatePropertyAll(_shape()),
      foregroundColor: WidgetStatePropertyAll(cs.primary),
      textStyle: const WidgetStatePropertyAll(
        TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
  );
}
