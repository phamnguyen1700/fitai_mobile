import 'package:flutter/material.dart';

enum AppButtonVariant { filled, tonal, outlined, text }

enum AppButtonSize { xs, sm, md, lg }

enum AppButtonShape { rounded, pill, square }

enum AppIconPosition { leading, trailing }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.size = AppButtonSize.md,
    this.shape = AppButtonShape.rounded,
    this.fullWidth = false,
    this.icon,
    this.iconPosition = AppIconPosition.leading,
    this.isLoading = false,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final AppButtonShape shape;
  final bool fullWidth;
  final IconData? icon;
  final AppIconPosition iconPosition;
  final bool isLoading;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final dims = _Dims.of(context, size);
    final cs = Theme.of(context).colorScheme;

    // Child (text + optional icon or spinner)
    final baseText = Text(
      label,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: dims.font, // font vẫn để bình thường, textScaler global lo
      ),
    );

    Widget inner;
    if (isLoading) {
      inner = Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: dims.spinner,
            height: dims.spinner,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: dims.gap),
          baseText,
        ],
      );
    } else if (icon != null) {
      final iconWidget = Icon(icon, size: dims.icon);
      final children = iconPosition == AppIconPosition.leading
          ? [iconWidget, SizedBox(width: dims.gap), baseText]
          : [baseText, SizedBox(width: dims.gap), iconWidget];

      inner = Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );
    } else {
      inner = baseText;
    }

    // Shape
    final OutlinedBorder shapeBorder;
    switch (shape) {
      case AppButtonShape.pill:
        shapeBorder = const StadiumBorder();
        break;
      case AppButtonShape.square:
        shapeBorder = RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        );
        break;
      case AppButtonShape.rounded:
        shapeBorder = RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        );
        break;
    }

    // Disabled/pressed màu theo M3
    final bgDisabled = cs.onSurface.withValues(alpha: 0.12);
    final fgDisabled = cs.onSurface.withValues(alpha: 0.38);

    // Base style (áp cho mọi variant)
    final ButtonStyle baseStyle = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size(dims.minWidth, dims.height)),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: dims.hPad),
      ),
      shape: WidgetStatePropertyAll(shapeBorder),
      textStyle: WidgetStatePropertyAll(
        TextStyle(fontWeight: FontWeight.w600, fontSize: dims.font),
      ),
    );

    // Variant-specific style
    ButtonStyle style;
    switch (variant) {
      case AppButtonVariant.filled:
        style = baseStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return bgDisabled;
            return cs.primary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled)
                ? fgDisabled
                : cs.onPrimary,
          ),
          overlayColor: WidgetStatePropertyAll(
            cs.onPrimary.withValues(alpha: 0.08),
          ),
          elevation: const WidgetStatePropertyAll(0),
        );
        break;

      case AppButtonVariant.tonal:
        style = baseStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return bgDisabled;
            return cs.secondaryContainer;
          }),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled)
                ? fgDisabled
                : cs.onSecondaryContainer,
          ),
          overlayColor: WidgetStatePropertyAll(
            cs.onSecondaryContainer.withValues(alpha: 0.08),
          ),
          elevation: const WidgetStatePropertyAll(0),
        );
        break;

      case AppButtonVariant.outlined:
        style = baseStyle.copyWith(
          side: WidgetStatePropertyAll(BorderSide(color: cs.primary)),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) =>
                states.contains(WidgetState.disabled) ? fgDisabled : cs.primary,
          ),
          overlayColor: WidgetStatePropertyAll(
            cs.primary.withValues(alpha: 0.08),
          ),
          elevation: const WidgetStatePropertyAll(0),
          backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        );
        break;

      case AppButtonVariant.text:
        style = baseStyle.copyWith(
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) =>
                states.contains(WidgetState.disabled) ? fgDisabled : cs.primary,
          ),
          overlayColor: WidgetStatePropertyAll(
            cs.primary.withValues(alpha: 0.08),
          ),
          backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
          elevation: const WidgetStatePropertyAll(0),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: dims.hPadText),
          ),
          minimumSize: WidgetStatePropertyAll(
            Size(dims.minWidthText, dims.heightText),
          ),
        );
        break;
    }

    // Pick underlying Material button by variant
    final disabled = onPressed == null || isLoading;
    final Widget button = switch (variant) {
      AppButtonVariant.outlined => OutlinedButton(
        style: style,
        onPressed: disabled ? null : onPressed,
        child: inner,
      ),
      AppButtonVariant.tonal => FilledButton.tonal(
        style: style,
        onPressed: disabled ? null : onPressed,
        child: inner,
      ),
      AppButtonVariant.text => TextButton(
        style: style,
        onPressed: disabled ? null : onPressed,
        child: inner,
      ),
      AppButtonVariant.filled => FilledButton(
        style: style,
        onPressed: disabled ? null : onPressed,
        child: inner,
      ),
    };

    final Widget wrapped = fullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;

    return Semantics(
      button: true,
      label: semanticLabel ?? label,
      enabled: !disabled,
      child: wrapped,
    );
  }
}

class _Dims {
  final double height;
  final double minWidth;
  final double hPad; // horizontal padding
  final double font;
  final double icon;
  final double spinner;
  final double gap;

  // riêng cho text buttons (bé hơn)
  final double heightText;
  final double minWidthText;
  final double hPadText;

  const _Dims({
    required this.height,
    required this.minWidth,
    required this.hPad,
    required this.font,
    required this.icon,
    required this.spinner,
    required this.gap,
    required this.heightText,
    required this.minWidthText,
    required this.hPadText,
  });

  _Dims scale(double f) {
    if (f == 1.0) return this;
    return _Dims(
      height: height * f,
      minWidth: minWidth * f,
      hPad: hPad * f,
      font: font, // font không scale thêm, textScaler global đã lo
      icon: icon * f,
      spinner: spinner * f,
      gap: gap * f,
      heightText: heightText * f,
      minWidthText: minWidthText * f,
      hPadText: hPadText * f,
    );
  }

  static _Dims of(BuildContext context, AppButtonSize s) {
    final size = MediaQuery.sizeOf(context);
    final shortest = size.shortestSide;

    double factor;
    if (shortest < 340) {
      factor = 0.85; // rất hẹp
    } else if (shortest < 380) {
      factor = 0.9; // hơi hẹp
    } else {
      factor = 1.0; // bình thường trở lên
    }

    _Dims base;
    switch (s) {
      case AppButtonSize.xs:
        base = const _Dims(
          height: 28,
          minWidth: 56,
          hPad: 10,
          font: 12,
          icon: 16,
          spinner: 14,
          gap: 6,
          heightText: 24,
          minWidthText: 40,
          hPadText: 6,
        );
        break;
      case AppButtonSize.sm:
        base = const _Dims(
          height: 36,
          minWidth: 64,
          hPad: 12,
          font: 13,
          icon: 18,
          spinner: 16,
          gap: 8,
          heightText: 28,
          minWidthText: 48,
          hPadText: 8,
        );
        break;
      case AppButtonSize.lg:
        base = const _Dims(
          height: 52,
          minWidth: 72,
          hPad: 16,
          font: 16,
          icon: 20,
          spinner: 18,
          gap: 10,
          heightText: 40,
          minWidthText: 56,
          hPadText: 10,
        );
        break;
      case AppButtonSize.md:
        base = const _Dims(
          height: 44,
          minWidth: 64,
          hPad: 14,
          font: 14,
          icon: 18,
          spinner: 16,
          gap: 8,
          heightText: 32,
          minWidthText: 52,
          hPadText: 8,
        );
        break;
    }

    return base.scale(factor);
  }
}
