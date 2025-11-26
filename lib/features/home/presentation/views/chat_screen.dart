// lib/features/home/presentation/views/chat.dart
import 'dart:async';

import 'package:fitai_mobile/features/home/data/models/chat_thread_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitai_mobile/features/home/presentation/viewmodels/home_state.dart';
import 'package:fitai_mobile/features/home/presentation/views/plan_demo_screen.dart'
    show PlanDemoBody;
import 'package:fitai_mobile/features/home/presentation/views/plan_preview_screen.dart'
    show PlanPreviewBody;
import 'package:go_router/go_router.dart';
import 'package:fitai_mobile/features/home/presentation/viewmodels/chat_thread_provider.dart';
import 'package:fitai_mobile/core/widgets/app_chat_bubble.dart';
import 'package:fitai_mobile/core/widgets/app_chat_input_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomeHostScreen extends ConsumerWidget {
  const HomeHostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(homeViewProvider);

    // Nếu đang xem Plan Preview
    if (view == HomeView.planDemo) {
      return const PlanDemoBody();
    }

    // Nếu đang xem Plan Preview (meal plan)
    if (view == HomeView.planPreview) {
      return const PlanPreviewBody();
    }

    final plan = ref.watch(subscriptionPlanProvider);

    // FREE → chỉ hiện teaser
    if (plan == SubscriptionPlan.free) {
      return const _FreePlanTeaser();
    }

    // PRO → giao cho host widget xử lý list / chat
    return const _ProPlanHost();
  }
}

//// =======================
/// FREE PLAN – TEASER CARD
//// =======================
class _FreePlanTeaser extends ConsumerWidget {
  const _FreePlanTeaser();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outlineVariant),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.auto_awesome, color: cs.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bạn muốn một trải nghiệm mang tính cá nhân hóa?',
                          style: t.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Pro plan luôn sẵn sàng hãy để chúng mình đồng hành cùng bạn nhé!',
                          style: t.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => context.push('/payment'),
                          child: Text(
                            'Xem chi tiết',
                            style: t.bodyMedium?.copyWith(
                              color: cs.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              icon: const Icon(Icons.auto_graph_rounded),
              label: const Text('Xem Plan Demo'),
              onPressed: () =>
                  ref.read(homeViewProvider.notifier).state = HomeView.planDemo,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProPlanHost extends ConsumerStatefulWidget {
  const _ProPlanHost();

  @override
  ConsumerState<_ProPlanHost> createState() => _ProPlanHostState();
}

class _ProPlanHostState extends ConsumerState<_ProPlanHost> {
  String? _selectedConversationId;

  /// Lưu welcome message AI của thread vừa tạo
  final Map<String, String> _initialAiMessages = {};

  /// Đảm bảo chỉ auto-tạo thread đầu tiên 1 lần
  bool _autoCreatedFirstThread = false;

  Future<void> _createNewConversation() async {
    try {
      // Gọi API tạo thread mới
      final data = await ref.read(
        createChatThreadProvider(title: '', threadType: 'fitness').future,
      );

      setState(() {
        _selectedConversationId = data.threadId;
        _initialAiMessages[data.threadId] = data.aiMessage;
      });

      // Invalidate list để khi back ra list sẽ có thread mới
      ref.invalidate(chatThreadsProvider);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tạo được cuộc trò chuyện mới')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final threadsAsync = ref.watch(chatThreadsProvider);

    return threadsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Không tải được danh sách chat: $err'),
      ),
      data: (conversations) {
        // Không có thread nào → tự tạo 1 cuộc trò chuyện đầu tiên cho người dùng
        if (conversations.isEmpty && _selectedConversationId == null) {
          if (!_autoCreatedFirstThread) {
            // Gọi sau frame hiện tại để tránh setState trong build nhiều lần
            _autoCreatedFirstThread = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _createNewConversation();
              }
            });
          }

          return const Center(child: CircularProgressIndicator());
        }

        // Nếu chưa chọn → show LIST
        if (_selectedConversationId == null) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: _ConversationList(
                      conversations: conversations,
                      onSelect: (id) {
                        setState(() {
                          _selectedConversationId = id;
                        });
                      },
                      onNewChat: _createNewConversation,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const SafeArea(top: false, child: SizedBox.shrink()),
              ],
            ),
          );
        }

        // Đã chọn → tìm thread tương ứng (có thể chưa có trong list nếu vừa tạo)
        final selectedId = _selectedConversationId!;
        ChatThread? selected;
        try {
          selected = conversations.firstWhere((x) => x.id == selectedId);
        } catch (_) {
          selected = null;
        }

        final title = (selected?.title.isNotEmpty ?? false)
            ? selected!.title
            : 'Cuộc trò chuyện mới';

        return _ProPlanChat(
          conversationId: selectedId,
          title: title,
          initialAiMessage: _initialAiMessages[selectedId],
          onBack: () {
            setState(() => _selectedConversationId = null);
          },
        );
      },
    );
  }
}

