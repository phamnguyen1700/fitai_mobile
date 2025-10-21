// lib/features/home/presentation/widgets/plan/plan_cta.dart
import 'package:flutter/material.dart';

class PlanCTA extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // ← thêm
  const PlanCTA({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
    child: FilledButton(
      onPressed: onPressed, // ← dùng callback
      child: Text(text),
    ),
  );
}
