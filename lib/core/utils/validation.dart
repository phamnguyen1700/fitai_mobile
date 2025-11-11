import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart' as fv;

/// Bộ validator dùng lại toàn app.
/// Dùng như:
///   validator: V.email()
///   validator: V.password()
///   validator: V.required('Nhập tên')
///   validator: V.confirm(_passCtl)
class V {
  /// Bắt buộc nhập
  static fv.FormFieldValidator<String> required([
    String message = 'Vui lòng nhập thông tin',
  ]) => fv.RequiredValidator(errorText: message).call;

  /// Email chuẩn + required
  static fv.FormFieldValidator<String> email({
    String? requiredMsg,
    String? invalidMsg,
  }) => fv.MultiValidator([
    fv.RequiredValidator(errorText: requiredMsg ?? 'Vui lòng nhập Email'),
    fv.EmailValidator(errorText: invalidMsg ?? 'Email không hợp lệ'),
  ]).call;

  /// Mật khẩu: >= 6 ký tự, có chữ cái, số và ký tự đặc biệt
  static fv.FormFieldValidator<String> password({
    int min = 6,
    String? lengthMsg,
    String? letterMsg,
    String? numberMsg,
    String? specialMsg,
  }) => fv.MultiValidator([
    fv.RequiredValidator(errorText: 'Vui lòng nhập mật khẩu'),
    fv.MinLengthValidator(min, errorText: lengthMsg ?? 'Tối thiểu $min ký tự'),
    fv.PatternValidator(r'[A-Za-z]', errorText: letterMsg ?? 'Phải có chữ cái'),
    fv.PatternValidator(r'\d', errorText: numberMsg ?? 'Phải có số'),
    fv.PatternValidator(
      r'[!@#\$%\^&\*\(\)_\+\-=\[\]{};:"\\|,.<>\/\?]',
      errorText: specialMsg ?? 'Phải có ký tự đặc biệt',
    ),
  ]).call;

  /// Xác nhận khớp với mật khẩu gốc
  static fv.FormFieldValidator<String> confirm(
    TextEditingController target, {
    String message = 'Không khớp với mật khẩu',
  }) =>
      (val) => fv.MatchValidator(
        errorText: message,
      ).validateMatch(val ?? '', target.text);

  /// Số điện thoại VN đơn giản
  static fv.FormFieldValidator<String> phoneVN() => fv.MultiValidator([
    fv.RequiredValidator(errorText: 'Vui lòng nhập số điện thoại'),
    fv.PatternValidator(
      r'^(0|\+84)[0-9]{9,10}$',
      errorText: 'Số điện thoại không hợp lệ',
    ),
  ]).call;
}
