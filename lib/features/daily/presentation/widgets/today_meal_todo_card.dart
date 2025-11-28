import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitai_mobile/core/widgets/onboarding_gate.dart';
import 'package:fitai_mobile/features/daily/data/models/meal_plan_models.dart';
import 'package:fitai_mobile/features/daily/data/repositories/meal_photo_repository.dart';
import 'package:fitai_mobile/features/daily/presentation/viewmodels/meal_plan_providers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fitai_mobile/features/daily/presentation/viewmodels/meal_comment_providers.dart';

class TodayMealPlan extends ConsumerStatefulWidget {
  const TodayMealPlan({
    super.key,
    required this.day,
    this.shrinkWrap = false,
    this.physics,
    this.onReload,
    this.onboardingStep,
    this.waitingReviewMessage,
  });

  final MealDayData day;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final VoidCallback? onReload;
  final String? onboardingStep;
  final String? waitingReviewMessage;

  @override
  ConsumerState<TodayMealPlan> createState() => _TodayMealPlanState();
}

class _TodayMealPlanState extends ConsumerState<TodayMealPlan> {
  static const double _minHeight = 150;

  late PageController _pageController;
  int _currentIndex = 0;

  /// Chiều cao thực tế cho từng meal (index theo PageView)
  List<double> _mealHeights = const [];

  List<MealEntry> _meals = const [];

