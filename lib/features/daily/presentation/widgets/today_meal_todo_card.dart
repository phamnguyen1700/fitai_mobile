import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fitai_mobile/features/daily/data/models/meal_plan_models.dart';
import 'package:image_picker/image_picker.dart';

class TodayMealPlan extends StatefulWidget {
  const TodayMealPlan({
    super.key,
    required this.day,
    this.shrinkWrap = false,
    this.physics,
  });

  final MealDayData day;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  @override
  State<TodayMealPlan> createState() => _TodayMealPlanState();
}

class _TodayMealPlanState extends State<TodayMealPlan> {
  static const double _minHeight = 150;

  late PageController _pageController;
  int _currentIndex = 0;

  // lưu chiều cao thực tế của từng card
  late List<double> _heights;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initHeights();
  }

  void _initHeights() {
    final len = widget.day.meals.length;
    _heights = List<double>.filled(len > 0 ? len : 1, 0);
  }

  @override
  void didUpdateWidget(covariant TodayMealPlan oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.day != widget.day) {
      _currentIndex = 0;
      _pageController.jumpToPage(0);
      _initHeights();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onCardSize(int index, Size size) {
    if (index >= _heights.length) return;
    final h = size.height;
    if (_heights[index] == h) return;

    setState(() {
      _heights[index] = h;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    final meals = widget.day.meals;

    // Không có bữa nào
    if (meals.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thực đơn hôm nay',
                style: t.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Chưa có thực đơn cho hôm nay.',
                  textAlign: TextAlign.center,
                  style: t.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // nếu chưa đo được thì dùng minHeight
    final currentHeight =
        (_currentIndex < _heights.length && _heights[_currentIndex] > 0)
        ? _heights[_currentIndex]
        : _minHeight;
    final double targetHeight = max(currentHeight, _minHeight).toDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🟧 TITLE
            Text(
              'Thực đơn hôm nay',
              style: t.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            // 🔹 Tổng quan (bar macro)
            _DailySummaryCard(day: widget.day),
            const SizedBox(height: 8),

            // 🔸 Đo chiều cao thật của từng thẻ (ẩn, không hiển thị)
            Offstage(
              offstage: true,
              child: Column(
                children: [
                  for (int i = 0; i < meals.length; i++)
                    MeasureSize(
                      onChange: (size) => _onCardSize(i, size),
                      child: _MealTodoCard(entry: meals[i]),
                    ),
                ],
              ),
            ),

            // 🔸 Các bữa ăn – cao đúng bằng nội dung đo được
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              height: targetHeight,
              child: PageView.builder(
                controller: _pageController,
                itemCount: meals.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  final entry = meals[index];
                  // KHÔNG dùng MeasureSize ở đây nữa
                  return _MealTodoCard(entry: entry);
                },
              ),
            ),

            const SizedBox(height: 12),

            // 🔹 dots indicator
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  meals.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentIndex == i ? 12 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _currentIndex == i
                          ? cs.primary
                          : cs.onSurfaceVariant.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailySummaryCard extends StatelessWidget {
  const _DailySummaryCard({required this.day});

  final MealDayData day;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    final carbs = day.totalCarbs.toDouble();
    final protein = day.totalProtein.toDouble();
    final fat = day.totalFat.toDouble();
    final kcal = day.totalCalories.toString();

    final totalMacro = carbs + protein + fat;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 20,
            child: totalMacro <= 0
                ? Container(
                    color: cs.outlineVariant.withOpacity(0.4),
                    alignment: Alignment.center,
                    child: Text(
                      'Chưa có dữ liệu macro',
                      style: t.labelSmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  )
                : Row(
                    children: [
                      if (carbs > 0)
                        Expanded(
                          flex: carbs.round(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            color: Colors.orangeAccent,
                            alignment: Alignment.center,
                            child: Text(
                              'Carb · ${carbs.toInt()}g',
                              style: t.labelSmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      if (protein > 0)
                        Expanded(
                          flex: protein.round(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            color: Colors.lightGreen,
                            alignment: Alignment.center,
                            child: Text(
                              'Protein · ${protein.toInt()}g',
                              style: t.labelSmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      if (fat > 0)
                        Expanded(
                          flex: fat.round(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            color: Colors.cyanAccent,
                            alignment: Alignment.center,
                            child: Text(
                              'Fat · ${fat.toInt()}g',
                              style: t.labelSmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ),

        const SizedBox(height: 8),

        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '$kcal kcal',
            style: t.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

/// Card từng bữa ăn (Breakfast / Lunch / Dinner...)
class _MealTodoCard extends StatelessWidget {
  const _MealTodoCard({required this.entry, this.onUploadPhoto});

  final MealEntry entry;

  /// callback upload ảnh – optional
  final Future<void> Function(MealEntry entry)? onUploadPhoto;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    final meal = entry.meal;
    final nutrition = meal.nutrition;
    final photoUrl = entry.photoUrl;
    final isCompleted = entry.isCompleted ?? false;

    final kcal = meal.calories.toString();
    final carbs = nutrition.carbs.toString();
    final protein = nutrition.protein.toString();
    final fat = nutrition.fat.toString();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Header =====
          Row(
            children: [
              Expanded(
                child: Text(
                  meal.type,
                  style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),

              // nếu đã hoàn thành → hiển thị tick
              if (isCompleted)
                Icon(Icons.check_circle, color: cs.primary, size: 18),
            ],
          ),
          const SizedBox(height: 6),

          // ===== Macro bữa ăn: C/P/F + kcal =====
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    _MacroDot(
                      color: Colors.orangeAccent,
                      label: 'Carb: $carbs g',
                      textStyle: t.bodySmall,
                    ),
                    _MacroDot(
                      color: Colors.lightGreenAccent,
                      label: 'Protein: $protein g',
                      textStyle: t.bodySmall,
                    ),
                    _MacroDot(
                      color: Colors.cyanAccent,
                      label: 'Fat: $fat g',
                      textStyle: t.bodySmall,
                    ),
                  ],
                ),
              ),
              _MacroDot(
                color: cs.primary,
                label: '$kcal kcal',
                textStyle: t.bodySmall,
              ),
            ],
          ),

          const SizedBox(height: 10),
          Divider(color: cs.outlineVariant, height: 16),

          // ===== Danh sách món ăn trong bữa =====
          _MealFoodsTable(foods: meal.foods),
          const SizedBox(height: 12),

          // ===== Nếu có ảnh → hiển thị ảnh =====
          if (photoUrl != null && photoUrl.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                photoUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
          ],

          // ===== Nếu chưa có ảnh → render nút upload =====
          if (photoUrl == null || photoUrl.isEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size.zero,
                ),
                onPressed: () async {
                  if (onUploadPhoto != null) {
                    await onUploadPhoto!(entry);
                    return;
                  }

                  // Default: pick image from gallery
                  final picker = ImagePicker();
                  final file = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 85,
                  );
                  if (file != null) {
                    debugPrint('[MealTodoCard] Picked image: ${file.path}');
                    // TODO: gọi repo upload meal photo
                  }
                },
                icon: Icon(
                  Icons.photo_camera_outlined,
                  size: 18,
                  color: cs.primary,
                ),
                label: Text(
                  'Tải ảnh bữa ăn',
                  style: t.bodySmall?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Bảng món ăn trong bữa
class _MealFoodsTable extends StatelessWidget {
  const _MealFoodsTable({required this.foods});

  final List<FoodItem> foods;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    if (foods.isEmpty) {
      return Text(
        'Chưa có món trong bữa này.',
        style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final food in foods)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                Expanded(child: Text(food.name, style: t.bodySmall)),
                Text(
                  food.quantity,
                  style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _MacroDot extends StatelessWidget {
  const _MacroDot({required this.color, required this.label, this.textStyle});

  final Color color;
  final String label;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: textStyle),
      ],
    );
  }
}

/// ===== Helper đo size child để set chiều cao đúng =====
typedef OnWidgetSizeChange = void Function(Size size);

class MeasureSize extends StatefulWidget {
  const MeasureSize({super.key, required this.onChange, required this.child});

  final OnWidgetSizeChange onChange;
  final Widget child;

  @override
  State<MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<MeasureSize> {
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ro = context.findRenderObject();
      if (ro is RenderBox) {
        final newSize = ro.size;
        if (_oldSize == null || _oldSize != newSize) {
          _oldSize = newSize;
          widget.onChange(newSize);
        }
      }
    });

    return widget.child;
  }
}
