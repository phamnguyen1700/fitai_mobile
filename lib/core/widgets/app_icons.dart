import 'package:flutter/material.dart';

/// Centralized icon set (Material 3 friendly).
/// Khi cần thay đổi hệ icon (Filled/Outlined/Rounded), chỉnh ở đây là toàn app đổi.
class AppIcons {
  // Common
  static const IconData back = Icons.arrow_back; // M3
  static const IconData resend = Icons.refresh; // or Icons.restart_alt

  // Auth / 2FA
  static const IconData mail = Icons.mail; // filled
  static const IconData mailOutline = Icons.mail_outline; // outlined

  // Bottom nav tabs
  static const IconData home = Icons.home; // selected
  static const IconData homeOutline = Icons.home_outlined; // unselected

  static const IconData workout = Icons.fitness_center; // selected
  static const IconData workoutOutline =
      Icons.fitness_center_outlined; // unselected

  static const IconData meal = Icons.menu_book; // selected
  static const IconData mealOutline = Icons.menu_book_outlined; // unselected

  static const IconData progress = Icons.show_chart; // selected
  static const IconData progressOutline =
      Icons.show_chart_outlined; // unselected

  static const IconData profile = Icons.person; // selected
  static const IconData profileOutline = Icons.person_outline; // unselected
}
