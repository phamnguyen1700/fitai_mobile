import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../color/color_scheme.dart';
import 'app_button_theme.dart';
import 'app_tab_theme.dart';
import 'header_theme.dart';

class AppTheme {
  // Public: dùng thẳng 2 biến này trong MaterialApp
  static final ThemeData lightTheme = _buildTheme(AppColorSchemes.light);
  static final ThemeData darkTheme = _buildTheme(AppColorSchemes.dark);

  static ThemeData _buildTheme(ColorScheme cs, {String? fontFamily}) {
    Color barBg(ColorScheme cs) => cs.brightness == Brightness.dark
        ? const Color.fromARGB(255, 36, 36, 36) // DARK FIXED
        : const Color.fromARGB(255, 228, 228, 228); // LIGHT FIXED

    Color scaffoldBg(ColorScheme cs) => cs.brightness == Brightness.dark
        ? Colors
              .black // = AppBar dark
        : Colors.white; // = AppBar light

    Color glassBarBg(ColorScheme cs) => Color.alphaBlend(
      const Color.fromARGB(31, 128, 128, 128), // xám nhạt phủ lên
      barBg(cs).withOpacity(0.5), // độ trong suốt thấp
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      extensions: [
        AppHeaderTheme(backdropColor: glassBarBg(cs), blurSigma: 12),
      ],
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: barBg(cs),
        modalBackgroundColor: barBg(cs),
        surfaceTintColor: Colors.transparent,
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
      scaffoldBackgroundColor: scaffoldBg(cs),
      // === AppBar ===
      appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(color: cs.onSurface),
        titleTextStyle: TextStyle(
          color: cs.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        systemOverlayStyle: cs.brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
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
        backgroundColor: barBg(cs),
        selectedItemColor: cs.primary,
        unselectedItemColor: cs.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: const IconThemeData(size: 24),
        unselectedIconTheme: const IconThemeData(size: 24),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),

      // === NavigationBar (Material3) ===
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: barBg(cs), // đồng bộ surface
        elevation: 0,
        indicatorColor: Colors.transparent, // theo mockup: không pill
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? cs.primary : cs.outline);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? cs.primary : cs.outline,
          );
        }),
      ),
      dividerColor: cs.outlineVariant, // dùng thống nhất cho viền
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
