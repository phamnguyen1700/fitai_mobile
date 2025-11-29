import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitai_mobile/features/home/data/models/latest_body_data.dart';
import 'package:fitai_mobile/features/home/data/repositories/body_data_repository.dart';

/// Provider cho BodyDataRepository
final bodyDataRepositoryProvider = Provider<BodyDataRepository>((ref) {
  return BodyDataRepository();
});

/// FutureProvider: lấy latest body data của current user
///
/// - Trả về `LatestBodyDataModel?`
/// - `null` nếu user chưa có dữ liệu.
final latestBodyDataProvider = FutureProvider.autoDispose<LatestBodyDataModel?>(
  (ref) async {
    final repo = ref.read(bodyDataRepositoryProvider);
    return repo.getLatestBodyData();
  },
);
