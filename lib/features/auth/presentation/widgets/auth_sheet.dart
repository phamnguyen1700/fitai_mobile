import 'package:flutter/material.dart';
import 'package:fitai_mobile/core/widgets/widgets.dart'; // AppButton, AppTextField, ...

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
    final cs = Theme.of(context).colorScheme;

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
class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
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
        const AppTextField(
          label: 'Email',
          prefixIcon: Icons.email_outlined,
          hintText: 'Nhập email',
        ),
        const SizedBox(height: 12),

        // Mật khẩu
        const AppTextField(
          label: 'Mật khẩu',
          prefixIcon: Icons.lock_outline,
          hintText: 'Nhập mật khẩu',
          obscure: true,
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
          onPressed: () {},
        ),
      ],
    );
  }
}

// === FORM ĐĂNG KÝ ===
class _RegisterForm extends StatelessWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Đăng ký',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 16),

        const AppTextField(
          label: 'Email',
          prefixIcon: Icons.email_outlined,
          hintText: 'Nhập email',
        ),
        const SizedBox(height: 12),

        const AppTextField(
          label: 'Mật khẩu',
          prefixIcon: Icons.lock_outline,
          hintText: 'Nhập mật khẩu',
          obscure: true,
        ),
        const SizedBox(height: 12),

        const AppTextField(
          label: 'Nhập lại mật khẩu',
          prefixIcon: Icons.lock_outline,
          hintText: 'Nhập lại mật khẩu',
          obscure: true,
        ),
        const SizedBox(height: 16),

        AppButton(
          label: 'Đăng ký',
          variant: AppButtonVariant.filled,
          fullWidth: true,
          onPressed: () {},
        ),
      ],
    );
  }
}
