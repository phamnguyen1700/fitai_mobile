import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/user_data.dart';

final profileDraftProvider = StateProvider<ProfileDraft>(
  (ref) => ProfileDraft(),
);
