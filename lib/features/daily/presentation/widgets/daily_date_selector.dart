import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';

class DailyDateSelector extends StatelessWidget {
  const DailyDateSelector({
    super.key,
    required this.selectedDate,
    required this.onChanged,
    this.disabledDates,
    this.locale = 'vi',
    required this.firstDate,
    required this.lastDate,
  });

  final DateTime selectedDate;
  final DateTime firstDate; // ngày bắt đầu range
  final DateTime lastDate; // ngày kết thúc range
  final ValueChanged<DateTime> onChanged;
  final List<DateTime>? disabledDates;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return EasyInfiniteDateTimeLine(
      firstDate: firstDate,
      lastDate: lastDate,
      focusDate: selectedDate,
      disabledDates: disabledDates,
      locale: locale,
      activeColor: cs.primary,
      showTimelineHeader: false,

      timeLineProps: const EasyTimeLineProps(
        hPadding: 24,
        vPadding: 4,
        separatorPadding: 12,
        backgroundColor: Colors.transparent,
      ),

      dayProps: EasyDayProps(
        width: 64,
        height: 96,
        dayStructure: DayStructure.monthDayNumDayStr,
        borderColor: Colors.transparent,

        inactiveDayStyle: DayStyle(
          borderRadius: 8,
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          monthStrStyle: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.grey[400] : Colors.grey[700],
          ),
          dayNumStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.black87,
          ),
          dayStrStyle: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.grey[400] : Colors.grey[700],
          ),
        ),

        activeDayStyle: DayStyle(
          borderRadius: 8,
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          monthStrStyle: const TextStyle(fontSize: 11, color: Colors.white),
          dayNumStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          dayStrStyle: const TextStyle(fontSize: 12, color: Colors.white),
        ),

        todayStyle: DayStyle(
          borderRadius: 8,
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: cs.primary.withOpacity(0.15),
                blurRadius: 0,
                spreadRadius: 2,
              ),
            ],
          ),
          monthStrStyle: TextStyle(
            fontSize: 11,
            color: cs.primary,
            fontWeight: FontWeight.w600,
          ),
          dayNumStyle: TextStyle(
            fontSize: 16,
            color: cs.primary,
            fontWeight: FontWeight.w700,
          ),
          dayStrStyle: TextStyle(fontSize: 12, color: cs.primary),
        ),
      ),

      onDateChange: onChanged,
    );
  }
}
