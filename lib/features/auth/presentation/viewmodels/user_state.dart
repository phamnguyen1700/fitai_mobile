import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Fake model user
class AppUser {
  final String id;
  final String name;
  final String? avatar;

  const AppUser({required this.id, required this.name, this.avatar});
}

/// Provider lưu user hiện tại
final currentUserProvider = StateProvider<AppUser?>((ref) {
  // giả lập user sau khi login
  return const AppUser(
    id: 'u123',
    name: 'Thảo Vi',
    avatar: 'https://i.pravatar.cc/150?img=5',
  );
});

/// Fake dữ liệu tổng quan hôm nay (workouts/meals)
final todaySummaryProvider = FutureProvider.autoDispose((ref) async {
  // delay giả lập call API
  await Future.delayed(const Duration(milliseconds: 600));

  // trả về dữ liệu giả
  return (workouts: 3, meals: 4);
});
