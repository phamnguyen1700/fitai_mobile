// lib/features/payment/presentation/views/payment_result_screen.dart
import 'package:fitai_mobile/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';

import 'package:fitai_mobile/features/payment/presentation/widgets/first_plan_image_card.dart';

// Bodygram repo
import 'package:fitai_mobile/features/process/presentation/viewmodels/bodygram_providers.dart';
import 'package:fitai_mobile/core/status/bodygram_error.dart';
import 'package:fitai_mobile/features/home/presentation/viewmodels/body_data_providers.dart';
import 'package:fitai_mobile/features/profile_setup/data/models/bodygram_analyze_request.dart';

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

  /// true = đang hiển thị FirstPlanImageCard thay cho nội dung "Thanh toán thành công"
  bool _showBodyScan = false;

  /// Đang gọi analyze lần đầu khi bấm nút "Quét dữ liệu cơ thể"
  bool _isAnalyzingInitial = false;

  /// Lỗi từ bước analyze initial, dùng để truyền xuống FirstPlanImageCard
  String? _initialAnalyzeError;

  Future<void> _handleGoHome() async {
    if (widget.success) {
      await ref.read(authNotifierProvider.notifier).refreshProfile();
      await ref.read(subscriptionNotifierProvider.notifier).refresh();
    }

    if (!mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final subsState = ref.watch(subscriptionsProvider);
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: _showBodyScan
                  ? _buildBodyScanSection(context, user)
                  : _buildResultSection(context, t, cs, canChooseAdvisor, user),
            ),
          ),
        ),
      ),
    );
  }

  /// ================== UI: màn kết quả thanh toán ==================
  Widget _buildResultSection(
    BuildContext context,
    TextTheme t,
    ColorScheme cs,
    bool canChooseAdvisor,
    UserModel? user,
  ) {
    return Column(
      key: const ValueKey('payment-result'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.success ? "Thanh toán thành công!" : "Thanh toán thất bại",
          style: t.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          widget.success
              ? "Gói của bạn đã được kích hoạt.\nĐể AI cá nhân hoá kế hoạch, hãy quét dữ liệu cơ thể ngay bây giờ."
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

        // Advisor selector như cũ...
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
                                  borderRadius: BorderRadius.circular(16),
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
                                              (selectedModel.firstName ?? "?")
                                                  .characters
                                                  .first
                                                  .toUpperCase(),
                                              style: t.titleMedium?.copyWith(
                                                fontWeight: FontWeight.w700,
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
                                          color: selectedModel.rating > 0
                                              ? Colors.amber
                                              : cs.outline,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          selectedModel.rating.toStringAsFixed(
                                            1,
                                          ),
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
                            try {
                              final repo = ref.read(advisorRepositoryProvider);
                              await repo.assignAdvisor(
                                userId: user.id,
                                advisorId: selectedModel.id,
                              );

                              setState(() => _selectedAdvisor = selectedModel);

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
              );
            },
          ),

        const SizedBox(height: 20),

        if (!widget.success)
          _buildFailedButtons(context)
        else
          _buildSuccessButton(context),
      ],
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

  /// Nút chuyển sang flow analyze từ latest body data
  /// Nút chuyển sang flow analyze từ latest body data
  Widget _buildSuccessButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: _isAnalyzingInitial
            ? null
            : () async {
                setState(() {
                  _initialAnalyzeError = null;
                  _isAnalyzingInitial = true;
                });

                try {
                  // 1. Lấy latest body data
                  final latest = await ref.read(latestBodyDataProvider.future);

                  if (latest == null) {
                    // Không có dữ liệu → bắt người dùng chụp lại luôn
                    if (!mounted) return;
                    setState(() {
                      _initialAnalyzeError =
                          'Chưa có dữ liệu cơ thể, hãy chụp ảnh để bắt đầu.';
                      _showBodyScan = true;
                    });
                    return;
                  }

                  // 2. Gọi repo ANALYZE
                  final analyzeRepo = ref.read(
                    bodygramAnalyzeRepositoryProvider,
                  );

                  await analyzeRepo.analyze(
                    BodygramAnalyzeRequest(
                      bodyDataId: latest.id, // field tuỳ model của bạn
                      // nếu request có thêm param thì truyền ở đây
                    ),
                  );

                  // 3. Thành công → về Home
                  if (!mounted) return;
                  await _handleGoHome();
                } catch (e, st) {
                  debugPrint(
                    '[PaymentResultScreen] analyze initial ERROR: $e\n$st',
                  );

                  String msg;
                  if (e is BodygramAnalyzeException) {
                    msg = e.status.explanation;
                  } else {
                    msg =
                        'Phân tích dữ liệu cơ thể thất bại. '
                        'Hãy quét lại ảnh để tiếp tục.';
                  }

                  if (!mounted) return;
                  setState(() {
                    _initialAnalyzeError = msg;
                    _showBodyScan = true; // mở FirstPlanImageCard + show lỗi
                  });
                } finally {
                  if (mounted) {
                    setState(() => _isAnalyzingInitial = false);
                  }
                }
              },
        icon: _isAnalyzingInitial
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.photo_camera_outlined),
        label: Text(
          _isAnalyzingInitial
              ? 'Đang phân tích...'
              : 'Phân tích dữ liệu cơ thể',
        ),
      ),
    );
  }

  Widget _buildBodyScanSection(BuildContext context, UserModel? user) {
    if (user == null || user.height == null || user.weight == null) {
      return Column(
        key: const ValueKey('body-scan-missing-data'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Thiếu dữ liệu chiều cao / cân nặng. Vui lòng cập nhật hồ sơ trước.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () {
              setState(() => _showBodyScan = false);
            },
            child: const Text('Quay lại'),
          ),
        ],
      );
    }

    return Column(
      key: const ValueKey('body-scan-section'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () {
              setState(() => _showBodyScan = false);
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('Quay lại kết quả thanh toán'),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
          ),
          padding: const EdgeInsets.all(8),
          child: FirstPlanImageCard(
            heightCm: user.height!.toDouble(),
            weightKg: user.weight!.toDouble(),
            initialErrorMessage: _initialAnalyzeError,
            onUploadAndAnalyze:
                ({
                  required double height,
                  required double weight,
                  required String frontPath,
                  required String sidePath,
                }) async {
                  final repo = ref.read(bodygramRepositoryProvider);

                  await repo.uploadFromWeeklyCheckin(
                    height: height,
                    weight: weight,
                    frontPhotoPath: frontPath,
                    sidePhotoPath: sidePath,
                  );
                },
            onCompleted: () async {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã quét dữ liệu cơ thể và gửi AI phân tích!'),
                ),
              );
              await _handleGoHome();
            },
          ),
        ),
      ],
    );
  }
}
