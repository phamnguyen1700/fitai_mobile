// lib/core/widgets/legal_footer.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import '../config/theme/header_theme.dart';

class LegalFooter extends StatelessWidget {
  const LegalFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ht = theme.extension<AppHeaderTheme>();

    final textColor = cs.onSurfaceVariant.withValues(alpha: 0.8);

    // 🌫️ Glass color giống AppAppBar / AppBottomNav
    final baseColor = cs.surface;
    final glassColor = Color.alphaBlend(
      const Color.fromARGB(31, 128, 128, 128), // xám phủ
      baseColor.withOpacity(0.5),
    );
    final sigma = ht?.blurSigma ?? 12.0;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: SafeArea(
          top: false,
          child: Container(
            width: double.infinity,
            color: glassColor,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
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
        ),
      ),
    );
  }
}
