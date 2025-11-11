import 'dart:ui';
import 'package:flutter/material.dart';

@immutable
class AppHeaderTheme extends ThemeExtension<AppHeaderTheme> {
  final Color backdropColor;
  final double blurSigma;

  const AppHeaderTheme({required this.backdropColor, this.blurSigma = 12});

  @override
  AppHeaderTheme copyWith({Color? backdropColor, double? blurSigma}) {
    return AppHeaderTheme(
      backdropColor: backdropColor ?? this.backdropColor,
      blurSigma: blurSigma ?? this.blurSigma,
    );
  }

  @override
  AppHeaderTheme lerp(ThemeExtension<AppHeaderTheme>? other, double t) {
    if (other is! AppHeaderTheme) return this;
    return AppHeaderTheme(
      backdropColor: Color.lerp(backdropColor, other.backdropColor, t)!,
      blurSigma: lerpDouble(blurSigma, other.blurSigma, t)!,
    );
  }
}
