import 'package:flutter/material.dart';
import '../../data/models/progress_item.dart';

class DailyProgressCard extends StatefulWidget {
  const DailyProgressCard({
    super.key,
    this.title = 'Daily Progress',
    required this.workoutItems,
    required this.mealItems,
    this.activeColor,
    this.onToggle,
  });

  final String title;
  final List<ProgressItem> workoutItems;
  final List<ProgressItem> mealItems;
  final Color? activeColor;
  final void Function(int tab, int index, bool checked)? onToggle;

  @override
  State<DailyProgressCard> createState() => _DailyProgressCardState();
}

class _DailyProgressCardState extends State<DailyProgressCard>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final active = widget.activeColor ?? cs.primary;

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

            // Tabs: chữ cam + gạch dưới mảnh
            TabBar(
              controller: _tab,
              labelColor: active,
              unselectedLabelColor: cs.onSurfaceVariant,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: active, width: 2),
                insets: const EdgeInsets.symmetric(horizontal: 5),
              ),
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: 'Bài tập'),
                Tab(text: 'Bữa ăn'),
              ],
            ),

            // Giữ chiều cao cố định để dùng trong Sliver
            SizedBox(
              height: 140,
              child: TabBarView(
                controller: _tab,
                physics:
                    const NeverScrollableScrollPhysics(), // 👉 tắt kéo ngang đổi tab
                children: [
                  _ProgressList(
                    items: widget.workoutItems,
                    activeColor: active,
                    onChanged: (i, v) {
                      setState(() => widget.workoutItems[i].checked = v);
                      widget.onToggle?.call(0, i, v);
                    },
                  ),
                  _ProgressList(
                    items: widget.mealItems,
                    activeColor: active,
                    onChanged: (i, v) {
                      setState(() => widget.mealItems[i].checked = v);
                      widget.onToggle?.call(1, i, v);
                    },
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

class _ProgressList extends StatelessWidget {
  const _ProgressList({
    required this.items,
    required this.activeColor,
    required this.onChanged,
  });

  final List<ProgressItem> items;
  final Color activeColor;
  final void Function(int index, bool value) onChanged;

  @override
  Widget build(BuildContext context) {
    final dividerColor = Theme.of(context).dividerColor;

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 2),
      itemCount: items.length,
      shrinkWrap: true, // render đủ item trong chiều cao cho phép
      physics: const NeverScrollableScrollPhysics(), // 👉 tắt cuộn dọc
      separatorBuilder: (_, __) => Divider(height: 1, color: dividerColor),
      itemBuilder: (context, i) {
        final it = items[i];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          child: Row(
            children: [
              // Checkbox nhỏ bên trái
              SizedBox(
                width: 28,
                child: Checkbox(
                  value: it.checked,
                  onChanged: (v) => onChanged(i, v ?? false),
                  activeColor: activeColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: const VisualDensity(
                    horizontal: -4,
                    vertical: -4,
                  ),
                ),
              ),

              // Tiêu đề
              Expanded(
                child: Text(
                  it.title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),

              // Progress ở cuối dòng
              Text(
                _progressText(it),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _progressText(ProgressItem it) {
    // ví dụ: 5/5 bài, 1/2 bài, 1.5/2L, 7/8 giờ
    final unit = it.unit.isEmpty ? '' : ' ${it.unit}';
    return '${it.done}/${it.total}$unit';
  }
}
