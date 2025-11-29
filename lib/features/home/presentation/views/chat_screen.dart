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
import 'package:fitai_mobile/features/auth/presentation/viewmodels/auth_providers.dart';

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

    // 👇 Lấy tierType từ subscriptionNotifier
    final tierType = ref.watch(currentTierTypeProvider);
    final tier = tierType?.toUpperCase();

    // FREE (hoặc chưa có sub) → render như cũ: teaser + plan demo
    if (tier == null || tier == 'FREE') {
      return const _FreePlanTeaser();
    }

    // PREMIUM & VIP → được dùng message list (multi-conversation)
    if (tier == 'PREMIUM' || tier == 'VIP') {
      return const _ProPlanHost();
    }

    // Các tier khác (nếu backend có thêm) → tạm thời xử lý như FREE
    return const _FreePlanTeaser();
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

class _ChatListItem {
  final String? threadId;
  final String title;
  final String subtitle;
  final String type;

  const _ChatListItem({
    required this.threadId,
    required this.title,
    required this.subtitle,
    required this.type,
  });

  bool get isFitness => type.toLowerCase() == 'fitness';
}

class _ProPlanHost extends ConsumerStatefulWidget {
  const _ProPlanHost();

  @override
  ConsumerState<_ProPlanHost> createState() => _ProPlanHostState();
}

class _ProPlanHostState extends ConsumerState<_ProPlanHost> {
  String? _selectedConversationId;

  /// id của thread fitness (nếu đã tạo hoặc backend trả về)
  String? _fitnessThreadId;

  /// Lưu welcome message AI của thread vừa tạo
  final Map<String, String> _initialAiMessages = {};

  bool _creatingFitness = false;

