import 'package:flutter/material.dart';
import 'package:fitai_mobile/core/widgets/app_text_field.dart';
import 'package:fitai_mobile/core/widgets/app_icons.dart';
import 'package:flutter/scheduler.dart';

class Otp extends StatefulWidget {
  final void Function(String code)? onCompleted;
  final VoidCallback? onResend;
  final int length;
  final int seconds;

  const Otp({
    super.key,
    this.onCompleted,
    this.onResend,
    this.length = 6,
    this.seconds = 45,
  });

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> with SingleTickerProviderStateMixin {
  late final List<TextEditingController> _ctl = List.generate(
    widget.length,
    (_) => TextEditingController(),
  );
  late final List<FocusNode> _nodes = List.generate(
    widget.length,
    (_) => FocusNode(),
  );
  late final Ticker _ticker;
  late int _remain;

  @override
  void initState() {
    super.initState();
    _remain = widget.seconds;
    _ticker = createTicker((elapsed) {
      final left = widget.seconds - elapsed.inSeconds;
      if (!mounted) return;
      if (left <= 0) {
        setState(() => _remain = 0);
        _ticker.stop();
      } else {
        setState(() => _remain = left);
      }
    })..start();
  }

  @override
  void dispose() {
    for (final c in _ctl) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    _ticker.dispose();
    super.dispose();
  }

  void _onChanged(int i, String v) {
    if (v.isNotEmpty && i < widget.length - 1) _nodes[i + 1].requestFocus();
    if (_ctl.every((c) => c.text.isNotEmpty)) {
      widget.onCompleted?.call(_ctl.map((c) => c.text).join());
    }
  }

  void _resend() {
    setState(() => _remain = widget.seconds);
    _ticker.stop();
    _ticker.start();
    widget.onResend?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(color: cs.surface),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- Icon mail lớn ---
              // --- Icon Gmail lớn ---
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white, // nền phẳng, không gradient nữa
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      offset: const Offset(2, 2),
                    ),
                  ],

                  border: Border.all(
                    width: 1.6,
                    color: cs.outlineVariant.withValues(alpha: 0.25),
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'lib/core/assets/images/logo_gmail.png',
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Text(
                'Xác thực tài khoản',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Enter code that we have sent to your email your...@gmail.com',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 10),

              // --- Các ô nhập OTP ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.length, (i) {
                  return SizedBox(
                    width: 56,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: AppTextField(
                        controller: _ctl[i],
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        onChanged: (v) => _onChanged(i, v),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 10),
              Text(
                '00:${_remain.toString().padLeft(2, "0")}s còn lại.',
                style: TextStyle(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 10),

              // --- Gửi lại mã ---
              if (_remain == 0)
                GestureDetector(
                  onTap: _resend,
                  child: Text(
                    'Gửi lại mã',
                    style: TextStyle(
                      color: cs.primary,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              else
                const SizedBox.shrink(), // ẩn hẳn, không chiếm chỗ
            ],
          ),
        ),
      ],
    );
  }
}
