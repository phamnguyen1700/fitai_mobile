import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/services/advisor_service.dart';
import '../../data/repositories/advisor_repository.dart';
import '../../data/models/advisor_model.dart';

part 'advisor_provider.g.dart';

/// Provider cho AdvisorService
@riverpod
AdvisorService advisorService(AdvisorServiceRef ref) {
  return AdvisorService();
}

/// Provider cho AdvisorRepository – dùng để gán advisor, v.v.
@riverpod
AdvisorRepository advisorRepository(AdvisorRepositoryRef ref) {
  final service = ref.watch(advisorServiceProvider);
  return AdvisorRepository(service);
}

/// Provider load danh sách advisor (Future) – dùng ở UI
@riverpod
Future<List<AdvisorModel>> advisors(AdvisorsRef ref) async {
  final repo = ref.watch(advisorRepositoryProvider);

  try {
    return await repo.getAdvisors();
  } catch (e, stack) {
    // Log debug nếu cần
    // ignore: avoid_print
    print('⚠️ Error loading advisors: $e');
    // ignore: avoid_print
    print(stack);

    throw Exception("Không thể tải danh sách advisor.");
  }
}
