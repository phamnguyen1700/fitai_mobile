import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fitai_mobile/features/profile_setup/data/repositories/full_profile_repository.dart';

part 'full_profile_providers.g.dart';

@riverpod
FullProfileRepository fullProfileRepository(FullProfileRepositoryRef ref) {
  return FullProfileRepository();
}
