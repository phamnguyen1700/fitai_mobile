import 'package:flutter/material.dart';

/// AppChip — ChoiceChip/FilterChip theo M3.
/// Choice: chọn 1; Filter: có thể nhiều.
class AppChoiceChip extends StatelessWidget {
  const AppChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    this.onSelected,
    this.icon,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(label),
      avatar: icon == null ? null : Icon(icon, size: 18),
      selected: selected,
      onSelected: onSelected,
      labelStyle: TextStyle(
        color: selected ? cs.onSecondaryContainer : cs.onSurface,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: cs.surfaceContainerHighest,
      selectedColor: cs.secondaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      side: BorderSide(color: cs.outlineVariant),
    );
  }
}

class AppFilterChip extends StatelessWidget {
  const AppFilterChip({
    super.key,
    required this.label,
    required this.selected,
    this.onSelected,
    this.icon,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return FilterChip(
      label: Text(label),
      avatar: icon == null ? null : Icon(icon, size: 18),
      selected: selected,
      onSelected: onSelected,
      labelStyle: TextStyle(
        color: selected ? cs.onSecondaryContainer : cs.onSurface,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: cs.surfaceContainerHighest,
      selectedColor: cs.secondaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      side: BorderSide(color: cs.outlineVariant),
      showCheckmark: false,
    );
  }
}
