import 'package:flutter/material.dart';
import 'color_scheme.dart';
import './app_button_theme.dart';
import 'app_tab_theme.dart';

class AppTheme {
  // Public: dùng thẳng 2 biến này trong MaterialApp
  static final ThemeData lightTheme = _buildTheme(AppColorSchemes.light);
  static final ThemeData darkTheme = _buildTheme(AppColorSchemes.dark);

  static ThemeData _buildTheme(ColorScheme cs, {String? fontFamily}) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cs.surface,
        surfaceTintColor: cs.surfaceTint,
        modalBackgroundColor: cs.surface,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        elevation: 1,
        modalElevation: 2,
        clipBehavior: Clip.none,
        dragHandleColor: cs.onSurfaceVariant,
        dragHandleSize: const Size(32, 4),
        showDragHandle: false,
      ),
      fontFamily: fontFamily,
      visualDensity: VisualDensity.standard,
      scaffoldBackgroundColor: cs.surface,
      // === AppBar ===
      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: cs.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      // === Card ===
      cardTheme: CardThemeData(
        color: cs.surface,
        elevation: 1.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.zero,
      ),
      // === Buttons (đã tách trong AppButtonThemes) ===
      elevatedButtonTheme: AppButtonThemes.elevated(cs),
      filledButtonTheme: AppButtonThemes.filled(cs),
      outlinedButtonTheme: AppButtonThemes.outlined(cs),
      textButtonTheme: AppButtonThemes.text(cs),

      // === Input / Form ===
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cs.surfaceContainerHighest, // M3 container
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outline, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.outline, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.primary, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.error),
        ),
        prefixIconColor: cs.onSurfaceVariant,
        suffixIconColor: cs.onSurfaceVariant,
        hintStyle: TextStyle(color: cs.onSurfaceVariant),
        labelStyle: TextStyle(color: cs.onSurfaceVariant),
      ),

      // === Bottom Navigation (Material2) ===
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cs.surface,
        selectedItemColor: cs.primary,
        unselectedItemColor: cs.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: const IconThemeData(size: 24),
        unselectedIconTheme: const IconThemeData(size: 24),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),

      // === NavigationBar (Material3) ===
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cs.surface,
        indicatorColor: cs.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.selected)
              ? cs.onPrimaryContainer
              : cs.onSurfaceVariant;
          return IconThemeData(color: color);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.selected)
              ? cs.onSurface
              : cs.onSurfaceVariant;
          return TextStyle(fontWeight: FontWeight.w600, color: color);
        }),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        height: 64,
      ),

      // === Chip ===
      chipTheme: ChipThemeData(
        backgroundColor: cs.surfaceContainerHighest,
        selectedColor: cs.secondaryContainer,
        labelStyle: TextStyle(color: cs.onSurface),
        secondaryLabelStyle: TextStyle(color: cs.onSecondaryContainer),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: cs.outlineVariant),
      ),

      // === Dialog ===
      dialogTheme: DialogThemeData(
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: TextStyle(
          color: cs.onSurface,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        contentTextStyle: TextStyle(color: cs.onSurface, fontSize: 14),
      ),

      // === SnackBar ===
      snackBarTheme: SnackBarThemeData(
        backgroundColor: cs.inverseSurface,
        contentTextStyle: TextStyle(color: cs.onInverseSurface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // === TabBar ===
      tabBarTheme: AppTabThemes.build(cs),

      // === Divider / Icon / Progress ===
      dividerTheme: DividerThemeData(
        color: cs.outlineVariant,
        thickness: 1,
        space: 24,
      ),
      iconTheme: IconThemeData(color: cs.onSurface),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: cs.primary,
        linearTrackColor: cs.surfaceContainerHighest,
      ),

      // === Selection controls ===
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        fillColor: WidgetStateProperty.resolveWith(
          (s) =>
              s.contains(WidgetState.selected) ? cs.primary : cs.outlineVariant,
        ),
      ),
      radioTheme: RadioThemeData(fillColor: WidgetStatePropertyAll(cs.primary)),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? cs.onPrimary : cs.onSurface,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) =>
              s.contains(WidgetState.selected) ? cs.primary : cs.outlineVariant,
        ),
      ),

      // === Text (nhẹ, chuẩn M3) ===
      textTheme: Typography.material2021(platform: TargetPlatform.android).black
          .apply(
            // Dùng onSurface làm màu chữ mặc định
            bodyColor: cs.onSurface,
            displayColor: cs.onSurface,
          ),
    );

    return base;
  }
}
