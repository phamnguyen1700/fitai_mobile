import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/services/advisor_service.dart';
import '../../data/repositories/advisor_repository.dart';
import '../../data/models/advisor_model.dart';

part 'advisor_provider.g.dart';

/// Provider cho AdvisorRepository – dùng ở controller / UI
@riverpod
AdvisorRepository advisorRepository(AdvisorRepositoryRef ref) {
  return AdvisorRepository(AdvisorService());
}

/// Provider load danh sách advisor (Future) – dùng trực tiếp ở UI nếu muốn
@riverpod
Future<List<AdvisorModel>> advisors(AdvisorsRef ref) async {
  final repo = ref.read(advisorRepositoryProvider);
  return repo.getAdvisors();
}
