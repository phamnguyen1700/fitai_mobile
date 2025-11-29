import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitai_mobile/core/widgets/onboarding_gate.dart';
import 'package:fitai_mobile/features/daily/data/models/workout_plan_models.dart';
import 'package:fitai_mobile/features/daily/data/models/upload_image.dart';
import 'package:fitai_mobile/features/daily/presentation/widgets/exercise_video_log_tile.dart';
import 'package:fitai_mobile/features/daily/presentation/widgets/user_video.dart';
import 'package:fitai_mobile/features/daily/presentation/widgets/workout_day_selector.dart';
import 'package:fitai_mobile/features/daily/presentation/viewmodels/workout_plan_providers.dart';
import 'package:fitai_mobile/features/daily/presentation/viewmodels/workout_video_providers.dart';
import 'package:fitai_mobile/features/daily/presentation/viewmodels/workout_comments_providers.dart';

/// Card “Buổi tập hôm nay” – swipe từng video bài tập
class TodayWorkoutPlanCard extends ConsumerStatefulWidget {
  const TodayWorkoutPlanCard({
    super.key,
    required this.days,
    this.initialDayNumber,
    this.onboardingStep,
    this.waitingReviewMessage,
    this.tierType,
  });

  final List<WorkoutPlanDayModel> days;
  final int? initialDayNumber;
  final String? onboardingStep;
  final String? waitingReviewMessage;
  final String? tierType;

  @override
  ConsumerState<TodayWorkoutPlanCard> createState() =>
      _TodayWorkoutPlanCardState();
}

class _TodayWorkoutPlanCardState extends ConsumerState<TodayWorkoutPlanCard> {
  static const double _minHeight = 200;

  late final PageController _pageController;

  /// index của ngày đang chọn trong [widget.days]
  int _selectedDayIndex = 0;

  /// index của bài tập đang swipe trong ngày hiện tại
  int _currentExerciseIndex = 0;

  /// lưu chiều cao thực tế của từng bài tập trong ngày hiện tại
  late List<double> _exerciseHeights;

  /// chặn spam upload
  String? _uploadingExerciseId;

  late List<WorkoutPlanDayModel> _daysState;

  List<WorkoutPlanDayModel> get _days => _daysState;

  bool get _hasDays => _days.isNotEmpty;

  WorkoutPlanDayModel get _currentDay => _days[_selectedDayIndex];

