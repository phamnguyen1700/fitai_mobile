import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/workout_demo_models.dart';
import '../../data/repositories/workout_demo_repository.dart';

part 'workout_demo_provider.g.dart';

@riverpod
class WorkoutDemoList extends _$WorkoutDemoList {
  final _repo = WorkoutDemoRepository();

  @override
  AsyncValue<WorkoutDemoListResponse?> build() {
    _load();
    return const AsyncLoading();
  }

  Future<void> _load({int page = 1, int size = 15, bool? isDeleted}) async {
    try {
      final res = await _repo.fetch(
        pageNumber: page,
        pageSize: size,
        isDeleted: isDeleted,
      );
      state = AsyncData(res);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> reload({int page = 1, int size = 15, bool? isDeleted}) =>
      _load(page: page, size: size, isDeleted: isDeleted);
}
