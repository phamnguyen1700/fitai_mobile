import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/user_data.dart';

// Giữ state hồ sơ xuyên 3 bước (UI only)
final profileDraftProvider = StateProvider<ProfileDraft>(
  (ref) => ProfileDraft(),
);