class _ConversationList extends StatelessWidget {
  const _ConversationList({
    super.key,
    required this.conversations,
    required this.onSelect,
    required this.onNewChat,
  });

  final List<ChatThread> conversations;
  final ValueChanged<String> onSelect;
  final VoidCallback onNewChat;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    final totalItems = conversations.length + 1; // +1 cho ô "chat mới"

    return ListView.separated(
      itemCount: totalItems,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        // Ô cuối: tạo chat mới
        if (index == conversations.length) {
          return ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: cs.outlineVariant),
            ),
            tileColor: cs.surfaceContainerHighest,
            leading: CircleAvatar(
              backgroundColor: cs.primaryContainer,
              child: Icon(Icons.add_rounded, color: cs.onPrimaryContainer),
            ),
            title: Text(
              'Bắt đầu đoạn chat mới',
              style: t.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Nhấn để tạo cuộc trò chuyện với AI Coach',
              style: t.bodySmall,
            ),
            onTap: onNewChat,
          );
        }

        final c = conversations[index];

        // Subtitle tạm: loại thread hoặc thời gian tin nhắn cuối
        final subtitle = c.lastMessageAt != null && c.lastMessageAt!.isNotEmpty
            ? 'Cập nhật gần nhất: ${c.lastMessageAt}'
            : 'Loại: ${c.threadType}';

        return ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: cs.outlineVariant),
          ),
          tileColor: cs.surfaceContainerLowest,
          leading: CircleAvatar(
            backgroundColor: cs.primary,
            child: Icon(Icons.chat_bubble_outline, color: cs.onPrimary),
          ),
          title: Text(
            c.title,
            style: t.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(subtitle, style: t.bodySmall),
          onTap: () => onSelect(c.id),
        );
      },
    );
  }
}

//// =======================
/// PRO PLAN – CHAT SCREEN
//// =======================
class _ProPlanChat extends ConsumerStatefulWidget {
  const _ProPlanChat({
    super.key,
    required this.conversationId,
    required this.title,
    this.initialAiMessage,
    this.onBack,
  });

  final String conversationId;
  final String title;
  final String? initialAiMessage;
  final VoidCallback? onBack;

  @override
  ConsumerState<_ProPlanChat> createState() => _ProPlanChatState();
}

class _ProPlanChatState extends ConsumerState<_ProPlanChat> {
  final List<({String text, bool isMe})> _sessionMessages = [];
  bool _isSending = false;
  bool _isTyping = false;

  bool _isSavingHealth = false;
  bool _hasJustSaved = false;

  bool _showPlanCta = false;

  /// NEW: trạng thái cho 2 plan
  bool _isGeneratingWorkout = false;
  bool _workoutDone = false;

