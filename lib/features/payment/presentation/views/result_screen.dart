import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';

import '../widgets/advisor_selector.dart';
import '../../data/models/advisor_model.dart';
import '../viewmodels/advisor_provider.dart';
import 'package:fitai_mobile/features/auth/presentation/viewmodels/auth_providers.dart';
import '../viewmodels/subscriptions_provider.dart';

class PaymentResultScreen extends ConsumerStatefulWidget {
  final bool success;

  const PaymentResultScreen({super.key, required this.success});

  @override
  ConsumerState<PaymentResultScreen> createState() =>
      _PaymentResultScreenState();
}

class _PaymentResultScreenState extends ConsumerState<PaymentResultScreen> {
  AdvisorModel? _selectedAdvisor;

  Future<void> _handleGoHome() async {
    if (widget.success) {
      // 1. Refresh profile user (gọi lại /me hoặc tương đương)
      await ref.read(authNotifierProvider.notifier).refreshProfile();

      // 2. Refresh lại subscription hiện tại (gói đã được kích hoạt sau payment)
      await ref.read(subscriptionNotifierProvider.notifier).refresh();
    }

    if (!mounted) return;
    context.go('/home');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final subsState = ref.watch(subscriptionsProvider);
    final user = ref.watch(currentUserProvider);

    final bool canChooseAdvisor =
        widget.success && (subsState.selectedProduct?.isAdvisor ?? false);

    return AppScaffold(
      appBar: const AppAppBar(title: "Thanh toán"),
      showLegalFooter: true,
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.success
                      ? "Thanh toán thành công!"
                      : "Thanh toán thất bại",
                  style: t.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                Text(
                  widget.success
                      ? "Gói của bạn đã được kích hoạt."
                      : "Thẻ bị từ chối hoặc không đủ số dư.\nVui lòng thử lại.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                Image.asset(
                  widget.success
                      ? "lib/core/assets/images/success.png"
                      : "lib/core/assets/images/failed.png",
                  width: 140,
                  height: 140,
                ),

                const SizedBox(height: 24),

                /// ==========================
                ///  Chọn advisor (nếu có quyền)
                /// ==========================
                if (canChooseAdvisor)
                  Builder(
                    builder: (ctx) {
                      final advisorsAsync = ref.watch(advisorsProvider);

                      return advisorsAsync.when(
                        loading: () => const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(),
                        ),
                        error: (err, st) {
                          // Log thêm cho dễ debug
                          // ignore: avoid_print
                          print('❌ Load advisors error: $err');
                          // ignore: avoid_print
                          print(st);
                          return Text("Không tải được danh sách advisor");
                        },
                        data: (advisors) {
                          if (advisors.isEmpty) {
                            return Text(
                              "Hiện chưa có advisor khả dụng.",
                              style: t.bodyMedium,
                            );
                          }

                          return Column(
                            children: [
                              Text(
                                "Hãy chọn người đồng hành phù hợp:",
                                textAlign: TextAlign.center,
                                style: t.bodyMedium,
                              ),
                              const SizedBox(height: 12),

                              AdvisorSelector(
                                advisors: advisors
                                    .map(
                                      (e) => Advisor(
                                        id: e.id,
                                        firstName: e.firstName ?? "",
                                        lastName: e.lastName ?? "",
                                        rating: e.rating,
                                        profilePicture: e.profilePicture,
                                      ),
                                    )
                                    .toList(),
                                onSelected: (a) async {
                                  final selectedModel = advisors.firstWhere(
                                    (x) => x.id == a.id,
                                  );

                                  if (user == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Bạn cần đăng nhập để chọn advisor.",
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        title: const Center(
                                          child: Text("Xác nhận chọn advisor"),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircleAvatar(
                                              radius: 32,
                                              backgroundColor:
                                                  cs.surfaceContainerHighest,
                                              backgroundImage:
                                                  (selectedModel
                                                              .profilePicture !=
                                                          null &&
                                                      selectedModel
                                                          .profilePicture!
                                                          .isNotEmpty)
                                                  ? NetworkImage(
                                                      selectedModel
                                                          .profilePicture!,
                                                    )
                                                  : null,
                                              child:
                                                  (selectedModel
                                                              .profilePicture ==
                                                          null ||
                                                      selectedModel
                                                          .profilePicture!
                                                          .isEmpty)
                                                  ? Text(
                                                      (selectedModel
                                                                  .firstName ??
                                                              "?")
                                                          .characters
                                                          .first
                                                          .toUpperCase(),
                                                      style: t.titleMedium
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                    )
                                                  : null,
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              selectedModel.fullName,
                                              textAlign: TextAlign.center,
                                              style: t.titleMedium?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.star_rounded,
                                                  size: 18,
                                                  color:
                                                      selectedModel.rating > 0
                                                      ? Colors.amber
                                                      : cs.outline,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  selectedModel.rating
                                                      .toStringAsFixed(1),
                                                  style: t.bodySmall,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                          ],
                                        ),
                                        actionsPadding:
                                            const EdgeInsets.fromLTRB(
                                              16,
                                              0,
                                              16,
                                              12,
                                            ),
                                        actions: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: FilledButton(
                                                  onPressed: () => Navigator.of(
                                                    ctx,
                                                  ).pop(true),
                                                  child: const Text("Xác nhận"),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: FilledButton.tonal(
                                                  onPressed: () => Navigator.of(
                                                    ctx,
                                                  ).pop(false),
                                                  child: const Text("Hủy"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirmed == true) {
                                    try {
                                      final repo = ref.read(
                                        advisorRepositoryProvider,
                                      );
                                      await repo.assignAdvisor(
                                        userId: user.id,
                                        advisorId: selectedModel.id,
                                      );

                                      setState(
                                        () => _selectedAdvisor = selectedModel,
                                      );

                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Đã gán advisor: ${selectedModel.fullName} cho bạn!",
                                            ),
                                          ),
                                        );
                                      }

                                      // Nếu muốn reload list sau khi gán:
                                      // ref.invalidate(advisorsProvider);
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Có lỗi khi gán advisor. Vui lòng thử lại.",
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),

                const SizedBox(height: 20),

                if (!widget.success)
                  _buildFailedButtons(context)
                else
                  _buildSuccessButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFailedButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => context.push('/payment/processing'),
            child: const Text("Thử lại"),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: FilledButton(
            onPressed: () => context.go('/payment/checkout'),
            child: const Text("Chọn phương thức khác"),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: _handleGoHome,
        child: const Text("Tiếp tục vào trang chủ"),
      ),
    );
  }
}