  /// Tạo thread SUPPORT khi user bấm "Bắt đầu đoạn chat mới"
  Future<void> _createNewSupportConversation() async {
    try {
      final data = await ref.read(
        createChatThreadProvider(title: '', threadType: 'support').future,
      );

      setState(() {
        _selectedConversationId = data.threadId;
        _initialAiMessages[data.threadId] = data.aiMessage;
      });

      ref.invalidate(chatThreadsProvider);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tạo được cuộc trò chuyện mới')),
      );
    }
  }

  /// Mở chat fitness (nếu chưa có thread thì tạo mới)
  Future<void> _openFitnessChat() async {
    // Đã có id thread fitness rồi -> mở luôn
    if (_fitnessThreadId != null) {
      setState(() {
        _selectedConversationId = _fitnessThreadId;
      });
      return;
    }

    if (_creatingFitness) return;

    setState(() => _creatingFitness = true);

    try {
      final data = await ref.read(
        createChatThreadProvider(title: '', threadType: 'fitness').future,
      );

      _fitnessThreadId = data.threadId;
      _initialAiMessages[data.threadId] = data.aiMessage;

      setState(() {
        _selectedConversationId = data.threadId;
      });

      // để lần sau load list thì thread fitness cũng có trong data
      ref.invalidate(chatThreadsProvider);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tạo được đoạn chat fitness')),
      );
    } finally {
      if (mounted) {
        setState(() => _creatingFitness = false);
      }
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
        // Tách thread fitness (nếu backend có) và các thread còn lại (support)
        final fitnessThreads = conversations
            .where((t) => t.threadType.toLowerCase() == 'fitness')
            .toList();
        final supportThreads = conversations
            .where((t) => t.threadType.toLowerCase() != 'fitness')
            .toList();

        // Nếu backend đã có thread fitness thì lưu id lại
        if (fitnessThreads.isNotEmpty && _fitnessThreadId == null) {
          _fitnessThreadId = fitnessThreads.first.id;
        }

        // ====== GHÉP MẢNG HIỂN THỊ: [fitness pinned] + [support từ API] ======
        final List<_ChatListItem> items = [];

        // item fitness (luôn có, kể cả khi chưa có thread trên server)
        items.add(
          _ChatListItem(
            threadId: _fitnessThreadId, // có thể null
            type: 'fitness',
            title: 'FitAI – Health Plan',
            subtitle: 'Chat để tạo kế hoạch tập luyện & dinh dưỡng',
          ),
        );

        // các thread support từ API
        for (final c in supportThreads) {
          final subtitle =
              c.lastMessageAt != null && c.lastMessageAt!.isNotEmpty
              ? 'Cập nhật gần nhất: ${c.lastMessageAt}'
              : 'Loại: ${c.threadType}';

          items.add(
            _ChatListItem(
              threadId: c.id,
              type: c.threadType,
              title: c.title,
              subtitle: subtitle,
            ),
          );
        }

        // ===== CHƯA CHỌN CONVERSATION -> SHOW MESSAGE LIST =====
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
                      items: items,
                      onSelectSupport: (threadId) {
                        setState(() {
                          _selectedConversationId = threadId;
                        });
                      },
                      onOpenFitness: _openFitnessChat,
                      onNewSupportChat: _createNewSupportConversation,
                      isCreatingFitness: _creatingFitness,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const SafeArea(top: false, child: SizedBox.shrink()),
              ],
            ),
          );
        }

        // ===== ĐÃ CHỌN 1 CONVERSATION -> VÀO MÀN CHAT =====
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
    required this.items,
    required this.onSelectSupport,
    required this.onOpenFitness,
    required this.onNewSupportChat,
    this.isCreatingFitness = false,
  });

  final List<_ChatListItem> items;
  final ValueChanged<String> onSelectSupport;
  final VoidCallback onOpenFitness;
  final VoidCallback onNewSupportChat;
  final bool isCreatingFitness;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    // +1 cho ô "chat mới" (support)
    final totalItems = items.length + 1;

    return ListView.separated(
      itemCount: totalItems,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        // Ô cuối: tạo chat SUPPORT mới
        if (index == items.length) {
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
              'Nhấn để tạo cuộc trò chuyện với AI Coach (support)',
              style: t.bodySmall,
            ),
            onTap: onNewSupportChat,
          );
        }

        final item = items[index];

        final isFitness = item.isFitness;
        final isDisabledFitness = isFitness && isCreatingFitness;

        return ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: isFitness ? cs.primary : cs.outlineVariant),
          ),
          tileColor: isFitness
              ? cs.primaryContainer.withOpacity(0.1)
              : cs.surfaceContainerLowest,
          leading: CircleAvatar(
            backgroundColor: isFitness ? cs.primary : cs.primaryContainer,
            child: Icon(
              isFitness
                  ? Icons.fitness_center_rounded
                  : Icons.chat_bubble_outline,
              color: cs.onPrimary,
            ),
          ),
          title: Text(
            item.title,
            style: t.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(item.subtitle, style: t.bodySmall),
          onTap: () {
            if (isFitness) {
              onOpenFitness();
            } else if (item.threadId != null) {
              onSelectSupport(item.threadId!);
            }
          },
          trailing: isDisabledFitness
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: cs.primary,
                  ),
                )
              : null,
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

  Future<void> _handleGetPlan() async {
    if (_isGeneratingWorkout || _isGeneratingMeal) return;
    setState(() {
      _workoutDone = false;
      _mealDone = false;
    });
    ref.invalidate(workoutPlanGenerateProvider);
    ref.invalidate(mealPlanGenerateProvider);
    try {
      setState(() {
        _isGeneratingWorkout = true;
        _isGeneratingMeal = false;
      });

      debugPrint('▶️ [GetPlan] Bắt đầu generate WORKOUT...');
      await ref.read(workoutPlanGenerateProvider.future);
      if (!mounted) return;

      setState(() {
        _isGeneratingWorkout = false;
        _workoutDone = true;
      });
      debugPrint('✅ [GetPlan] WORKOUT xong.');
      setState(() {
        _isGeneratingMeal = true;
      });

      debugPrint('▶️ [GetPlan] Bắt đầu generate MEAL...');
      await ref.read(mealPlanGenerateProvider.future);
      if (!mounted) return;

      setState(() {
        _isGeneratingMeal = false;
        _mealDone = true;
      });
      debugPrint('✅ [GetPlan] MEAL xong.');
      ref.read(homeViewProvider.notifier).state = HomeView.planPreview;
    } catch (e, st) {
      if (!mounted) return;

      debugPrint('❌ [GetPlan] Lỗi khi generate plan: $e\n$st');

      setState(() {
        _isGeneratingWorkout = false;
        _isGeneratingMeal = false;
      });
      final isWorkoutError = !_workoutDone;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isWorkoutError
                ? 'Tạo lịch tập thất bại, thử lại sau nhé.'
                : 'Tạo thực đơn thất bại, thử lại sau nhé.',
          ),
        ),
      );
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

    // Chọn text cho dòng mô tả CTA
    String _buildCtaLine() {
      if (isGeneratingWorkout && !workoutDone) {
        return 'Đang tạo lịch tập cho bạn...';
      } else if (workoutDone && isGeneratingMeal && !mealDone) {
        return 'Đang tạo thực đơn cho bạn...';
      } else if (workoutDone && mealDone) {
        return 'Plan cá nhân hóa của bạn đã sẵn sàng';
      } else {
        return 'Mình đã sẵn sàng làm plan cá nhân hóa cho bạn';
      }
    }

    final bool isAnyGenerating =
        (isGeneratingWorkout && !workoutDone) ||
        (isGeneratingMeal && !mealDone);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ===== LIST MESSAGES (như cũ) =====
        Expanded(
          child: ListView.builder(
            controller: controller,
            padding: const EdgeInsets.only(bottom: 8),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final m = messages[index];
              return Align(
                alignment: m.isMe
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 2,
                  ),
                  child: AppChatBubble(
                    text: m.text,
                    isMe: m.isMe,
                    botAvatar: 'lib/core/assets/images/chatbot.png',
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 4),

        // ===== CTA “Nhận plan” + progress, nằm dưới list =====
        if (showPlanCta)
          Padding(
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
                          _buildCtaLine(),
                          style: t.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Chỉ hiển thị 1 thanh progress tại 1 thời điểm
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
                          // Khi không còn generate gì → show CTA
                          GestureDetector(
                            onTap: onGetPlan,
                            child: Text(
                              'Nhận plan',
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
          ),

        // ===== Typing indicator (nằm cuối, dưới CTA) =====
        if (isTyping)
          Align(
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
          ),
      ],
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
