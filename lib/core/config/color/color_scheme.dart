// lib/core/config/color_scheme.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_colors_dark.dart';

class AppColorSchemes {
  static final ColorScheme light =
      ColorScheme.fromSeed(
        seedColor: AppColors.seed,
        brightness: Brightness.light,
      ).copyWith(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceContainerHighest: AppColors.surfaceVariant,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        error: AppColors.error,
        onError: AppColors.onError,
        shadow: AppColors.shadow,
      );

  static final ColorScheme dark =
      ColorScheme.fromSeed(
        seedColor: AppColorsDark.seed,
        brightness: Brightness.dark,
      ).copyWith(
        primary: AppColorsDark.primary,
        onPrimary: AppColorsDark.onPrimary,
        primaryContainer: AppColorsDark.primaryContainer,
        onPrimaryContainer: AppColorsDark.onPrimaryContainer,
        secondary: AppColorsDark.secondary,
        onSecondary: AppColorsDark.onSecondary,
        secondaryContainer: AppColorsDark.secondaryContainer,
        onSecondaryContainer: AppColorsDark.onSecondaryContainer,
        surface: AppColorsDark.surface,
        onSurface: AppColorsDark.onSurface,
        surfaceContainerHighest: AppColorsDark.surfaceVariant,
        onSurfaceVariant: AppColorsDark.onSurfaceVariant,
        outline: AppColorsDark.outline,
        outlineVariant: AppColorsDark.outlineVariant,
        error: AppColorsDark.error,
        onError: AppColorsDark.onError,
        shadow: AppColorsDark.shadow,
      );
}
