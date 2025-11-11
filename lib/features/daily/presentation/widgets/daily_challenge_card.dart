import 'package:flutter/material.dart';

class DailyChallengeCard extends StatelessWidget {
  const DailyChallengeCard({
    super.key,
    this.title = 'Daily challenge',
    required this.deadline,
    this.subtitlePrefix = 'Do your plan before',
    this.participants = const [],
    this.totalParticipants,
    this.maxAvatars = 3,
    this.onTap,
    this.illustration, // ảnh nền
    this.height = 120,
  });

  final String title;
  final TimeOfDay deadline;
  final String subtitlePrefix;
  final List<ImageProvider> participants;
  final int? totalParticipants;
  final int maxAvatars;
  final VoidCallback? onTap;
  final ImageProvider? illustration;
  final double height;

  String _formatTime(BuildContext context, TimeOfDay t) {
    final materialLocalizations = MaterialLocalizations.of(context);
    return materialLocalizations.formatTimeOfDay(
      t,
      alwaysUse24HourFormat: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        clipBehavior: Clip.antiAlias, // ✅ cắt tràn
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [Color(0xFF0A2540), Color(0xFF0E3D7A)]
                : const [Color(0xFF0E3A68), Color(0xFF0F5AA6)],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ---- Ảnh nền ----
            if (illustration != null)
              Image(image: illustration!, fit: BoxFit.cover),

            // ---- Overlay gradient mờ để dễ đọc chữ ----
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.1),
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
            ),

            // ---- Nội dung ----
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '$subtitlePrefix ${_formatTime(context, deadline)}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.white.withOpacity(0.85)),
                        ),
                        const Spacer(),
                        _AvatarStack(
                          images: participants.take(maxAvatars).toList(),
                          extraCount: totalParticipants != null
                              ? (totalParticipants! - participants.length)
                                    .clamp(0, 999)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarStack extends StatelessWidget {
  const _AvatarStack({required this.images, this.extraCount});
  final List<ImageProvider> images;
  final int? extraCount;

  @override
  Widget build(BuildContext context) {
    const double size = 24;
    const double overlap = 14;

    final items = <Widget>[];
    for (int i = 0; i < images.length; i++) {
      items.add(
        Positioned(
          left: i * overlap,
          child: CircleAvatar(
            radius: size / 2,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: (size - 3) / 2,
              backgroundImage: images[i],
            ),
          ),
        ),
      );
    }

    if (extraCount != null && extraCount! > 0) {
      final i = images.length;
      items.add(
        Positioned(
          left: i * overlap,
          child: CircleAvatar(
            radius: size / 2,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: (size - 3) / 2,
              backgroundColor: Colors.black.withOpacity(0.6),
              child: Text(
                '+$extraCount',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      );
    }

    final width =
        (images.length + ((extraCount != null && extraCount! > 0) ? 1 : 0)) *
            overlap +
        size;

    return SizedBox(
      width: width.toDouble(),
      height: size,
      child: Stack(children: items),
    );
  }
}
