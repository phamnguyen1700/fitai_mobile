import 'package:flutter/material.dart';
import 'chat_text.dart';

class AppChatInputBar extends StatefulWidget {
  const AppChatInputBar({super.key, required this.onSend});

  final ValueChanged<String> onSend;

  @override
  State<AppChatInputBar> createState() => _AppChatInputBarState();
}

class _AppChatInputBarState extends State<AppChatInputBar> {
  final TextEditingController _controller = TextEditingController();

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompact = constraints.maxWidth < 360;

        final double pillRadius = 999;
        final double verticalPad = isCompact ? 2 : 4;
        final double horizontalPad = isCompact ? 10 : 14;
        final double sendButtonSize = isCompact ? 28 : 32;

        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
          child: Container(
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(pillRadius),
              border: Border.all(color: cs.surfaceContainerHigh),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPad,
              vertical: verticalPad,
            ),
            child: Row(
              children: [
                // ======== INPUT FIELD ========
                Expanded(
                  child: ChatText(
                    controller: _controller,
                    hintText: 'Nhập tin nhắn…',
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _handleSend(),
                    borderless: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0,
                    ),
                  ),
                ),

                // ======== SEND BUTTON ========
                GestureDetector(
                  onTap: _handleSend,
                  child: Container(
                    width: sendButtonSize,
                    height: sendButtonSize,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.send_rounded,
                      size: isCompact ? 18 : 20,
                      color: cs.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
