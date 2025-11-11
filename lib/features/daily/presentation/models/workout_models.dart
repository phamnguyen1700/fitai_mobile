class WorkoutPlanBlock {
  WorkoutPlanBlock({
    required this.title,
    required this.leftStat,
    required this.rightStat,
    required this.progress,
    required this.calories,
    required this.levels,
    required this.videoTitle,
    required this.videoThumb,
    this.checked = false,
    this.selectedLevelIndex = 0,
  });

  final String title;
  final String leftStat;
  final String rightStat;
  final double progress; // 0..1
  final int calories; // kcal
  final List<String> levels; // ["Người mới", ...]
  final String videoTitle;
  final String videoThumb;

  bool checked;
  int selectedLevelIndex;
}
