import 'package:flutter/material.dart';

/// AppCard — Card bo 12, elevation 1.5, padding mặc định.
/// Dùng làm container cho meal/workout item, stats block, v.v.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.onTap,
    this.color,
    this.elevation,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? color;
  final double? elevation;

  BorderRadius getBorderRadius(ShapeBorder? shape, {double fallback = 12}) {
    if (shape is RoundedRectangleBorder) {
      final br = shape.borderRadius;
      if (br is BorderRadius) return br;
    }
    return BorderRadius.circular(fallback);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: color ?? theme.cardTheme.color,
      elevation: elevation ?? theme.cardTheme.elevation,
      shape: theme.cardTheme.shape,
      margin: margin,
      child: InkWell(
        onTap: onTap,
        borderRadius: getBorderRadius(theme.cardTheme.shape),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
