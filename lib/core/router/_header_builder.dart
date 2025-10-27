// lib/core/router/_header_builder.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/user_header_appbar.dart';

PreferredSizeWidget? buildUserHeaderFor(WidgetRef ref, String path) {
  if (path != '/workout' && path != '/meal' && path != '/progress') return null;

  // dữ liệu tạm
  const displayName = 'Thảo Vi';
  const avatarUrl = 'https://i.pravatar.cc/150?img=5';
  const message = 'Chào Vi 👋, hôm nay bạn có 3 bài tập và 4 bữa ăn.';
  const welcome = 'Welcome';
  const headerH = 100.0;

  return UserHeaderAppBar(
    showBack: false,
    header: PreferredSize(
      preferredSize: const Size.fromHeight(headerH),
      child: Container(
        height: headerH,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(avatarUrl),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Builder(
                builder: (context) {
                  final t = Theme.of(context).textTheme;
                  return DefaultTextStyle(
                    style: t.bodyMedium ?? const TextStyle(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(welcome, style: t.labelMedium),
                        const SizedBox(height: 2),
                        Text(
                          displayName,
                          style: t.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          message,
                          style: t.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
