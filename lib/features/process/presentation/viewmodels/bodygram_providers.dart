import 'package:flutter_riverpod/flutter_riverpod.dart';

// Service & Repo nằm trong profile_setup
import 'package:fitai_mobile/features/profile_setup/data/services/bodygram_api_service.dart';
import 'package:fitai_mobile/features/process/data/repositories/bodygram_repository.dart';

/// API service cho Bodygram – dùng ApiClient.account()
final bodygramApiServiceProvider = Provider<BodygramApiService>(
  (ref) => BodygramApiService(),
);

/// Repository chỉ cần BodygramApiService
final bodygramRepositoryProvider = Provider<BodygramRepository>((ref) {
  final api = ref.read(bodygramApiServiceProvider);
  return BodygramRepository(api);
});
