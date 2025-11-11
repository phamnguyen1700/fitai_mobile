import 'package:flutter/material.dart';

class FeetGuideOverlay extends StatelessWidget {
  const FeetGuideOverlay({super.key, this.isActive = false});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final activeColor = Colors.greenAccent;
    final baseColor = Colors.white;

    final fillColor = (isActive ? activeColor : baseColor).withOpacity(0.18);
    final borderColor = isActive ? activeColor : Colors.white.withOpacity(0.9);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Image.asset(
        'lib/core/assets/images/feet.png',
        fit: BoxFit.contain,
        width: 36,
        color: Colors.white.withOpacity(0.9),
        colorBlendMode: BlendMode.srcIn,
      ),
    );
  }
}
