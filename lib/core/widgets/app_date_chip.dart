import 'package:flutter/material.dart';

class AppDateChip extends StatelessWidget {
  const AppDateChip({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${date.day}/${date.month}/${date.year}',
        style: (t.labelSmall ?? const TextStyle()).copyWith(
          color: cs.onSurfaceVariant,
        ),
      ),
    );
  }
}
