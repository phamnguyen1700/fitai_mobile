import 'package:flutter/material.dart';
import '../widgets/weekly_checkin_card.dart';

class ProcessScreen extends StatelessWidget {
  const ProcessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        WeeklyCheckInCard(
          title: 'Weekly Check-in (Tuần 3/12)',
          progress: 0.30,
          // onPickWeek: ... (để sau)
        ),
        SizedBox(height: 16),
        // ... các card khác (chart, lịch sử, badges, ...)
      ],
    );
  }
}
