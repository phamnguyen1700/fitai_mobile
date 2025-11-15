import '../models/meal_demo_models.dart';
import '../services/meal_demo_service.dart';

class MealDemoRepository {
  final MealDemoService _api;

  MealDemoRepository(this._api);

  Future<MealDemoListResponse> getMealDemos({
    int pageNumber = 1,
    int pageSize = 15,
    bool? isDeleted,
  }) {
    return _api.getMealDemos(
      pageNumber: pageNumber,
      pageSize: pageSize,
      isDeleted: isDeleted,
    );
  }

  Future<List<MealDemo>> getMealDemoItems({
    int pageNumber = 1,
    int pageSize = 15,
    bool? isDeleted,
  }) async {
    final res = await getMealDemos(
      pageNumber: pageNumber,
      pageSize: pageSize,
      isDeleted: isDeleted,
    );
    return res.data;
  }

  Future<MealDemoDetailResponse> getMealDemoDetail(String mealDemoId) {
    return _api.getMealDemoDetail(mealDemoId);
  }

  /// Helper: chỉ cần list các menu detail
  Future<List<MealDemoDetail>> getMealDemoDetailItems(String mealDemoId) async {
    final res = await getMealDemoDetail(mealDemoId);
    return res.data;
  }
}
