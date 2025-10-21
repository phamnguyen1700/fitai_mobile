// lib/features/home/presentation/viewmodels/home_state.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HomeView { chat, plan }

final homeViewProvider = StateProvider<HomeView>((ref) => HomeView.chat);
