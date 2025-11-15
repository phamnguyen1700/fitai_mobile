import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fitai_mobile/features/payment/data/models/subscription_product.dart';
import 'package:fitai_mobile/features/payment/data/repositories/subscription_repository.dart';

part 'subscriptions_provider.g.dart';

@riverpod
class Subscriptions extends _$Subscriptions {
  late final SubscriptionRepository _repo = SubscriptionRepository();

  List<SubscriptionProduct> get products => state.products;

  @override
  SubscriptionsState build() {
    _fetchProducts();
    return const SubscriptionsState();
  }

  Future<void> _fetchProducts() async {
    try {
      final list = await _repo.getActiveProducts();
      state = state.copyWith(products: list);
    } catch (_) {
      // lỗi chi tiết đã xử lý trong repository / interceptors
    }
  }

  void selectProduct(SubscriptionProduct product) {
    state = state.copyWith(selectedProduct: product);
  }

  /// NEW: chọn phương thức thanh toán
  void selectMethod(String methodId) {
    state = state.copyWith(selectedMethodId: methodId);
  }
}

/// ========== STATE CLASS ==========
class SubscriptionsState {
  final List<SubscriptionProduct> products;
  final SubscriptionProduct? selectedProduct;

  /// NEW: 'paypal' | 'visa' | 'momo' | ...
  final String? selectedMethodId;

  const SubscriptionsState({
    this.products = const [],
    this.selectedProduct,
    this.selectedMethodId,
  });

  SubscriptionsState copyWith({
    List<SubscriptionProduct>? products,
    SubscriptionProduct? selectedProduct,
    String? selectedMethodId,
  }) {
    return SubscriptionsState(
      products: products ?? this.products,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      selectedMethodId: selectedMethodId ?? this.selectedMethodId,
    );
    // Nếu muốn reset về null khi truyền null, đổi dòng trên thành:
    // selectedMethodId: selectedMethodId ?? this.selectedMethodId,
  }
}
