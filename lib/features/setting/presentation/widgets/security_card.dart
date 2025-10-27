// lib/features/setting/presentation/widgets/security_card.dart
import 'package:flutter/material.dart';

class SecurityCard extends StatelessWidget {
  final String maskedPassword;
  final String email;

  const SecurityCard({
    super.key,
    required this.maskedPassword,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    Widget row(String k, String v, {bool obfuscate = false}) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: cs.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(child: Text(k, style: t.bodyMedium)),
            Text(
              obfuscate ? '**********' : v,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        row('Mật khẩu hiện tại', maskedPassword, obfuscate: true),
        const SizedBox(height: 8),
        row('Email truy cập hiện tại', email),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {},
            child: const Text('Thay đổi mật khẩu'),
          ),
        ),
      ],
    );
  }
}
