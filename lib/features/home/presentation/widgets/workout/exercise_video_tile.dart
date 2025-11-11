// lib/features/ai/presentation/widgets/workout/exercise_video_tile.dart
import 'package:flutter/material.dart';

class ExerciseVideoTile extends StatelessWidget {
  final String title, thumbUrl;
  const ExerciseVideoTile({
    super.key,
    required this.title,
    required this.thumbUrl,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(thumbUrl, fit: BoxFit.cover),
                const Center(child: Icon(Icons.play_circle_outline, size: 56)),
              ],
            ),
          ),
          ListTile(title: Text(title)),
        ],
      ),
    ),
  );
}
