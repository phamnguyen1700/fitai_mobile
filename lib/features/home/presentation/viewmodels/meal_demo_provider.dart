// lib/features/meal_demo/presentation/viewmodels/meal_demo_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/meal_demo_models.dart';
import '../../data/services/meal_demo_service.dart';
import '../../data/repositories/meal_demo_repository.dart';

part 'meal_demo_provider.g.dart';

/// Repo provider
@riverpod
MealDemoRepository mealDemoRepository(MealDemoRepositoryRef ref) {
  final service = MealDemoService();
  return MealDemoRepository(service);
}

@riverpod
Future<MealDemoListResponse> mealDemoList(
  MealDemoListRef ref, {
  int pageNumber = 1,
  int pageSize = 15,
  bool? isDeleted,
}) async {
  final repo = ref.watch(mealDemoRepositoryProvider);
  return repo.getMealDemos(
    pageNumber: pageNumber,
    pageSize: pageSize,
    isDeleted: isDeleted,
  );
}

@riverpod
Future<List<MealDemo>> mealDemoItems(
  MealDemoItemsRef ref, {
  int pageNumber = 1,
  int pageSize = 15,
  bool? isDeleted,
}) async {
  final repo = ref.watch(mealDemoRepositoryProvider);
  return repo.getMealDemoItems(
    pageNumber: pageNumber,
    pageSize: pageSize,
    isDeleted: isDeleted,
  );
}

/// Lấy chi tiết 1 meal demo (response đầy đủ)
@riverpod
Future<MealDemoDetailResponse> mealDemoDetail(
  MealDemoDetailRef ref,
  String mealDemoId,
) async {
  final repo = ref.watch(mealDemoRepositoryProvider);
  return repo.getMealDemoDetail(mealDemoId);
}

/// Lấy list menu (MealDemoDetail) theo mealDemoId
@riverpod
Future<List<MealDemoDetail>> mealDemoMenus(
  MealDemoMenusRef ref,
  String mealDemoId,
) async {
  final repo = ref.watch(mealDemoRepositoryProvider);
  return repo.getMealDemoDetailItems(mealDemoId);
}