  bool _isGeneratingMeal = false;
  bool _mealDone = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  /// Gọi lần lượt:
  /// 1. generate workout plan
  /// 2. generate meal plan
  /// Cả 2 xong → cho phép "Xem plan"
  Future<void> _handleGetPlan() async {
    // Nếu cả 2 đã xong → nhảy sang màn preview
    if (_workoutDone && _mealDone) {
      ref.read(homeViewProvider.notifier).state = HomeView.planPreview;
      return;
    }

    // Đang chạy cái gì đó thì bỏ qua để tránh spam
    if (_isGeneratingWorkout || _isGeneratingMeal) return;

    // Bước 1: chưa có workout → generate workout trước
    if (!_workoutDone) {
      setState(() => _isGeneratingWorkout = true);

      try {
        await ref.read(workoutPlanGenerateProvider.future);
        if (!mounted) return;
        setState(() {
          _isGeneratingWorkout = false;
          _workoutDone = true;
        });
      } catch (e) {
        if (!mounted) return;
        setState(() => _isGeneratingWorkout = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tạo lịch tập thất bại, thử lại sau nhé.'),
          ),
        );
        return; // dừng, không chạy meal nữa
      }
    }

    // Bước 2: workout xong rồi → generate meal
    if (_workoutDone && !_mealDone) {
      setState(() => _isGeneratingMeal = true);

      try {
        await ref.read(mealPlanGenerateProvider.future);
        if (!mounted) return;
        setState(() {
          _isGeneratingMeal = false;
          _mealDone = true;
        });
      } catch (e) {
        if (!mounted) return;
        setState(() => _isGeneratingMeal = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tạo thực đơn thất bại, thử lại sau nhé.'),
          ),
        );
      }
    }
  }

  Future<void> _handleSend(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _isSending) return;

    setState(() {
      _sessionMessages.add((text: trimmed, isMe: true));
      _isSending = true;
      _isTyping = true;
    });

    try {
      final reply = await ref.read(
        sendChatMessageProvider(
          threadId: widget.conversationId,
          content: trimmed,
        ).future,
      );

      // reply là ChatMessage từ server
      final isUser = reply.role.toLowerCase() == 'user';

      setState(() {
        _sessionMessages.add((text: reply.content, isMe: isUser));
      });

      // ======= LƯU HỒ SƠ SỨC KHỎE (NẾU CÓ META) =======
      final meta = reply.data;
      if (meta != null) {
        setState(() {
          _isSavingHealth = true;
          _hasJustSaved = false;
        });

        // dùng class-based provider: AiHealthPlanCreateController
        ref
            .read(aiHealthPlanCreateControllerProvider.notifier)
            .saveFromMeta(meta)
            .then((_) {
              if (!mounted) return;
              setState(() {
                _isSavingHealth = false;
                _hasJustSaved = true;
                _showPlanCta = true;
              });

              // 2s sau tự ẩn thông báo "đã lưu"
              Future.delayed(const Duration(seconds: 2), () {
                if (!mounted) return;
                setState(() => _hasJustSaved = false);
              });
            })
            .catchError((error, stack) {
              if (!mounted) return;
              setState(() {
                _isSavingHealth = false;
                _hasJustSaved = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Lưu hồ sơ sức khỏe thất bại, thử lại sau nhé.',
                  ),
                ),
              );
            });
      }
      // ================================================
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gửi tin nhắn thất bại')));
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
          _isTyping = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    // 👇 Lấy lịch sử chat từ API
    final historyAsync = ref.watch(
      threadMessagesProvider(threadId: widget.conversationId),
    );

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outlineVariant),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // ===== Header nhỏ với nút Back + title =====
                  Row(
                    children: [
                      if (widget.onBack != null)
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          iconSize: 18,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints.tightFor(
                            width: 32,
                            height: 32,
                          ),
                          onPressed: widget.onBack,
                        ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: t.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // ====== Vùng message scroll được + history + session ======
                  Expanded(
                    child: historyAsync.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (err, st) => Center(
                        child: Text(
                          'Không tải được lịch sử chat.\n$err',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      data: (historyMessages) {
                        final historyTuples = historyMessages
                            .map<({String text, bool isMe})>(
                              (m) => (
                                text: m.content,
                                isMe: m.role.toLowerCase() == 'user',
                              ),
                            );

                        final allMessages = <({String text, bool isMe})>[];

                        if (historyMessages.isEmpty &&
                            widget.initialAiMessage != null &&
                            widget.initialAiMessage!.trim().isNotEmpty) {
                          allMessages.add((
                            text: widget.initialAiMessage!.trim(),
                            isMe: false,
                          ));
                        }

                        allMessages.addAll(historyTuples);
                        allMessages.addAll(_sessionMessages);

                        if (allMessages.isEmpty && !_isSending) {
                          return Center(
                            child: Text(
                              'Hãy bắt đầu trò chuyện với FitAI ✨',
                              style: t.bodyMedium,
                            ),
                          );
                        }

                        final showPlanCta = _showPlanCta && !_isSavingHealth;

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_scrollController.hasClients) {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                            );
                          }
                        });

                        return Column(
                          children: [
                            Expanded(
                              child: _ChatMessageList(
                                messages: allMessages,
                                showPlanCta: showPlanCta,
                                onGetPlan: _handleGetPlan,
                                controller: _scrollController,
                                isTyping: _isTyping,
                                // trạng thái 2 plan
                                isGeneratingWorkout: _isGeneratingWorkout,
                                workoutDone: _workoutDone,
                                isGeneratingMeal: _isGeneratingMeal,
                                mealDone: _mealDone,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 4),

                  if (_isSavingHealth || _hasJustSaved)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_isSavingHealth)
                              LoadingAnimationWidget.waveDots(
                                color: cs.primary,
                                size: 18,
                              )
                            else
                              Icon(
                                Icons.check_circle_rounded,
                                size: 18,
                                color: cs.primary,
                              ),
                            const SizedBox(width: 8),
                            Text(
                              _isSavingHealth
                                  ? 'Đang lưu hồ sơ sức khỏe của bạn...'
                                  : 'Hồ sơ sức khỏe của bạn đã được lưu.',
                              style: t.bodySmall?.copyWith(color: cs.onSurface),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),

                  // ====== Input ======
                  AppChatInputBar(
                    onSend: _handleSend,
                    // nếu AppChatInputBar có hỗ trợ isLoading:
                    // isLoading: _isSending,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const SafeArea(top: false, child: SizedBox.shrink()),
        ],
      ),
    );
  }
}

