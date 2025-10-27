// lib/features/setting/presentation/widgets/profile_info_card.dart
import 'package:flutter/material.dart';

class ProfileInfoCard extends StatelessWidget {
  final String? avatarUrl;
  final String displayName;
  final String subtitle;
  final Map<String, String> stats;
  final VoidCallback? onEdit;

  const ProfileInfoCard({
    super.key,
    required this.avatarUrl,
    required this.displayName,
    required this.subtitle,
    required this.stats,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: avatarUrl != null
                  ? NetworkImage(avatarUrl!)
                  : null,
              child: avatarUrl == null ? const Icon(Icons.person) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(subtitle, style: TextStyle(color: cs.onSurfaceVariant)),
                ],
              ),
            ),

            // ⬇️ GHI ĐÈ RÀNG BUỘC ĐỂ KHÔNG CÒN minWidth = ∞
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 0), // chống Infinity
              child: OutlinedButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Edit'),
                style:
                    OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      visualDensity: VisualDensity.compact,
                      minimumSize: const Size(0, 32), // ← quan trọng
                      tapTargetSize:
                          MaterialTapTargetSize.shrinkWrap, // gọn hitbox
                    ).merge(
                      const ButtonStyle(
                        // nếu theme đang có fixedSize, ta vô hiệu hoá bằng đặt cực nhỏ
                        fixedSize: MaterialStatePropertyAll<Size?>(null),
                      ),
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _StatsTable(stats: stats),
      ],
    );
  }
}

class _StatsTable extends StatelessWidget {
  final Map<String, String> stats;
  const _StatsTable({required this.stats});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final entries = stats.entries.toList();

    final rows = <TableRow>[];
    for (int i = 0; i < entries.length; i += 2) {
      final left = entries[i];
      final right = (i + 1 < entries.length) ? entries[i + 1] : null;

      rows.add(
        TableRow(
          children: [
            _StatCell(label: left.key, value: left.value, colorScheme: cs),
            right != null
                ? _StatCell(
                    label: right.key,
                    value: right.value,
                    colorScheme: cs,
                  )
                : const SizedBox.shrink(),
          ],
        ),
      );
    }

    return Table(
      columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(1)},
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: rows,
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme colorScheme;

  const _StatCell({
    required this.label,
    required this.value,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      margin: const EdgeInsets.only(bottom: 8, right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
