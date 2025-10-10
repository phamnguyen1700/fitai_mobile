import 'package:flutter/material.dart';
import 'app_card.dart';

/// AppChartContainer — khung chuẩn cho biểu đồ: title + actions + child chart.
/// Dùng cho line/pie chart ở Dashboard/Progress.
class AppChartContainer extends StatelessWidget {
  const AppChartContainer({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.padding = const EdgeInsets.all(16),
  });

  final String title;
  final List<Widget>? actions;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700);
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
            child: Row(
              children: [
                Expanded(child: Text(title, style: textStyle)),
                if (actions != null) ...actions!,
              ],
            ),
          ),
          Padding(padding: padding, child: child),
        ],
      ),
    );
  }
}