  List<WorkoutExerciseModel> get _currentExercises => _currentDay.exercises;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _selectedDayIndex = _resolveInitialDayIndex();
    _daysState = _cloneDays(widget.days);
    _initHeightsForDay(_selectedDayIndex);
  }

  List<WorkoutPlanDayModel> _cloneDays(List<WorkoutPlanDayModel> source) {
    return source
        .map(
          (day) => WorkoutPlanDayModel(
            dayNumber: day.dayNumber,
            dayName: day.dayName,
            totalExercises: day.totalExercises,
            exercises: List<WorkoutExerciseModel>.from(day.exercises),
          ),
        )
        .toList();
  }

  int _resolveInitialDayIndex() {
    if (widget.days.isEmpty) return 0;
    if (widget.initialDayNumber == null) return 0;

    final idx = widget.days.indexWhere(
      (d) => d.dayNumber == widget.initialDayNumber,
    );
    return idx >= 0 ? idx : 0;
  }

  void _initHeightsForDay(int dayIndex) {
    if (!_hasDays || dayIndex < 0 || dayIndex >= _days.length) {
      _exerciseHeights = [_minHeight];
      _currentExerciseIndex = 0;
      return;
    }

    final len = _days[dayIndex].exercises.length;

    _exerciseHeights = List<double>.filled(len > 0 ? len : 1, 0);
    _currentExerciseIndex = 0;
  }

  @override
  void didUpdateWidget(covariant TodayWorkoutPlanCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.days != widget.days) {
      _daysState = _cloneDays(widget.days);
      _selectedDayIndex = _resolveInitialDayIndex();
      _pageController.jumpToPage(0);
      _initHeightsForDay(_selectedDayIndex);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onExerciseSize(int index, Size size) {
    if (index >= _exerciseHeights.length) return;
    final h = size.height;
    if (_exerciseHeights[index] == h) return;

    setState(() {
      _exerciseHeights[index] = h;
    });
  }

  /// Upload video + mark completed + reload lịch tập
  Future<void> _handleUploadVideo({
    required int dayNumber,
    required WorkoutExerciseModel exercise,
    required String localPath,
  }) async {
    if (_uploadingExerciseId != null) return;

    final file = File(localPath);

    setState(() {
      _uploadingExerciseId = exercise.exerciseId;
    });

    try {
      final repo = ref.read(workoutVideoRepositoryProvider);

      final res = await repo.uploadAndComplete(
        dayNumber: dayNumber,
        exerciseId: exercise.exerciseId,
        videoFile: file,
      );

      if (res.success) {
        // reload lại lịch tập để lấy videoLogUrl + isCompleted mới
        ref.invalidate(workoutPlanDaysProvider);
        ref.invalidate(workoutPlanScheduleProvider);

        final data = res.data;
        if (data != null) {
          _applyUploadResult(data, exercise);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(res.message)));
        }
      }
    } catch (e, st) {
      debugPrint('[TodayWorkoutPlanCard] upload error: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Upload video bài tập thất bại. Vui lòng thử lại.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _uploadingExerciseId = null;
        });
      }
    }
  }

  void _applyUploadResult(
    UploadWorkoutVideoData data,
    WorkoutExerciseModel exercise,
  ) {
    setState(() {
      _daysState = _daysState.map((day) {
        if (day.dayNumber != data.dayNumber) return day;

        final updatedExercises = day.exercises.map((ex) {
          if (ex.exerciseId != exercise.exerciseId) return ex;

          return WorkoutExerciseModel(
            exerciseLogId: data.exerciseLogId ?? ex.exerciseLogId,
            exerciseId: ex.exerciseId,
            name: ex.name,
            description: ex.description,
            category: ex.category,
            videoUrl: ex.videoUrl,
            level: ex.level,
            sets: ex.sets,
            reps: ex.reps,
            durationMinutes: ex.durationMinutes,
            note: ex.note,
            isCompleted: data.isCompleted,
            commentCount: ex.commentCount,
            advisorReview: ex.advisorReview,
            videoLogUrl: data.photoUrl,
          );
        }).toList();

        return WorkoutPlanDayModel(
          dayNumber: day.dayNumber,
          dayName: day.dayName,
          totalExercises: day.totalExercises,
          exercises: updatedExercises,
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final tier = widget.tierType?.toUpperCase();
    final bool showWorkoutComments = tier == 'VIP';

    final waitingMessage =
        widget.waitingReviewMessage ??
        'Kế hoạch của bạn đang chờ advisor duyệt. Vui lòng đợi trong giây lát.';

    Widget buildCardContent() {
      if (!_hasDays) {
        // 🔁 Giống TodayMealPlan empty-state
        return Container(
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
                'Buổi tập hôm nay',
                style: t.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  'Hôm nay chưa có buổi tập nào.',
                  textAlign: TextAlign.center,
                  style: t.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                ),
              ),
            ],
          ),
        );
      }

      final exercises = _currentExercises;

      // ===== TÍNH CHIỀU CAO GIỐNG MEAL =====
      final currentHeight =
          (_currentExerciseIndex < _exerciseHeights.length &&
              _exerciseHeights[_currentExerciseIndex] > 0)
          ? _exerciseHeights[_currentExerciseIndex]
          : _minHeight;

      final double targetHeight = max(currentHeight, _minHeight).toDouble();

      return Container(
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
              'Buổi tập hôm nay',
              style: t.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            // 🔹 Selector ngày tập – dùng lại WorkoutDaySelector
            WorkoutDaySelector(
              days: _days
                  .map(
                    (d) => WorkoutScheduleDay(
                      dayNumber: d.dayNumber,
                      dayName: d.dayName,
                      totalExercises: d.totalExercises,
                    ),
                  )
                  .toList(),
              selectedDayNumber: _currentDay.dayNumber,
              onDaySelected: (dayNumber) {
                final idx = _days.indexWhere((d) => d.dayNumber == dayNumber);
                if (idx < 0 || idx == _selectedDayIndex) return;

                setState(() {
                  _selectedDayIndex = idx;
                  _pageController.jumpToPage(0);
                  _initHeightsForDay(idx);
                });
              },
            ),

            const SizedBox(height: 8),

            if (exercises.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Ngày này chưa có bài tập.',
                  style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              )
            else ...[
              Offstage(
                offstage: true,
                child: Column(
                  children: [
                    for (int i = 0; i < exercises.length; i++)
                      _WorkoutExerciseWithComments(
                        key: ValueKey('measure_${exercises[i].exerciseId}'),
                        exercise: exercises[i],
                        dayNumber: _currentDay.dayNumber,
                        exerciseLogId: exercises[i].exerciseLogId ?? '',
                        onVideoPicked: (localPath) => _handleUploadVideo(
                          dayNumber: _currentDay.dayNumber,
                          exercise: exercises[i],
                          localPath: localPath,
                        ),
                        onSizeChanged: (size) => _onExerciseSize(i, size),
                        isUploading:
                            _uploadingExerciseId == exercises[i].exerciseId,
                        showComments: showWorkoutComments, // 👈 NEW
                      ),
                  ],
                ),
              ),

              // 🔸 PageView swipe qua từng video bài tập
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                height: targetHeight,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: exercises.length,
                  onPageChanged: (index) {
                    setState(() => _currentExerciseIndex = index);
                  },
                  itemBuilder: (context, index) {
                    final ex = exercises[index];
                    return _buildExerciseTile(ex, _currentDay.dayNumber);
                  },
                ),
              ),

              const SizedBox(height: 12),

              // 🔹 Dots indicator cho bài tập
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    exercises.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentExerciseIndex == i ? 12 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _currentExerciseIndex == i
                            ? cs.primary
                            : cs.onSurfaceVariant.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: OnboardingGate(
        onboardingStep: widget.onboardingStep,
        shouldLock: (step) => step == 'waitingreview',
        lockTitle: 'Đang chờ advisor duyệt',
        lockMessage: waitingMessage,
        child: buildCardContent(),
      ),
    );
  }

  Widget _buildExerciseTile(WorkoutExerciseModel ex, int dayNumber) {
    final tier = widget.tierType?.toUpperCase();
    final bool showWorkoutComments = tier == 'VIP';
    return _WorkoutExerciseWithComments(
      exercise: ex,
      dayNumber: dayNumber,
      exerciseLogId: ex.exerciseLogId ?? '',
      onVideoPicked: (localPath) => _handleUploadVideo(
        dayNumber: dayNumber,
        exercise: ex,
        localPath: localPath,
      ),
      isUploading: _uploadingExerciseId == ex.exerciseId,
      showComments: showWorkoutComments, // 👈 NEW
    );
  }
}

