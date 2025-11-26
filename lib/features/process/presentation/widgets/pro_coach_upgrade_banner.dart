import 'package:flutter/material.dart';

class ProCoachUpgradeBanner extends StatelessWidget {
  const ProCoachUpgradeBanner({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: const DecorationImage(
            image: AssetImage('lib/core/assets/images/procoach.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Overlay mờ để dễ đọc chữ
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withOpacity(0.55),
                    Colors.black.withOpacity(0.20),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // 👈 wrap content
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nâng cấp gói Pro AI Coach',
                          style: t.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _bullet(t, 'Nhắc nhở hằng ngày'),
                        _bullet(t, 'Thực đơn linh hoạt theo lịch'),
                        _bullet(t, 'Chat trực tiếp với AI 24/7'),
                        const SizedBox(height: 8), // thay cho Spacer
                        SizedBox(
                          height: 32,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFFF7A2F),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                            onPressed: onTap,
                            child: const Text('Nâng cấp ngay'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bullet(TextTheme t, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Colors.white, fontSize: 12)),
          Expanded(
            child: Text(
              text,
              style: t.bodySmall?.copyWith(color: Colors.white, height: 1.15),
            ),
          ),
        ],
      ),
    );
  }
}
