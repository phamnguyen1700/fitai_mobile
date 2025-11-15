// lib/features/home/presentation/views/chat.dart
import 'package:fitai_mobile/features/home/data/models/chat_thread_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitai_mobile/features/home/presentation/viewmodels/home_state.dart';
import 'package:fitai_mobile/features/home/presentation/views/plan_preview_screen.dart'
    show PlanPreviewBody;
import 'package:go_router/go_router.dart';
import 'package:fitai_mobile/features/home/presentation/viewmodels/chat_thread_provider.dart';
import 'package:fitai_mobile/core/widgets/app_chat_bubble.dart';
import 'package:fitai_mobile/core/widgets/app_chat_input_bar.dart';

class HomeHostScreen extends ConsumerWidget {
  const HomeHostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(homeViewProvider);

    // Nếu đang xem Plan Preview
    if (view == HomeView.plan) {
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
//// FREE PLAN – TEASER CARD
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
              label: const Text('Xem Plan Preview'),
              onPressed: () =>
                  ref.read(homeViewProvider.notifier).state = HomeView.plan,
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
        // Không có thread nào
        if (conversations.isEmpty && _selectedConversationId == null) {
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
                    child: const Center(
                      child: Text('Chưa có cuộc trò chuyện nào'),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const SafeArea(top: false, child: SizedBox.shrink()),
              ],
            ),
          );
        }

        // Nếu chỉ có 1 thread và chưa chọn → auto mở
        if (conversations.length == 1 && _selectedConversationId == null) {
          final c = conversations.first;
          return _ProPlanChat(
            conversationId: c.id,
            title: c.title,
            initialAiMessage: null,
            onBack: null,
          );
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
//// PRO PLAN – CHAT SCREEN
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
  final List<({String text, bool isMe})> _messages = [];
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    // Nếu là thread mới tạo, add luôn câu chào AI từ server
    if (widget.initialAiMessage != null &&
        widget.initialAiMessage!.trim().isNotEmpty) {
      _messages.add((text: widget.initialAiMessage!, isMe: false));
    }
  }

  Future<void> _handleSend(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _isSending) return;

    setState(() {
      _messages.add((text: trimmed, isMe: true)); // message của user
      _isSending = true;
    });

    try {
      final reply = await ref.read(
        sendChatMessageProvider(
          threadId: widget.conversationId,
          content: trimmed,
        ).future,
      );

      // reply là ChatMessage từ server (thường role = 'assistant' hay tương tự)
      setState(() {
        _messages.add((
          text: reply.content,
          isMe: reply.role == 'customer' ? true : false,
        ));
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gửi tin nhắn thất bại')));
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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

                  // ====== Vùng message scroll được ======
                  Expanded(child: _ChatMessageList(messages: _messages)),

                  const SizedBox(height: 8),

                  // ====== Input ======
                  AppChatInputBar(
                    onSend: _handleSend,
                    // nếu AppChatInputBar có hỗ trợ isLoading thì truyền thêm
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
//// WIDGET RENDER LIST MESSAGE
//// =======================

class _ChatMessageList extends StatelessWidget {
  const _ChatMessageList({super.key, required this.messages});

  final List<({String text, bool isMe})> messages;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 8),
      itemCount: messages.length,
      itemBuilder: (context, index) {
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
      },
    );
  }
}