//// =======================
/// WIDGET RENDER LIST MESSAGE
//// =======================
class _ChatMessageList extends StatelessWidget {
  const _ChatMessageList({
    super.key,
    required this.messages,
    this.isTyping = false,
    this.showPlanCta = false,
    this.onGetPlan,
    this.controller,
    // NEW
    this.isGeneratingWorkout = false,
    this.workoutDone = false,
    this.isGeneratingMeal = false,
    this.mealDone = false,
  });

  final List<({String text, bool isMe})> messages;

  final bool isTyping;
  final bool showPlanCta;

  // NEW: 2 plan
  final bool isGeneratingWorkout;
  final bool workoutDone;

  final bool isGeneratingMeal;
  final bool mealDone;

  final VoidCallback? onGetPlan;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    final baseCount = messages.length;
    final total = baseCount + (showPlanCta ? 1 : 0) + (isTyping ? 1 : 0);

    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.only(bottom: 8),
      itemCount: total,
      itemBuilder: (context, index) {
        // 1) Các bubble chat bình thường
        if (index < baseCount) {
          final m = messages[index];
          return Align(
            alignment: m.isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              child: AppChatBubble(
                text: m.text,
                isMe: m.isMe,
                botAvatar: 'lib/core/assets/images/chatbot.png',
              ),
            ),
          );
        }

