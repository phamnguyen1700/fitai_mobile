import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fitai_mobile/features/profile_setup/data/repositories/dietary_preference_repository.dart';

part 'dietary_preference_providers.g.dart';

@riverpod
DietaryPreferenceRepository dietaryPreferenceRepository(
  DietaryPreferenceRepositoryRef ref,
) {
  return DietaryPreferenceRepository();
}
