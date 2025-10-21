import 'package:fitai_mobile/features/payment/domain/plan_model.dart';
import 'package:flutter/material.dart';

class PlanGridCell extends StatelessWidget {
  final PlanModel plan;
  final bool selected;
  final VoidCallback onSelect;
  final VoidCallback onChoose;

  const PlanGridCell({
    super.key,
    required this.plan,
    required this.selected,
    required this.onSelect,
    required this.onChoose,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Giá hiện tại (đã trừ giảm giá nếu có)
    final num priceNow = plan.discount != null
        ? (plan.price * (100 - plan.discount!) / 100).round()
        : plan.price;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onSelect,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? cs.primary : cs.outlineVariant,
            width: selected ? 1.6 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black12,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tiêu đề gói
            Text(
              plan.name,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),

            // Giá
            Column(
              children: [
                Text(
                  _formatVND(priceNow),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (plan.discount != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    _formatVND(plan.price),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),

            // Danh sách features (3–4 dòng như figma)
            ...plan.perks
                .take(4)
                .map(
                  (f) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 16,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            f,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

            const Spacer(),

            // Nút chọn gói
            FilledButton(
              onPressed: onChoose,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Chọn gói này'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatVND(num v) {
    // hiển thị 199.000đ, 5.000.000 …
    final s = v.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return '$sđ';
  }
}
