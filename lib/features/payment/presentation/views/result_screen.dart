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

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    // ⭐ Lấy subscription state để biết gói hiện tại
    final subsState = ref.watch(subscriptionsProvider);

    // Lấy user hiện tại để dùng userId khi assign advisor
    final user = ref.watch(currentUserProvider);

    // Load advisors từ API
    final advisorsAsync = ref.watch(advisorsProvider);

    // ⭐ Chỉ cho chọn advisor nếu:
    // - Thanh toán thành công
    // - Và gói đã mua có isAdvisor = true
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

                // Ảnh biểu tượng
                Image.asset(
                  widget.success
                      ? "lib/core/assets/images/success.png"
                      : "lib/core/assets/images/failed.png",
                  width: 140,
                  height: 140,
                ),

                const SizedBox(height: 24),

                // ===========================
                //  SELECT ADVISOR (nếu gói có advisor)
                // ===========================
                if (canChooseAdvisor)
                  advisorsAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(),
                    ),
                    error: (err, st) =>
                        Text("Không tải được danh sách advisor"),
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

                          /// Selector
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
                              // Map lại sang AdvisorModel
                              final selectedModel = advisors.firstWhere(
                                (x) => x.id == a.id,
                              );

                              // Nếu chưa login (lý thuyết không xảy ra), chặn luôn
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

                              // Hiện dialog xác nhận
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    title: const Center(
                                      child: Text("Xác nhận chọn advisor"),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Avatar trên
                                        CircleAvatar(
                                          radius: 32,
                                          backgroundColor:
                                              cs.surfaceContainerHighest,
                                          backgroundImage:
                                              (selectedModel.profilePicture !=
                                                      null &&
                                                  selectedModel
                                                      .profilePicture!
                                                      .isNotEmpty)
                                              ? NetworkImage(
                                                  selectedModel.profilePicture!,
                                                )
                                              : null,
                                          child:
                                              (selectedModel.profilePicture ==
                                                      null ||
                                                  selectedModel
                                                      .profilePicture!
                                                      .isEmpty)
                                              ? Text(
                                                  (selectedModel.firstName ??
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

                                        // Tên
                                        Text(
                                          selectedModel.fullName,
                                          textAlign: TextAlign.center,
                                          style: t.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),

                                        // Rating dưới tên
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.star_rounded,
                                              size: 18,
                                              color: selectedModel.rating > 0
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
                                    actionsPadding: const EdgeInsets.fromLTRB(
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
                                              onPressed: () =>
                                                  Navigator.of(ctx).pop(true),
                                              child: const Text("Xác nhận"),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: FilledButton.tonal(
                                              onPressed: () =>
                                                  Navigator.of(ctx).pop(false),
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
                                // Gọi API assign advisor
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Đã gán advisor: ${selectedModel.fullName} cho bạn!",
                                        ),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
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
                  ),

                const SizedBox(height: 20),

                // ===========================
                // NÚT CUỐI
                // ===========================
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

  /// Nút khi thanh toán thất bại
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

  /// Nút khi thanh toán thành công
  /// (chỉ điều hướng, không gọi assign nữa vì assign đã làm trong dialog)
  Widget _buildSuccessButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () => context.go('/home'),
        child: const Text("Tiếp tục vào trang chủ"),
      ),
    );
  }
}
