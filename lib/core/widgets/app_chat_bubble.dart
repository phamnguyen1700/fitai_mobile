import 'package:flutter/material.dart';

class AppChatBubble extends StatelessWidget {
  const AppChatBubble({
    super.key,
    required this.text,
    required this.isMe,
    this.botAvatar,
  });

  final String text;
  final bool isMe;
  final String? botAvatar;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    const double avatarSize = 12;
    const double gap = 10;

    Widget botAvatarWidget() {
      return Padding(
        padding: const EdgeInsets.only(top: 2), // ⭐ canh top nhẹ
        child: CircleAvatar(
          radius: avatarSize,
          backgroundImage: botAvatar != null ? AssetImage(botAvatar!) : null,
          backgroundColor: cs.secondaryContainer,
          child: botAvatar == null
              ? Icon(
                  Icons.smart_toy_outlined,
                  size: 22,
                  color: cs.onSecondaryContainer,
                )
              : null,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth * 0.78;

        final bubbleColor = isMe
            ? cs.primary
            : (cs.brightness == Brightness.dark
                  ? const Color(0xFF2A2A2A)
                  : cs.surfaceContainerHigh);

        final textColor = isMe
            ? cs.onPrimary
            : (cs.brightness == Brightness.dark ? Colors.white : cs.onSurface);
        final bubble = Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            text,
            style: (t.bodyMedium ?? const TextStyle()).copyWith(
              color: textColor,
              height: 1.35,
              fontSize: 15,
            ),
          ),
        );

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: isMe
              ? [
                  // USER bubble (không avatar)
                  bubble,
                ]
              : [
                  // BOT bubble (avatar top-left)
                  botAvatarWidget(),
                  SizedBox(width: gap),
                  bubble,
                ],
        );
      },
    );
  }
}
