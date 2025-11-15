// lib/features/home/presentation/widgets/plan/plan_note.dart
import 'package:flutter/material.dart';

class PlanLimitNote extends StatelessWidget {
  final List<String> benefits;
  final String buttonText;
  final VoidCallback? onPressed;

  const PlanLimitNote({
    super.key,
    required this.benefits,
    required this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      color: cs.brightness == Brightness.dark ? Colors.black : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              const Text('👉 ', style: TextStyle(fontSize: 16)),
              Text(
                'Nâng cấp Premium để mở khóa toàn bộ:',
                style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Bullet benefits
          for (final b in benefits)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.orange,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Expanded(child: Text(b, style: t.bodyMedium)),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // CTA button
          SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: onPressed, child: Text(buttonText)),
          ),
        ],
      ),
    );
  }
}