  final _mealPhotoRepo = MealPhotoRepository();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _meals = List<MealEntry>.from(widget.day.meals);
    _initHeights();
  }

  void _initHeights() {
    final len = _meals.length;
    _mealHeights = List<double>.filled(len > 0 ? len : 1, 0);
    _currentIndex = 0;
  }

  /// callback đo size giống workout
  void _onMealSize(int index, Size size) {
    if (index >= _mealHeights.length) return;
    final h = size.height;
    if (_mealHeights[index] == h) return;

    setState(() {
      _mealHeights[index] = h;
    });
  }

  @override
  void didUpdateWidget(covariant TodayMealPlan oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.day != widget.day) {
      _meals = List<MealEntry>.from(widget.day.meals);
      _currentIndex = 0;
      _pageController.jumpToPage(0);
      _initHeights(); // ngày khác → tính lại chiều cao
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Upload ảnh + mark completed
  Future<void> _handleUploadPhoto(MealEntry entry) async {
    if (_isUploading) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (picked == null) return;

    setState(() => _isUploading = true);

    try {
      final file = File(picked.path);

      final res = await _mealPhotoRepo.uploadAndComplete(
        dayNumber: widget.day.dayNumber,
        mealType: entry.meal.type,
        photoFile: file,
      );

      debugPrint(
        '[TodayMealPlan] upload result: ${res.success} - ${res.message}',
      );

      if (res.success) {
        widget.onReload?.call();
        ref.invalidate(todayMealsProvider);
        final data = res.data;
        if (data != null) {
          final updated = List<MealEntry>.from(_meals);
          final idx = updated.indexWhere((m) => m.meal.type == entry.meal.type);
          if (idx >= 0) {
            updated[idx] = MealEntry(
              mealLogId: data.mealLogId,
              meal: updated[idx].meal,
              isCompleted: data.completed,
              photoUrl: data.photoUrl,
              advisorReview: updated[idx].advisorReview,
            );

            if (mounted) {
              setState(() {
                _meals = updated;
              });
            }
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(res.message)));
        }
      }
    } catch (e, st) {
      debugPrint('[TodayMealPlan] upload error: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload ảnh bữa ăn thất bại')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    final meals = _meals;

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
              const SizedBox(height: 4),
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

    // Phòng trường hợp hot-reload làm _mealHeights lệch length
    if (_mealHeights.length != meals.length) {
      _initHeights();
    }

    final currentHeight =
        (_currentIndex < _mealHeights.length && _mealHeights[_currentIndex] > 0)
        ? _mealHeights[_currentIndex]
        : _minHeight;

    final double targetHeight = max(currentHeight, _minHeight).toDouble();

    final waitingMessage =
        widget.waitingReviewMessage ??
        'Kế hoạch của bạn đang chờ advisor duyệt. Vui lòng đợi trong giây lát.';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: OnboardingGate(
        onboardingStep: widget.onboardingStep,
        shouldLock: (step) => step == 'waitingreview',
        lockTitle: 'Đang chờ advisor duyệt',
        lockMessage: waitingMessage,
        child: Stack(
          children: [
            Container(
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
                  Text(
                    'Thực đơn hôm nay',
                    style: t.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  _DailySummaryCard(day: widget.day),
                  const SizedBox(height: 4),

                  // Đo size thật giống workout — đo cả card + ảnh + comment
                  Offstage(
                    offstage: true,
                    child: Column(
                      children: [
                        for (int i = 0; i < meals.length; i++)
                          _MeasureSize(
                            key: ValueKey('meal-${i}-${meals[i].meal.type}'),
                            onChange: (size) => _onMealSize(i, size),
                            child: _MealPage(
                              entry: meals[i],
                              onUploadPhoto: _handleUploadPhoto,
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Card meal swipe (card + ảnh + comment swipe chung)
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
                        return _MealPage(
                          entry: entry,
                          onUploadPhoto: _handleUploadPhoto,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// Dots indicator
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
            if (_isUploading)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: cs.surface.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: cs.primary),
                        const SizedBox(height: 12),
                        Text(
                          'Đang tải ảnh...',
                          style: t.bodyMedium?.copyWith(
                            color: cs.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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
                      style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
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
                              style: t.bodySmall?.copyWith(
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
                              style: t.bodySmall?.copyWith(
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
                              style: t.bodySmall?.copyWith(
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
        const SizedBox(height: 4),
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

/// Card từng bữa ăn
class _MealTodoCard extends StatelessWidget {
  const _MealTodoCard({required this.entry, this.onUploadPhoto});

  static const double kPhotoHeight = 200;

  final MealEntry entry;
  final Future<void> Function(MealEntry entry)? onUploadPhoto;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    final meal = entry.meal;
    final nutrition = meal.nutrition;
    final photoUrl = entry.photoUrl;
    final isCompleted = entry.isCompleted;
    final completionPercentValue = entry.advisorReview?.completionPercent
        ?.round();

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
          /// Header
          Row(
            children: [
              Expanded(
                child: Text(
                  meal.type,
                  style: t.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              if (completionPercentValue != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '$completionPercentValue%',
                    style: t.labelSmall?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              else if (isCompleted)
                Icon(Icons.check_circle, color: cs.primary, size: 18),
            ],
          ),
          const SizedBox(height: 6),

          /// Macro
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
                    ),
                    _MacroDot(
                      color: Colors.lightGreenAccent,
                      label: 'Protein: $protein g',
                    ),
                    _MacroDot(color: Colors.cyanAccent, label: 'Fat: $fat g'),
                  ],
                ),
              ),
              _MacroDot(color: cs.primary, label: '$kcal kcal'),
            ],
          ),

          const SizedBox(height: 5),
          Divider(color: cs.surfaceContainerHigh, height: 8),
          const SizedBox(height: 5),

          /// Foods
          _MealFoodsTable(foods: meal.foods),
          const SizedBox(height: 12),

          /// Upload photo
          if (photoUrl == null || photoUrl.isEmpty)
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton.icon(
                onPressed: () async {
                  if (onUploadPhoto != null) await onUploadPhoto!(entry);
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

/// Một trang meal: card + ảnh + comment, dùng cho cả PageView & đo size
class _MealPage extends StatelessWidget {
  const _MealPage({required this.entry, required this.onUploadPhoto});

  final MealEntry entry;
  final Future<void> Function(MealEntry entry) onUploadPhoto;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = entry.photoUrl != null && entry.photoUrl!.isNotEmpty;
    final hasComment = entry.mealLogId?.isNotEmpty ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _MealTodoCard(entry: entry, onUploadPhoto: onUploadPhoto),
        if (hasPhoto) ...[
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              entry.photoUrl!,
              height: _MealTodoCard.kPhotoHeight,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
        if (hasComment) ...[
          const SizedBox(height: 8),
          _MealPhotoCommentsSection(mealLogId: entry.mealLogId!),
        ],
      ],
    );
  }
}

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
            padding: const EdgeInsets.symmetric(vertical: 1),
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
  const _MacroDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: t.bodySmall),
      ],
    );
  }
}

/// Comment cho ảnh bữa ăn – dùng API thật
class _MealPhotoCommentsSection extends StatefulWidget {
  const _MealPhotoCommentsSection({required this.mealLogId});

  final String mealLogId;

  @override
  State<_MealPhotoCommentsSection> createState() =>
      _MealPhotoCommentsSectionState();
}

class _MealPhotoCommentsSectionState extends State<_MealPhotoCommentsSection> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mealLogId.isEmpty) {
      return const SizedBox.shrink();
    }

    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Consumer(
      builder: (context, ref, _) {
        final commentsAsync = ref.watch(
          mealCommentsControllerProvider(widget.mealLogId),
        );

        const double sectionHeight = 170;

        Future<void> handleSend() async {
          final raw = _controller.text.trim();
          if (raw.isEmpty) return;

          final notifier = ref.read(
            mealCommentsControllerProvider(widget.mealLogId).notifier,
          );

          await notifier.addComment(raw);
          _controller.clear();
        }

        Future<void> handleDelete(String commentId) async {
          final notifier = ref.read(
            mealCommentsControllerProvider(widget.mealLogId).notifier,
          );
          await notifier.deleteComment(commentId);
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: sectionHeight,
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
          decoration: BoxDecoration(
            color: cs.surface.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(
                'Nhận xét về bữa ăn',
                style: t.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 3),

              /// Vùng comment chiếm phần còn lại, bên trong có scroll
              Expanded(
                child: commentsAsync.when(
                  loading: () => Row(
                    children: [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.6,
                          color: cs.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Đang tải nhận xét...',
                        style: t.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  error: (e, _) => Text(
                    'Không tải được nhận xét',
                    style: t.bodySmall?.copyWith(color: cs.error),
                  ),
                  data: (data) {
                    final comments = data.comments;

                    if (comments.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 26,
                              color: cs.onSurfaceVariant.withOpacity(0.8),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Chưa có nhận xét nào',
                              textAlign: TextAlign.center,
                              style: t.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Hãy chia sẻ cảm nhận của bạn nhé!',
                              textAlign: TextAlign.center,
                              style: t.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final items = comments.map((c) {
                      final isAdvisor = c.senderType.toLowerCase() == 'advisor';
                      final bubbleColor = isAdvisor
                          ? cs.tertiaryContainer
                          : cs.surfaceVariant;
                      final textColor = isAdvisor
                          ? cs.onTertiaryContainer
                          : cs.onSurface;
                      final icon = isAdvisor
                          ? Icons.psychology_alt_outlined
                          : Icons.person_outline;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              icon,
                              size: 16,
                              color: isAdvisor
                                  ? cs.tertiary
                                  : cs.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: bubbleColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              c.senderName,
                                              style: t.labelSmall?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: textColor.withOpacity(
                                                  0.9,
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () => handleDelete(c.id),
                                            child: Icon(
                                              Icons.close_rounded,
                                              size: 14,
                                              color: textColor.withOpacity(0.6),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        c.content,
                                        style: t.bodySmall?.copyWith(
                                          color: textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList();

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: items,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 4),

              /// Input gửi comment
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 3,
                      style: t.bodySmall,
                      decoration: InputDecoration(
                        hintText: 'Gửi nhận xét về bữa ăn...',
                        hintStyle: t.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        filled: true,
                        fillColor: cs.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(999),
                          borderSide: BorderSide(color: cs.outlineVariant),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(999),
                          borderSide: BorderSide(color: cs.outlineVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(999),
                          borderSide: BorderSide(color: cs.primary, width: 1.2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: Icon(Icons.send_rounded, size: 18, color: cs.primary),
                    onPressed: handleSend,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

typedef OnWidgetSizeChange = void Function(Size size);

class _MeasureSize extends StatefulWidget {
  const _MeasureSize({Key? key, required this.onChange, required this.child})
    : super(key: key);

  final OnWidgetSizeChange onChange;
  final Widget child;

  @override
  State<_MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<_MeasureSize> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ro = context.findRenderObject();
      if (ro is RenderBox) {
        final newSize = ro.size;
        widget.onChange(newSize);
      }
    });

    return widget.child;
  }
}
