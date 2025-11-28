import 'dart:ui';
import 'package:flutter/material.dart';

typedef OnboardingGateCondition = bool Function(String? value);

/// Generic blur overlay to lock a widget based on onboarding step or subscription product.
class OnboardingGate extends StatelessWidget {
  const OnboardingGate({
    super.key,
    required this.child,
    this.onboardingStep,
    this.subscriptionProductName,
    required this.shouldLock,
    required this.lockMessage,
    this.lockTitle,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.icon = Icons.lock_clock_rounded,
    this.iconSize = 36,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.blurSigma = 4,
  });

  final Widget child;

  /// Bước onboarding hiện tại (nếu dùng flow onboarding)
  final String? onboardingStep;

  /// Tên gói subscription (nếu dùng flow phân quyền theo gói)
  final String? subscriptionProductName;

  /// Hàm quyết định có khóa hay không – nhận vào *1 string* (step hoặc productName)
  final OnboardingGateCondition shouldLock;

  final String lockMessage;
  final String? lockTitle;
  final BorderRadius borderRadius;
  final IconData icon;
  final double iconSize;
  final EdgeInsets padding;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    // Nếu có onboardingStep thì ưu tiên dùng, không thì dùng subscriptionProductName
    final rawValue = onboardingStep ?? subscriptionProductName;
    final normalizedValue = rawValue?.toLowerCase();

    final locked = shouldLock(normalizedValue);

    if (!locked) return child;

    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Stack(
      children: [
        IgnorePointer(ignoring: locked, child: child),
        Positioned.fill(
          child: ClipRRect(
            borderRadius: borderRadius,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
              child: Container(
                decoration: BoxDecoration(
                  color: cs.surface.withOpacity(0.8),
                  borderRadius: borderRadius,
                  border: Border.all(color: cs.outlineVariant),
                ),
                alignment: Alignment.center,
                padding: padding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: cs.primary, size: iconSize),
                    const SizedBox(height: 12),
                    Text(
                      lockTitle ?? 'Tính năng đang tạm khóa',
                      style: t.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      lockMessage,
                      style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
