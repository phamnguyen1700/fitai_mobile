import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/bodygram_api_service.dart';
import '../../data/repositories/bodygram_repository.dart';

// 🔹 Auth repo & provider – chỉnh import cho đúng với project của bạn
import 'package:fitai_mobile/features/auth/presentation/viewmodels/auth_providers.dart';

final bodygramApiServiceProvider = Provider<BodygramApiService>(
  (ref) => BodygramApiService(),
);

final bodygramRepositoryProvider = Provider<BodygramRepository>((ref) {
  final api = ref.read(bodygramApiServiceProvider);
  final authRepo = ref.read(
    authRepositoryProvider,
  ); // 👈 tên provider này chỉnh cho đúng
  return BodygramRepository(api, authRepo);
});
