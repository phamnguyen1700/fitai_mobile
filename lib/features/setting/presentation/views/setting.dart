// lib/features/setting/presentation/views/setting.dart
import 'package:flutter/material.dart';
import '../widgets/section_card.dart';
import '../widgets/setting_tab_menu.dart';
import '../widgets/language_dropdown.dart';
import '../widgets/unit_group.dart';
import '../widgets/notification_group.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/security_card.dart';

enum SettingTab { general, profile, notifications }

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  SettingTab _tab = SettingTab.general;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionCard(
            title: 'Cài đặt',
            child: SettingTabMenu(
              current: _tab,
              onChanged: (t) => setState(() => _tab = t),
              items: const [
                ('Cài đặt chung', SettingTab.general),
                ('Cài đặt trang cá nhân', SettingTab.profile),
                ('Cài đặt thông báo', SettingTab.notifications),
              ],
            ),
          ),
          const SizedBox(height: 12),
          switch (_tab) {
            SettingTab.general => const _GeneralTab(),
            SettingTab.profile => const _ProfileTab(),
            SettingTab.notifications => const _NotificationsTab(),
          },
        ],
      ),
    );
  }
}

class _GeneralTab extends StatefulWidget {
  const _GeneralTab();
  @override
  State<_GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends State<_GeneralTab> {
  String _language = 'vi';
  WeightUnit _w = WeightUnit.kg;
  HeightUnit _h = HeightUnit.cm;
  EnergyUnit _e = EnergyUnit.kcal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionCard(
          title: 'Ngôn ngữ',
          child: LanguageDropdown(
            value: _language,
            onChanged: (v) => setState(() => _language = v ?? 'vi'),
            items: const [('Tiếng Việt (đang dùng)', 'vi'), ('English', 'en')],
          ),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: 'Cài đặt đơn vị đo',
          child: UnitGroup(
            weight: _w,
            height: _h,
            energy: _e,
            onChangedWeight: (v) => setState(() => _w = v),
            onChangedHeight: (v) => setState(() => _h = v),
            onChangedEnergy: (v) => setState(() => _e = v),
          ),
        ),
        const SizedBox(height: 12),
        SectionCard(title: 'Thông báo', child: NotificationGroup()),
      ],
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionCard(
          title: 'Thông tin cá nhân',
          child: ProfileInfoCard(
            avatarUrl: null,
            displayName: 'Nguyễn Văn A',
            subtitle: 'debra.holt@example.com',
            stats: const {
              'Họ tên đầy đủ': 'Nguyễn Văn A',
              'Ngày sinh': '12/08/1997',
              'Chiều cao': '172 cm',
              'Cân nặng': '68.5 kg',
              'Giới tính': 'Nam',
              'Mục tiêu': 'Giảm cân',
            },
            onEdit: () {},
          ),
        ),
        const SizedBox(height: 12),
        const SectionCard(
          title: 'Mật khẩu và bảo mật',
          child: SecurityCard(
            email: 'daylamail@gmail.com',
            maskedPassword: '**********',
          ),
        ),
      ],
    );
  }
}

class _NotificationsTab extends StatelessWidget {
  const _NotificationsTab();
  @override
  Widget build(BuildContext context) {
    return const SectionCard(title: 'Thông báo', child: NotificationGroup());
  }
}
