// lib/features/home/presentation/viewmodels/home_state.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HomeView { chat, planDemo, planPreview }

final homeViewProvider = StateProvider<HomeView>((ref) => HomeView.chat);

// Plan của user
enum SubscriptionPlan { free, pro }

// Tạm thời: cho test thì để mặc định là free / pro tùy bạn
final subscriptionPlanProvider = StateProvider<SubscriptionPlan>(
  (ref) => SubscriptionPlan.pro,
);
