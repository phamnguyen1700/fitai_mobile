// lib/features/profile/presentation/widgets/achievement_summary_card.dart
import 'package:flutter/material.dart';
import '../../../process/data/models/achievement_models.dart';

class AchievementSummaryCard extends StatelessWidget {
  final AchievementSummary? summary;

  const AchievementSummaryCard({super.key, required this.summary});

  bool get _hasData {
    final s = summary;
    if (s == null) return false;
    return s.workoutPlanPercent != null || s.mealPlanPercent != null;
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final hasData = _hasData;
    final s = summary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        // ===== CARD WITH BACKGROUND IMAGE (luôn hiển thị) =====
        Container(
          height: 140,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: const DecorationImage(
              image: AssetImage('lib/core/assets/images/achivement.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              // ==== overlay gradient để đọc chữ dễ hơn ====
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withOpacity(0.50),
                      Colors.black.withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              // ==== CONTENT ====
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    // LEFT CONTENT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Thành tích đạt được",
                            style: tt.titleSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 10),

                          if (hasData && s != null)
                            ..._buildBulletLines(context, s)
                          else
                            Text(
                              "Khi bạn duy trì kế hoạch tập luyện và dinh dưỡng, "
                              "những cột mốc thành tích của bạn sẽ xuất hiện tại đây.",
                              style: tt.bodySmall?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                height: 1.3,
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.22),
                      ),
                      child: const Icon(
                        Icons.emoji_events_rounded,
                        color: Color(
                          0xFFFFD54F,
                        ), // vàng pastel đẹp hơn pure yellow
                        size: 44,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildBulletLines(BuildContext context, AchievementSummary s) {
    final tt = Theme.of(context).textTheme;

    final lines = <String>[];

    if (s.workoutPlanPercent != null) {
      lines.add(
        "${s.workoutPlanPercent!.toStringAsFixed(0)}% buổi tập được hoàn thành",
      );
    }
    if (s.mealPlanPercent != null) {
      lines.add(
        "${s.mealPlanPercent!.toStringAsFixed(0)}% bữa ăn bám sát thực đơn",
      );
    }

    // milestone phụ — tùy rule của em
    if (s.workoutPlanPercent != null && s.workoutPlanPercent! >= 100) {
      lines.add("3 tuần liên tiếp cập nhật tiến độ");
    }

    return lines
        .map(
          (text) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Text(
                    "•",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    text,
                    style: tt.bodySmall?.copyWith(
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }
}
