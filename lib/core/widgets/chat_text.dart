import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatText extends StatefulWidget {
  const ChatText({
    super.key,
    this.controller,
    this.initialValue,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.obscure = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.onChanged,
    this.validator,
    this.onSubmitted,
    this.textAlign,
    this.focusNode,
    this.inputFormatters,
    // 👇 mới
    this.borderless = false,
    this.contentPadding,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscure;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onSubmitted;
  final TextAlign? textAlign;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;

  /// Nếu `true` thì bỏ hết viền (dùng cho chat input / pill)
  final bool borderless;

  /// Cho phép custom contentPadding (độ cao ô nhập)
  final EdgeInsetsGeometry? contentPadding;

  @override
  State<ChatText> createState() => _ChatTextState();
}

class _ChatTextState extends State<ChatText> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final inputTheme = theme.inputDecorationTheme;

    final borderRadius = BorderRadius.circular(16);

    OutlineInputBorder _outline(Color color, {double width = 1}) {
      return OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: color, width: width),
      );
    }

    final baseDecoration = InputDecoration(
      labelText: widget.label,
      hintText: widget.hintText,
      helperText: widget.helperText,
      errorText: widget.errorText,
      prefixIcon: widget.prefixIcon == null ? null : Icon(widget.prefixIcon),
      suffixIcon: widget.obscure
          ? IconButton(
              icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscure = !_obscure),
            )
          : (widget.suffixIcon == null ? null : Icon(widget.suffixIcon)),
    );

    // Nếu borderless → bỏ hết viền, dùng padding custom
    final decoration = widget.borderless
        ? baseDecoration.copyWith(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            filled: true,
            fillColor: inputTheme.fillColor ?? cs.surfaceContainerHighest,
            contentPadding:
                widget.contentPadding ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            prefixIconColor: inputTheme.prefixIconColor ?? cs.onSurfaceVariant,
            suffixIconColor: inputTheme.suffixIconColor ?? cs.onSurfaceVariant,
          )
        : baseDecoration.copyWith(
            contentPadding:
                widget.contentPadding ??
                inputTheme.contentPadding ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: inputTheme.border ?? _outline(cs.outlineVariant),
            enabledBorder:
                inputTheme.enabledBorder ?? _outline(cs.outlineVariant),
            focusedBorder:
                inputTheme.focusedBorder ?? _outline(cs.primary, width: 1.2),
            errorBorder: inputTheme.errorBorder ?? _outline(cs.error, width: 1),
            focusedErrorBorder:
                inputTheme.focusedErrorBorder ?? _outline(cs.error, width: 1.2),
            prefixIconColor: inputTheme.prefixIconColor ?? cs.onSurfaceVariant,
            suffixIconColor: inputTheme.suffixIconColor ?? cs.onSurfaceVariant,
          );

    return TextFormField(
      controller: widget.controller,
      initialValue: widget.controller == null ? widget.initialValue : null,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      maxLines: widget.obscure ? 1 : widget.maxLines,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: _obscure,
      onChanged: widget.onChanged,
      validator: widget.validator,
      onFieldSubmitted: widget.onSubmitted,
      textAlign: widget.textAlign ?? TextAlign.start,
      focusNode: widget.focusNode,
      inputFormatters: widget.inputFormatters,
      style: TextStyle(color: cs.onSurface),
      decoration: decoration,
    );
  }
}
