import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SubscriptionTier { free, pro }

final subscriptionTierProvider = StateProvider<SubscriptionTier>((ref) {
  return SubscriptionTier.free;
});