        // 2) Plan CTA + progress
        if (showPlanCta && index == baseCount) {
          // chọn text cho dòng mô tả
          String line;
          if (isGeneratingWorkout && !workoutDone) {
            line = 'Đang tạo lịch tập cho bạn...';
          } else if (workoutDone && isGeneratingMeal && !mealDone) {
            line = 'Đang tạo thực đơn cho bạn...';
          } else if (workoutDone && mealDone) {
            line = 'Plan cá nhân hóa của bạn đã sẵn sàng';
          } else {
            line = 'Mình đã sẵn sàng làm plan cá nhân hóa cho bạn';
          }

          final bool isAnyGenerating =
              (isGeneratingWorkout && !workoutDone) ||
              (isGeneratingMeal && !mealDone);

          return Padding(
            padding: const EdgeInsets.only(
              top: 6,
              left: 25,
              right: 4,
              bottom: 4,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 22),
                _BlinkWrapper(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.78,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          line,
                          style: t.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // ===== Chỉ hiện 1 thanh tại 1 thời điểm =====
                        if (isGeneratingWorkout && !workoutDone)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 8),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: PlanGenerateProgressBar(
                                  isDone: workoutDone,
                                ),
                              ),
                            ],
                          )
                        else if (workoutDone && isGeneratingMeal && !mealDone)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 8),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: PlanGenerateProgressBar(
                                  isDone: mealDone,
                                ),
                              ),
                            ],
                          )
                        else
                          // Khi KHÔNG còn generate gì → show CTA
                          GestureDetector(
                            onTap: onGetPlan,
                            child: Text(
                              (workoutDone && mealDone)
                                  ? 'Xem plan'
                                  : 'Nhận plan',
                              style: t.labelMedium?.copyWith(
                                color: cs.primary,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // 3) Typing indicator
        if (isTyping && index == total - 1) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              child: AppChatBubble(
                text: '',
                isMe: false,
                botAvatar: 'lib/core/assets/images/chatbot.png',
                child: LoadingAnimationWidget.waveDots(
                  color: cs.onSurface,
                  size: 22,
                ),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _BlinkWrapper extends StatefulWidget {
  final Widget child;

  const _BlinkWrapper({super.key, required this.child});

  @override
  State<_BlinkWrapper> createState() => _BlinkWrapperState();
}

class _BlinkWrapperState extends State<_BlinkWrapper> {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _startBlink();
  }

  void _startBlink() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 850));
      if (!mounted) return;
      setState(() => _opacity = _opacity == 1 ? 0.35 : 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 450),
      child: widget.child,
    );
  }
}

class PlanGenerateProgressBar extends StatefulWidget {
  final bool isDone;

  const PlanGenerateProgressBar({super.key, required this.isDone});

  @override
  State<PlanGenerateProgressBar> createState() =>
      _PlanGenerateProgressBarState();
}

class _PlanGenerateProgressBarState extends State<PlanGenerateProgressBar> {
  double _progress = 0.0;
  bool _finishedFake = false;

  @override
  void initState() {
    super.initState();
    _startFakeProgress();
  }

  @override
  void didUpdateWidget(covariant PlanGenerateProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isDone && !oldWidget.isDone) {
      _jumpToComplete();
    }
  }

  Future<void> _startFakeProgress() async {
    const phases = [0.35, 0.68, 0.9];

    for (final target in phases) {
      // chạy tới mốc target
      while (mounted &&
          !widget.isDone &&
          _progress < target &&
          !_finishedFake) {
        setState(() {
          _progress = (_progress + 0.01).clamp(0.0, target);
        });
        await Future.delayed(const Duration(milliseconds: 80));
      }

      if (!mounted || widget.isDone) break;

      await Future.delayed(const Duration(milliseconds: 500));
    }

    _finishedFake = true;
  }

  Future<void> _jumpToComplete() async {
    while (mounted && _progress < 1.0) {
      setState(() {
        _progress = (_progress + 0.04).clamp(0.0, 1.0);
      });
      await Future.delayed(const Duration(milliseconds: 40));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: _progress,
        minHeight: 3,
        backgroundColor: cs.primary.withOpacity(0.1),
        valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
      ),
    );
  }
}
