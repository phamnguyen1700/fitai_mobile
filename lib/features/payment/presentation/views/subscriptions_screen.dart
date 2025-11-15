import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_bar.dart';
import '../viewmodels/subscriptions_provider.dart';
import '../widgets/subscription_grid_cell.dart';

class SubscriptionsScreen extends ConsumerWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(subscriptionsProvider.notifier);
    final state = ref.watch(subscriptionsProvider);
    final products = notifier.products;

    final loading = products.isEmpty;

    final pageController = PageController(viewportFraction: 0.75);

    final screenHeight = MediaQuery.of(context).size.height;
    final pageHeight = screenHeight * 0.53;

    return AppScaffold(
      appBar: const AppAppBar(title: 'Nâng cấp gói'),
      showLegalFooter: true,
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const SizedBox(height: 20),
          Center(
            child: Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.workspace_premium_rounded,
                      size: 40,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mở khoá toàn bộ kế hoạch cá nhân',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Chọn gói phù hợp để bắt đầu hành trình tập luyện & dinh dưỡng 30 ngày.',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    if (loading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else
                      SizedBox(
                        height: pageHeight,
                        child: PageView.builder(
                          controller: pageController,
                          itemCount: products.length,
                          onPageChanged: (index) {
                            notifier.selectProduct(products[index]);
                          },
                          itemBuilder: (context, i) {
                            final p = products[i];
                            final selected = state.selectedProduct?.id == p.id;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: SubscriptionGridCell(
                                product: p,
                                selected: selected,
                                onSelect: () => notifier.selectProduct(p),
                                onChoose: () {
                                  notifier.selectProduct(p);
                                  context.push('/payment/checkout');
                                },
                              ),
                            );
                          },
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
  }
}
