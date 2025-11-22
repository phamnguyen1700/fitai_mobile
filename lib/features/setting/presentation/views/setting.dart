import 'package:flutter/material.dart';
import '../widgets/section_card.dart';
import '../widgets/setting_tab_menu.dart';
import '../widgets/language_dropdown.dart';
import '../widgets/unit_group.dart';
import '../widgets/notification_group.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/security_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitai_mobile/features/auth/data/models/user_model.dart';
import 'package:fitai_mobile/features/auth/presentation/viewmodels/auth_providers.dart';
import 'package:intl/intl.dart';

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

class _ProfileTab extends ConsumerWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authNotifierProvider);

    return authStateAsync.when(
      loading: () => const SectionCard(
        title: 'Thông tin cá nhân',
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => SectionCard(
        title: 'Thông tin cá nhân',
        child: Text('Lỗi tải thông tin: $err'),
      ),
      data: (authState) {
        final user = authState.user;
        if (user == null) {
          return const SectionCard(
            title: 'Thông tin cá nhân',
            child: Text('Chưa có thông tin người dùng'),
          );
        }

        final displayName = _buildDisplayName(user);
        final stats = _buildStats(user);

        return Column(
          children: [
            SectionCard(
              title: 'Thông tin cá nhân',
              child: ProfileInfoCard(
                avatarUrl: user.profileImage,
                displayName: displayName,
                subtitle: user.email,
                stats: stats,
                goal: user.goal,
                readOnlyFields: const {'Chiều cao', 'Cân nặng'},
                onEdit: (updatedStats, updatedGoal) {
                  // TODO update API
                },
              ),
            ),
            const SizedBox(height: 12),
            SectionCard(
              title: 'Mật khẩu và bảo mật',
              child: SecurityCard(
                email: user.email,
                maskedPassword: '**********',
              ),
            ),
          ],
        );
      },
    );
  }

  // _buildDisplayName & _buildStats giữ nguyên như bạn đang dùng
}

String _buildDisplayName(UserModel user) {
  if (user.fullName != null && user.fullName!.trim().isNotEmpty) {
    return user.fullName!;
  }
  final name = '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim();
  return name.isEmpty ? 'Người dùng' : name;
}

Map<String, String> _buildStats(UserModel user) {
  final dateFormat = DateFormat('dd/MM/yyyy');

  String genderLabel;
  switch (user.gender) {
    case Gender.M:
      genderLabel = 'Nam';
      break;
    case Gender.F:
      genderLabel = 'Nữ';
      break;
    default:
      genderLabel = '-';
  }

  return {
    'Họ': user.firstName ?? '',
    'Tên': user.lastName ?? '',
    'Ngày sinh': user.dateOfBirth != null
        ? dateFormat.format(user.dateOfBirth!.toLocal())
        : '-',
    'Giới tính': genderLabel,
    'Chiều cao (khóa)': user.height != null
        ? '${user.height!.toStringAsFixed(0)} cm'
        : '-',

    'Cân nặng (khóa)': user.weight != null
        ? '${user.weight!.toStringAsFixed(1)} kg'
        : '-',
  };
}

class _NotificationsTab extends StatelessWidget {
  const _NotificationsTab();
  @override
  Widget build(BuildContext context) {
    return const SectionCard(title: 'Thông báo', child: NotificationGroup());
  }
}
