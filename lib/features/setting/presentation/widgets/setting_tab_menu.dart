// lib/features/setting/presentation/widgets/setting_tab_menu.dart
import 'package:flutter/material.dart';
import '../views/setting.dart';

class SettingTabMenu extends StatelessWidget {
  final List<(String, SettingTab)> items;
  final SettingTab current;
  final ValueChanged<SettingTab> onChanged;

  const SettingTabMenu({
    super.key,
    required this.items,
    required this.current,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: items.map((item) {
        final String label = item.$1;
        final SettingTab value = item.$2;
        final bool selected = value == current;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Ink(
            decoration: BoxDecoration(
              color: selected ? cs.primary : cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => onChanged(value),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: selected ? cs.onPrimary : cs.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
