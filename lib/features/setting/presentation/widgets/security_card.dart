// lib/features/setting/presentation/widgets/security_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitai_mobile/core/utils/validation.dart';
import '../../../auth/presentation/viewmodels/auth_providers.dart';

class SecurityCard extends ConsumerStatefulWidget {
  final String maskedPassword;

  const SecurityCard({super.key, required this.maskedPassword});

  @override
  ConsumerState<SecurityCard> createState() => _SecurityCardState();
}

class _SecurityCardState extends ConsumerState<SecurityCard> {
  final _formKey = GlobalKey<FormState>();

  bool isEditing = false;
  bool isLoading = false;
  String? errorMsg;

  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _currentCtrl.text = widget.maskedPassword;
  }

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    // chỉ validate khi bấm Lưu
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final currentPw = _currentCtrl.text.trim();
    final newPw = _newCtrl.text.trim();

    setState(() {
      isLoading = true;
      errorMsg = null;
    });

    final ok = await ref
        .read(authNotifierProvider.notifier)
        .changePassword(currentPassword: currentPw, newPassword: newPw);

    setState(() => isLoading = false);

    if (ok) {
      if (!mounted) return;

      setState(() {
        isEditing = false;
        _currentCtrl.text = widget.maskedPassword;
        _newCtrl.clear();
        _confirmCtrl.clear();
        errorMsg = null;
        _obscureCurrent = true;
        _obscureNew = true;
        _obscureConfirm = true;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đổi mật khẩu thành công!')));
    } else {
      final err =
          ref.read(authErrorProvider) ??
          'Đổi mật khẩu thất bại. Vui lòng thử lại.';
      setState(() => errorMsg = err);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final cs = theme.colorScheme;
    final inputTheme = theme.inputDecorationTheme;

    InputDecoration baseDecoration(String label, {String? hint}) {
      return const InputDecoration().copyWith(
        labelText: label,
        hintText: hint,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        suffixIconColor: inputTheme.suffixIconColor ?? cs.onSurfaceVariant,
      );
    }

    Widget passwordField({
      required String label,
      required TextEditingController controller,
      required bool enabled,
      required bool obscure,
      required VoidCallback onToggleObscure,
      String? hint,
      FormFieldValidator<String>? validator,
    }) {
      return TextFormField(
        controller: controller,
        obscureText: obscure,
        readOnly: !enabled,
        enabled: enabled,
        style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        validator: validator,
        onTap: () {
          if (errorMsg != null) {
            setState(() => errorMsg = null);
          }
        },
        onChanged: (_) {
          if (errorMsg != null) {
            setState(() => errorMsg = null);
          }
        },
        decoration: baseDecoration(label, hint: hint).copyWith(
          suffixIcon: IconButton(
            iconSize: 18,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: onToggleObscure,
          ),
        ),
      );
    }

    return Form(
      key: _formKey,
      autovalidateMode:
          AutovalidateMode.disabled, // 🔴 không tự validate khi mới mở form nữa
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mật khẩu hiện tại
          passwordField(
            label: 'Mật khẩu hiện tại',
            controller: _currentCtrl,
            enabled: isEditing,
            obscure: _obscureCurrent,
            onToggleObscure: () {
              setState(() => _obscureCurrent = !_obscureCurrent);
            },
            validator: (value) {
              if (!isEditing) return null;
              if (value == null || value.trim().isEmpty) {
                return 'Vui lòng nhập mật khẩu hiện tại.';
              }
              return null;
            },
          ),

          if (isEditing) ...[
            const SizedBox(height: 12),
            passwordField(
              label: 'Mật khẩu mới',
              controller: _newCtrl,
              enabled: true,
              obscure: _obscureNew,
              hint: 'Nhập mật khẩu mới',
              onToggleObscure: () {
                setState(() => _obscureNew = !_obscureNew);
              },
              validator: (value) {
                final baseValidator = V.password();
                final baseError = baseValidator(value);
                if (baseError != null) return baseError;

                final current = _currentCtrl.text.trim();
                final newPw = (value ?? '').trim();
                if (current.isNotEmpty && newPw == current) {
                  return 'Mật khẩu mới phải khác mật khẩu hiện tại.';
                }

                return null;
              },
            ),
            const SizedBox(height: 12),
            // Nhập lại mật khẩu mới
            passwordField(
              label: 'Nhập lại mật khẩu mới',
              controller: _confirmCtrl,
              enabled: true,
              obscure: _obscureConfirm,
              hint: 'Nhập lại mật khẩu mới',
              onToggleObscure: () {
                setState(() => _obscureConfirm = !_obscureConfirm);
              },
              validator: V.confirm(_newCtrl),
            ),

            if (errorMsg != null) ...[
              const SizedBox(height: 8),
              Text(errorMsg!, style: TextStyle(color: cs.error, fontSize: 13)),
            ],
          ],

          const SizedBox(height: 12),

          if (!isEditing)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    isEditing = true;
                    errorMsg = null;
                    _currentCtrl.clear();
                    _newCtrl.clear();
                    _confirmCtrl.clear();
                    _obscureCurrent = true;
                    _obscureNew = true;
                    _obscureConfirm = true;
                  });
                },
                child: const Text('Thay đổi mật khẩu'),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            setState(() {
                              isEditing = false;
                              errorMsg = null;
                              _currentCtrl.text = widget.maskedPassword;
                              _newCtrl.clear();
                              _confirmCtrl.clear();
                              _obscureCurrent = true;
                              _obscureNew = true;
                              _obscureConfirm = true;
                            });
                          },
                    child: const Text('Hủy'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: isLoading ? null : _onSubmit,
                    child: isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Lưu mật khẩu'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
