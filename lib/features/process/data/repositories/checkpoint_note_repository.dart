import '../services/checkpoint_note_service.dart';
import 'package:fitai_mobile/features/process/data/models/checkpoint_note_models.dart';

class CheckpointNoteRepository {
  final CheckpointNoteService _service;

  CheckpointNoteRepository(this._service);

  Future<bool> saveNote(CheckpointNoteRequest req) {
    return _service.saveNoteSuccess(req);
  }
}
