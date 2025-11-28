import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
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
    this.focusNode, // 👈 NEW
    this.inputFormatters, // 👈 NEW
    this.textAlignVertical,
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

  // 👇 thêm 2 tham số mới
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlignVertical? textAlignVertical;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
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
      textAlignVertical: widget.textAlignVertical,
      focusNode: widget.focusNode, // 👈 dùng focusNode
      inputFormatters: widget.inputFormatters, // 👈 dùng formatters
      decoration:
          InputDecoration(
            labelText: widget.label,
            hintText: widget.hintText,
            helperText: widget.helperText,
            errorText: widget.errorText,
            prefixIcon: widget.prefixIcon == null
                ? null
                : Icon(widget.prefixIcon),
            suffixIcon: widget.obscure
                ? IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : (widget.suffixIcon == null ? null : Icon(widget.suffixIcon)),
          ).copyWith(
            // giữ màu từ theme, chỉ fallback nếu null
            contentPadding: inputTheme.contentPadding,
            suffixIconColor: inputTheme.suffixIconColor ?? cs.onSurfaceVariant,
            prefixIconColor: inputTheme.prefixIconColor ?? cs.onSurfaceVariant,
          ),
    );
  }
}
