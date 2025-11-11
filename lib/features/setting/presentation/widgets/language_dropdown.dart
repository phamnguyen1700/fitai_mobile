// lib/features/setting/presentation/widgets/language_dropdown.dart
import 'package:flutter/material.dart';

class LanguageDropdown extends StatelessWidget {
  final List<(String, String)> items;
  final String value;
  final ValueChanged<String?> onChanged;

  const LanguageDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        items: items
            .map((e) => DropdownMenuItem(value: e.$2, child: Text(e.$1)))
            .toList(),
        onChanged: onChanged,
        decoration: const InputDecoration(
          isDense: true,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }
}
