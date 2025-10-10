import 'package:flutter/material.dart';

/// AppAvatar — vòng tròn, có ring theo primary, fallback ký tự đầu tên.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 40,
    this.showRing = true,
  });

  final String? imageUrl;
  final String? name;
  final double size;
  final bool showRing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final initials = (name?.trim().isNotEmpty ?? false)
        ? name!.trim()[0].toUpperCase()
        : 'U';

    final avatar = imageUrl == null || imageUrl!.isEmpty
        ? CircleAvatar(
            radius: size / 2,
            backgroundColor: cs.secondaryContainer,
            child: Text(
              initials,
              style: TextStyle(
                color: cs.onSecondaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        : CircleAvatar(
            radius: size / 2,
            backgroundImage: NetworkImage(imageUrl!),
            backgroundColor: cs.surfaceContainerHighest,
          );

    if (!showRing) return avatar;

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: cs.primary, width: 2),
      ),
      child: avatar,
    );
  }
}
