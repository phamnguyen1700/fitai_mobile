import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/gestures.dart';

class Otp extends StatefulWidget {
  final void Function(String code)? onCompleted;
  final VoidCallback? onResend;
  final void Function(String code)? onCodeChanged;
  final int length;
  final int seconds;

  const Otp({
    super.key,
    this.onCompleted,
    this.onResend,
    this.onCodeChanged,
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_nodes.isNotEmpty) _nodes.first.requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in _ctl) c.dispose();
    for (final n in _nodes) n.dispose();
    _ticker.dispose();
    super.dispose();
  }

  void _emitCurrentCode() {
    if (widget.onCodeChanged != null) {
      widget.onCodeChanged!.call(_ctl.map((c) => c.text).join());
    }
  }

  void _onChanged(int i, String v) {
    // nếu paste nhiều ký tự -> chỉ giữ ký tự cuối
    if (v.length > 1) {
      final last = v.characters.last;
      _ctl[i].text = last;
      _ctl[i].selection = TextSelection.fromPosition(
        TextPosition(offset: _ctl[i].text.length),
      );
      v = last;
    }

    // gõ 1 số -> nhảy sang ô sau
    if (v.isNotEmpty && i < widget.length - 1) {
      _nodes[i + 1].requestFocus();
      _ctl[i + 1].selection = TextSelection(
        baseOffset: 0,
        extentOffset: _ctl[i + 1].text.length,
      );
    }

    // backspace khi trống -> lùi về ô trước
    if (v.isEmpty && i > 0) {
      _nodes[i - 1].requestFocus();
      _ctl[i - 1]
        ..text = ''
        ..selection = const TextSelection(baseOffset: 0, extentOffset: 0);
    }

    _emitCurrentCode();

    // đủ mã -> callback
    if (_ctl.every((c) => c.text.isNotEmpty)) {
      final code = _ctl.map((c) => c.text).join();
      widget.onCompleted?.call(code);
    }
  }

  void _resend() {
    setState(() => _remain = widget.seconds);
    _ticker
      ..stop()
      ..start();
    widget.onResend?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final size = MediaQuery.sizeOf(context);
    final shortest = size.shortestSide;
    final isCompact = shortest < 380;

    // kích thước “đẹp” mặc định
    // base sizes rồi sẽ scale theo width thực tế
    final double baseBoxWidth = isCompact ? 52.0 : 64.0;
    final double boxHPad = isCompact ? 4.0 : 6.0;
    final double iconBoxSize = isCompact ? 70.0 : 80.0;
    final double iconSize = isCompact ? 40.0 : 48.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: isCompact ? 16 : 24),

        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 8 : 10,
            vertical: isCompact ? 10 : 12,
          ),
          decoration: BoxDecoration(color: cs.surface),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // icon Gmail
              Container(
                width: iconBoxSize,
                height: iconBoxSize,
                decoration: BoxDecoration(
                  color: Colors.white,
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
                    width: iconSize,
                    height: iconSize,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(height: isCompact ? 16 : 20),

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

              SizedBox(height: isCompact ? 8 : 10),

              LayoutBuilder(
                builder: (context, constraints) {
                  final availableWidth = constraints.maxWidth;
                  final totalSpacing = (widget.length * 2) * boxHPad;

                  double finalBoxWidth = baseBoxWidth;
                  final totalNeeded =
                      widget.length * baseBoxWidth + totalSpacing;

                  if (totalNeeded > availableWidth) {
                    final adjusted =
                        (availableWidth - totalSpacing) / widget.length;
                    finalBoxWidth = adjusted.clamp(40.0, baseBoxWidth);
                  }

                  final boxFontSize = (finalBoxWidth * 0.4).clamp(
                    16.0,
                    isCompact ? 20.0 : 22.0,
                  );

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(widget.length, (i) {
                      return SizedBox(
                        width: finalBoxWidth,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: boxHPad),
                          child: Focus(
                            onKeyEvent: (node, event) {
                              if (event is KeyDownEvent &&
                                  event.logicalKey ==
                                      LogicalKeyboardKey.backspace &&
                                  _ctl[i].text.isEmpty &&
                                  i > 0) {
                                _nodes[i - 1].requestFocus();
                                _ctl[i - 1]
                                  ..text = ''
                                  ..selection = const TextSelection(
                                    baseOffset: 0,
                                    extentOffset: 0,
                                  );
                                return KeyEventResult.handled;
                              }
                              return KeyEventResult.ignored;
                            },
                            child: TextField(
                              controller: _ctl[i],
                              focusNode: _nodes[i],
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: boxFontSize,
                              ),
                              cursorColor: cs.primary,
                              decoration: InputDecoration(
                                counterText: '',
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: finalBoxWidth * 0.25,
                                ),
                                filled: true,
                                fillColor: cs.surfaceVariant.withValues(
                                  alpha: 0.8,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: cs.outlineVariant.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: cs.primary,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: cs.outlineVariant.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(1),
                              ],
                              onChanged: (v) => _onChanged(i, v),
                              onSubmitted: (_) {
                                if (i > 0 && _ctl[i].text.isEmpty) {
                                  _nodes[i - 1].requestFocus();
                                }
                              },
                              onEditingComplete: () {
                                if (_ctl[i].text.isEmpty && i > 0) {
                                  _nodes[i - 1].requestFocus();
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),

              SizedBox(height: isCompact ? 8 : 10),

              Text(
                '00:${_remain.toString().padLeft(2, "0")}s còn lại.',
                style: TextStyle(color: cs.onSurfaceVariant),
              ),

              SizedBox(height: isCompact ? 8 : 10),

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
                const SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }
}
