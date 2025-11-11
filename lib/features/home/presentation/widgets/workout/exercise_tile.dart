// lib/features/ai/presentation/widgets/workout/exercise_tile.dart
import 'package:flutter/material.dart';
import 'workout_day_card.dart';

class ExerciseTile extends StatelessWidget {
  final ExerciseItem item;
  const ExerciseTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            item.thumbUrl,
            width: 120,
            height: 68,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(item.meta, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.play_circle_fill)),
      ],
    ),
  );
}
