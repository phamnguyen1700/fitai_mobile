import 'package:flutter/material.dart';

class PlanLimitNote extends StatelessWidget {
  final List<String> viewLimits;
  final List<String> benefits;

  const PlanLimitNote({
    super.key,
    required this.viewLimits,
    required this.benefits,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Container(
      width: double.infinity, // ✅ full màn hình
      color: cs.brightness == Brightness.dark
          ? Colors.black
          : Colors.white, // nền cùng màu app
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bạn chỉ có thể xem được:',
            style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          for (final v in viewLimits)
            Text(v, style: t.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),

          const SizedBox(height: 12),
          Row(
            children: [
              const Text('👉 ', style: TextStyle(fontSize: 16)),
              Text(
                'Nâng cấp Premium để unlock toàn bộ:',
                style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
        ],
      ),
    );
  }
}
