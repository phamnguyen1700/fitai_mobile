import 'package:flutter/material.dart';

class LegalFooter extends StatelessWidget {
  const LegalFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textColor = cs.onSurfaceVariant.withValues(alpha: 0.8);
    Color appBarBg(ColorScheme cs) => cs.brightness == Brightness.dark
        ? const Color(0xFF111214) // hơi sáng hơn body 1 nấc
        : const Color(0xFFFFFFFF); // trắng mỏng cho light

    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        color: appBarBg(cs),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Điều khoản sử dụng  |  Chính sách bảo mật',
              style: TextStyle(fontSize: 12, color: textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Copyright©FitAIplaning. All rights reserved.',
              style: TextStyle(
                fontSize: 11,
                color: textColor.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