/// Exercise tile + comment section (REAL API)
class _WorkoutExerciseWithComments extends ConsumerStatefulWidget {
  const _WorkoutExerciseWithComments({
    required this.exercise,
    required this.dayNumber,
    required this.exerciseLogId,
    required this.onVideoPicked,
    this.onSizeChanged,
    this.isUploading = false,
    this.showComments = true,
    super.key,
  });

  final WorkoutExerciseModel exercise;
  final int dayNumber;
  final String exerciseLogId;
  final Future<void> Function(String localPath) onVideoPicked;
  final OnWidgetSizeChange? onSizeChanged;
  final bool isUploading;
  final bool showComments;

  @override
  ConsumerState<_WorkoutExerciseWithComments> createState() =>
      _WorkoutExerciseWithCommentsState();
}

class _WorkoutExerciseWithCommentsState
    extends ConsumerState<_WorkoutExerciseWithComments> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final controller = ref.read(
      workoutCommentsControllerProvider(widget.exerciseLogId).notifier,
    );
    await controller.addComment(text);

    _controller.clear();
  }

  Future<void> _handleDelete(String commentId) async {
    final controller = ref.read(
      workoutCommentsControllerProvider(widget.exerciseLogId).notifier,
    );

    await controller.deleteComment(commentId);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    final asyncComments = ref.watch(
      workoutCommentsControllerProvider(widget.exerciseLogId),
    );

    const double commentSectionHeight = 170;
    final userVideoUrl = widget.exercise.videoLogUrl;
    final bool hasUserVideo = userVideoUrl != null && userVideoUrl.isNotEmpty;
    final int? completionPercentValue = widget
        .exercise
        .advisorReview
        ?.completionPercent
        ?.round();
    final bool isExerciseCompleted = widget.exercise.isCompleted;

    return _MeasureSize(
      onChange: (size) {
        if (widget.onSizeChanged != null) {
          widget.onSizeChanged!(size);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tile bài tập gốc
          ExerciseVideoLogTile(
            title: widget.exercise.name,
            category: widget.exercise.category,
            sets: widget.exercise.sets,
            reps: widget.exercise.reps,
            minutes: widget.exercise.durationMinutes,
            note: widget.exercise.note,
            demoVideoUrl: widget.exercise.videoUrl,
            existingLogVideoUrl: widget.exercise.videoLogUrl,
            onVideoPicked: widget.onVideoPicked,
            isUploading: widget.isUploading,
          ),
          if (hasUserVideo) ...[
            UserExerciseVideoSection(
              title: widget.exercise.name,
              existingVideoUrl: userVideoUrl,
              isCompleted: isExerciseCompleted,
              completionPercent: completionPercentValue,
            ),

            if (widget.showComments) ...[
              const SizedBox(height: 8),
              // Comment section thật
              SizedBox(
                height: commentSectionHeight,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
                  decoration: BoxDecoration(
                    color: cs.surface.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tiêu đề
                      Row(
                        children: [
                          Text(
                            'Nhận xét & trao đổi',
                            style: t.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: cs.onSurface,
                            ),
                          ),
                          const SizedBox(width: 6),
                          asyncComments.maybeWhen(
                            loading: () => SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.6,
                                color: cs.primary,
                              ),
                            ),
                            orElse: () => const SizedBox.shrink(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Danh sách comment
                      Expanded(
                        child: asyncComments.when(
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
                          error: (e, _) => Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Không tải được nhận xét.',
                              style: t.bodySmall?.copyWith(color: cs.error),
                            ),
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
                                      color: cs.onSurfaceVariant.withOpacity(
                                        0.8,
                                      ),
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
                                      'Hãy gửi câu hỏi cho coach nhé!',
                                      textAlign: TextAlign.center,
                                      style: t.bodySmall?.copyWith(
                                        color: cs.onSurfaceVariant.withOpacity(
                                          0.8,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            final items = comments.map((c) {
                              final isCoach =
                                  c.senderType.toLowerCase() == 'advisor';

                              final bubbleColor = isCoach
                                  ? cs.tertiaryContainer
                                  : cs.surfaceVariant;

                              final textColor = isCoach
                                  ? cs.onTertiaryContainer
                                  : cs.onSurface;

                              final icon = isCoach
                                  ? Icons.fitness_center_outlined
                                  : Icons.person_outline;

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 3,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      icon,
                                      size: 16,
                                      color: isCoach
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
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
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
                                                      c.senderName ??
                                                          (isCoach
                                                              ? 'Coach'
                                                              : 'Bạn'),
                                                      style: t.labelSmall
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: textColor
                                                                .withOpacity(
                                                                  0.9,
                                                                ),
                                                          ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () =>
                                                        _handleDelete(c.id),
                                                    child: Icon(
                                                      Icons.close_rounded,
                                                      size: 14,
                                                      color: textColor
                                                          .withOpacity(0.6),
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

                      const SizedBox(height: 6),

                      // Ô nhập + nút gửi
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              minLines: 1,
                              maxLines: 3,
                              style: t.bodySmall,
                              decoration: InputDecoration(
                                hintText: 'Gửi câu hỏi cho coach...',
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
                                  borderSide: BorderSide(
                                    color: cs.outlineVariant,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(999),
                                  borderSide: BorderSide(
                                    color: cs.outlineVariant,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(999),
                                  borderSide: BorderSide(
                                    color: cs.primary,
                                    width: 1.2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          IconButton(
                            icon: Icon(
                              Icons.send_rounded,
                              size: 18,
                              color: cs.primary,
                            ),
                            onPressed: _handleSend,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
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
