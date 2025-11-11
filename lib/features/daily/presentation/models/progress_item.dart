class ProgressItem {
  final String title;
  final int done;
  final int total;
  final String unit; // ví dụ: 'bài', 'món', 'L', 'giờ'
  final bool
  isMetric; // true nếu là đơn vị đo lường (L, giờ) -> chỉ để bạn tùy biến UI nếu cần
  bool checked;

  ProgressItem({
    required this.title,
    required this.done,
    required this.total,
    this.unit = 'bài',
    this.isMetric = false,
    this.checked = false,
  });
}
