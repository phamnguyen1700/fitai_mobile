import 'package:flutter/material.dart';
import 'package:fitai_mobile/core/widgets/widgets.dart'; // AppButton, AppTextField, ...
import 'package:form_field_validator/form_field_validator.dart';

class AuthBottomSheet {
  static void show(BuildContext context) {
    AppBottomSheet.show(
      context,
      maxWidth: 480,
      builder: (ctx) => const _AuthSheetContent(),
    );
  }
}

class _AuthSheetContent extends StatefulWidget {
  const _AuthSheetContent();

  @override
  State<_AuthSheetContent> createState() => _AuthSheetContentState();
}

class _AuthSheetContentState extends State<_AuthSheetContent>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 2,
    vsync: this,
  );

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tabs: Đăng nhập / Đăng ký
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Đăng nhập'),
                Tab(text: 'Đăng ký'),
              ],
            ),
            const SizedBox(height: 16),

            // Nội dung form
            SizedBox(
              height: 360,
              child: TabBarView(
                controller: _tabController,
                children: const [_LoginForm(), _RegisterForm()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// === FORM ĐĂNG NHẬP ===
class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();

  @override
  void dispose() {
    _emailCtl.dispose();
    _passCtl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: call API
      debugPrint('LOGIN email=${_emailCtl.text} pass=${_passCtl.text}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Validate OK — tiến hành đăng nhập')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Đăng nhập',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 16),

          // Email
          AppTextField(
            controller: _emailCtl,

            label: 'Email',
            prefixIcon: Icons.email_outlined,
            hintText: 'Nhập email',
            validator: MultiValidator([
              RequiredValidator(errorText: 'Vui lòng nhập Email'),
              EmailValidator(errorText: 'Email không hợp lệ'),
            ]).call,
          ),
          const SizedBox(height: 12),

          // Mật khẩu
          AppTextField(
            controller: _passCtl,
            label: 'Mật khẩu',
            prefixIcon: Icons.lock_outline,
            hintText: 'Nhập mật khẩu',
            obscure: true,
            validator: RequiredValidator(
              errorText: 'Vui lòng nhập mật khẩu',
            ).call,
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(value: false, onChanged: (_) {}),
                  Text(
                    'Ghi nhớ đăng nhập',
                    style: TextStyle(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
              TextButton(onPressed: () {}, child: const Text('Quên mật khẩu')),
            ],
          ),

          const SizedBox(height: 16),

          AppButton(
            label: 'Đăng nhập',
            variant: AppButtonVariant.filled,
            fullWidth: true,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

// === FORM ĐĂNG KÝ ===
class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  final _confirmCtl = TextEditingController();

  @override
  void dispose() {
    _emailCtl.dispose();
    _passCtl.dispose();
    _confirmCtl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: call API
      debugPrint(
        'REGISTER email=${_emailCtl.text} pass=${_passCtl.text} confirm=${_confirmCtl.text}',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Validate OK — tiến hành đăng ký')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Đăng ký',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 16),

          AppTextField(
            controller: _emailCtl,
            label: 'Email',
            prefixIcon: Icons.email_outlined,
            hintText: 'Nhập email',
            validator: MultiValidator([
              RequiredValidator(errorText: 'Vui lòng nhập Email'),
              EmailValidator(errorText: 'Email không hợp lệ'),
            ]).call,
          ),
          const SizedBox(height: 12),

          AppTextField(
            controller: _passCtl,
            label: 'Mật khẩu',
            prefixIcon: Icons.lock_outline,
            hintText: 'Nhập mật khẩu',
            obscure: true,
            validator: RequiredValidator(
              errorText: 'Vui lòng nhập mật khẩu',
            ).call,
          ),
          Text(
            '6 ký tự trở lên bao gồm chữ cái, số và ký tự đặc biệt.',
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 12),

          AppTextField(
            controller: _confirmCtl,
            label: 'Nhập lại mật khẩu',
            prefixIcon: Icons.lock_outline,
            hintText: 'Nhập lại mật khẩu',
            obscure: true,
            validator: RequiredValidator(
              errorText: 'Vui lòng nhập lại mật khẩu',
            ).call,
          ),
          const SizedBox(height: 16),

          AppButton(
            label: 'Đăng ký',
            variant: AppButtonVariant.filled,
            fullWidth: true,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
