import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/checkpoint_note_models.dart';
import '../../data/services/checkpoint_note_service.dart';
import '../../data/repositories/checkpoint_note_repository.dart';

part 'checkpoint_note_providers.g.dart';

/// ===============================
/// SERVICE PROVIDER
/// ApiClient.fitness() đã được inject bên trong Service
/// ===============================
@riverpod
CheckpointNoteService checkpointNoteService(CheckpointNoteServiceRef ref) {
  return CheckpointNoteService();
}

/// ===============================
/// REPOSITORY PROVIDER
/// Repo sử dụng service ở trên
/// ===============================
@riverpod
CheckpointNoteRepository checkpointNoteRepository(
  CheckpointNoteRepositoryRef ref,
) {
  final service = ref.watch(checkpointNoteServiceProvider);
  return CheckpointNoteRepository(service);
}

/// ===============================
/// CONTROLLER — SUBMIT NOTE
/// Giống mutation: gọi API để lưu note
/// ===============================
@riverpod
class CheckpointNoteController extends _$CheckpointNoteController {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null); // state rỗng ban đầu
  }

  /// Gọi API để submit note
  Future<bool> submitNote(CheckpointNoteRequest req) async {
    final repo = ref.read(checkpointNoteRepositoryProvider);

    state = const AsyncLoading();

    try {
      final success = await repo.saveNote(req);

      // reset state về Data rỗng cho lần submit tiếp theo
      state = const AsyncData(null);
      return success;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}
