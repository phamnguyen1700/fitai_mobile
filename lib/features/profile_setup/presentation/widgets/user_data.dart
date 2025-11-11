import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fitai_mobile/features/auth/data/models/user_model.dart';
import 'package:fitai_mobile/features/profile_setup/data/models/activity_level_metadata.dart';

/// =====================
/// ProfileDraft – map với API
/// =====================
class ProfileDraft {
  String? firstName;
  String? lastName;
  DateTime? dateOfBirth;

  double? height;
  double? weight;
  Gender? gender;
  Goal? goal;
  ActivityLevel? activityLevel;

  // Body & diet
  String? localPhotoPath;
  String? frontBodyPhotoPath;
  String? sideBodyPhotoPath;

  // Diet fields
  int mealsPerDay;
  Set<String> dietLikes;
  Set<String> dietDislikes;
  String? extraFoods;
  String? cuisineType;
  String? allergies;

  ProfileDraft({
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.height,
    this.weight,
    this.gender,
    this.goal,
    this.activityLevel = ActivityLevel.Sedentary,
    this.localPhotoPath,
    this.frontBodyPhotoPath,
    this.sideBodyPhotoPath,
    this.mealsPerDay = 3,
    Set<String>? dietLikes,
    Set<String>? dietDislikes,
    this.extraFoods,
    this.cuisineType,
    this.allergies,
  }) : dietLikes = dietLikes ?? {},
       dietDislikes = dietDislikes ?? {};

  factory ProfileDraft.fromUser(UserModel user) => ProfileDraft(
    firstName: user.firstName,
    lastName: user.lastName,
    dateOfBirth: user.dateOfBirth,
    height: user.height,
    weight: user.weight,
    gender: user.gender,
    goal: user.goal,
    activityLevel: user.activityLevel ?? ActivityLevel.Sedentary,
  );
}

extension ProfileDraftDietDto on ProfileDraft {
  Map<String, dynamic> toDietDto() => {
    'mealsPerDay': mealsPerDay,
    'cuisineType': cuisineType,
    'allergies': allergies,
    'preferredIngredients': dietLikes.isNotEmpty ? dietLikes.join(', ') : null,
    'avoidIngredients': dietDislikes.isNotEmpty
        ? dietDislikes.join(', ')
        : null,
    'notes': extraFoods,
  }..removeWhere((_, v) => v == null);
}

/// =====================
/// Step indicator header
/// =====================
class StepHeader extends StatelessWidget {
  const StepHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.current,
  });

  final String title;
  final String subtitle;
  final int current; // 1..3

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    TextStyle dot(bool active) => TextStyle(
      color: active ? cs.primary : cs.outline,
      fontWeight: FontWeight.w600,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Center(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(subtitle, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('1', style: dot(current == 1)),
                  Text('  Tổng quan  ', style: dot(current == 1)),
                  Text('–', style: dot(false)),
                  const SizedBox(width: 8),
                  Text('2', style: dot(current == 2)),
                  Text('  Cơ thể  ', style: dot(current == 2)),
                  Text('–', style: dot(false)),
                  const SizedBox(width: 8),
                  Text('3', style: dot(current == 3)),
                  Text('  Chế độ', style: dot(current == 3)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

/// =====================
/// Common UI helpers
/// =====================
class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}

class AppContinueButton extends StatelessWidget {
  const AppContinueButton({
    super.key,
    required this.onPressed,
    this.label = 'Tiếp tục',
  });
  final VoidCallback onPressed;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.arrow_forward),
        label: Text(label),
      ),
    );
  }
}

// STEP 1 – Tổng quan (full DTO)
class UserDataFormCard extends StatefulWidget {
  const UserDataFormCard({
    super.key,
    required this.initial,
    required this.onSubmit,
    required this.activityLevels,
  });

  final ProfileDraft initial;
  final ValueChanged<ProfileDraft> onSubmit;
  final List<ActivityLevelMetadata> activityLevels;

  @override
  State<UserDataFormCard> createState() => _UserDataFormCardState();
}

class _UserDataFormCardState extends State<UserDataFormCard> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameCtl;
  late final TextEditingController _lastNameCtl;
  late final TextEditingController _hCtl;
  late final TextEditingController _wCtl;
  late final TextEditingController _dobCtl;

  Gender? _gender;
  Goal? _goal;
  ActivityLevel _activityLevel = ActivityLevel.Sedentary;
  DateTime? _dob;

  @override
  void initState() {
    super.initState();
    _firstNameCtl = TextEditingController(text: widget.initial.firstName ?? '');
    _lastNameCtl = TextEditingController(text: widget.initial.lastName ?? '');
    _hCtl = TextEditingController(
      text: widget.initial.height?.toString() ?? '',
    );
    _wCtl = TextEditingController(
      text: widget.initial.weight?.toString() ?? '',
    );
    _dob = widget.initial.dateOfBirth;
    _dobCtl = TextEditingController(
      text: _dob != null ? _formatDate(_dob!) : '',
    );
    _gender = widget.initial.gender ?? Gender.M;
    _goal = widget.initial.goal;
    _activityLevel = widget.initial.activityLevel ?? ActivityLevel.Sedentary;
  }

  @override
  void dispose() {
    _firstNameCtl.dispose();
    _lastNameCtl.dispose();
    _hCtl.dispose();
    _wCtl.dispose();
    _dobCtl.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  String? _numReq(String? v, {double? min, double? max}) {
    if (v == null || v.trim().isEmpty) return 'Bắt buộc';
    final n = double.tryParse(v.replaceAll(',', '.'));
    if (n == null) return 'Không hợp lệ';
    if (min != null && n < min) return '≥ $min';
    if (max != null && n > max) return '≤ $max';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const StepHeader(
          title: 'Thiết lập hồ sơ cá nhân',
          subtitle: 'Điền thông tin cơ bản để AI thiết kế kế hoạch riêng.',
          current: 1,
        ),
        SectionCard(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // First & last name
                TextFormField(
                  controller: _firstNameCtl,
                  decoration: const InputDecoration(
                    labelText: 'Họ',
                    hintText: 'Nhập họ',
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Bắt buộc' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _lastNameCtl,
                  decoration: const InputDecoration(
                    labelText: 'Tên đệm và tên',
                    hintText: 'Nhập tên',
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Bắt buộc' : null,
                ),
                const SizedBox(height: 16),

                // DOB
                TextFormField(
                  controller: _dobCtl,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Ngày sinh',
                    hintText: 'Chọn ngày sinh',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    final now = DateTime.now();
                    final firstDate = DateTime(now.year - 100);
                    final lastDate = DateTime(now.year - 10);
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _dob ?? DateTime(now.year - 20),
                      firstDate: firstDate,
                      lastDate: lastDate,
                    );
                    if (picked != null) {
                      setState(() {
                        _dob = picked;
                        _dobCtl.text = _formatDate(picked);
                      });
                    }
                  },
                  validator: (_) => _dob == null ? 'Chọn ngày sinh' : null,
                ),
                const SizedBox(height: 16),

                // Height / Weight
                TextFormField(
                  controller: _hCtl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Chiều cao (cm)',
                    hintText: 'Nhập chiều cao (cm)',
                  ),
                  validator: (v) => _numReq(v, min: 80, max: 250),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _wCtl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Cân nặng (kg)',
                    hintText: 'Nhập cân nặng (kg)',
                  ),
                  validator: (v) => _numReq(v, min: 25, max: 300),
                ),
                const SizedBox(height: 16),

                _GenderSelector(
                  value: _gender ?? Gender.M,
                  onChanged: (g) => setState(() => _gender = g),
                ),
                const SizedBox(height: 12),
                _GoalDropdown(
                  value: _goal,
                  onChanged: (g) => setState(() => _goal = g),
                ),
                const SizedBox(height: 12),
                _ActivityLevelDropdown(
                  value: _activityLevel,
                  options: widget.activityLevels,
                  onChanged: (al) => setState(() => _activityLevel = al),
                ),
              ],
            ),
          ),
        ),
        AppContinueButton(
          onPressed: () {
            if (!(_formKey.currentState?.validate() ?? false)) return;

            final draft = widget.initial
              ..firstName = _firstNameCtl.text.trim()
              ..lastName = _lastNameCtl.text.trim()
              ..dateOfBirth = _dob
              ..height = double.parse(_hCtl.text.replaceAll(',', '.'))
              ..weight = double.parse(_wCtl.text.replaceAll(',', '.'))
              ..gender = _gender
              ..goal = _goal
              ..activityLevel = _activityLevel;

            widget.onSubmit(draft);
          },
        ),
      ],
    );
  }
}

class _GenderSelector extends StatelessWidget {
  const _GenderSelector({required this.value, required this.onChanged});
  final Gender value;
  final ValueChanged<Gender> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 12),
        ChoiceChip(
          selected: value == Gender.M,
          label: const Text('Nam'),
          onSelected: (_) => onChanged(Gender.M),
        ),
        const SizedBox(width: 8),
        ChoiceChip(
          selected: value == Gender.F,
          label: const Text('Nữ'),
          onSelected: (_) => onChanged(Gender.F),
        ),
      ],
    );
  }
}

class _GoalDropdown extends StatelessWidget {
  const _GoalDropdown({this.value, required this.onChanged});
  final Goal? value;
  final ValueChanged<Goal?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Goal>(
      value: value,
      decoration: const InputDecoration(labelText: 'Mục tiêu'),
      items: const [
        DropdownMenuItem(
          value: Goal.Weight_Loss,
          child: Text('Giảm mỡ / Giảm cân'),
        ),
        DropdownMenuItem(value: Goal.Maintain_Weight, child: Text('Giữ cân')),
        DropdownMenuItem(value: Goal.Weight_Gain, child: Text('Tăng cân')),
        DropdownMenuItem(value: Goal.Build_Muscle, child: Text('Tăng cơ')),
      ],
      onChanged: onChanged,
      validator: (v) => v == null ? 'Chọn mục tiêu' : null,
    );
  }
}

class _ActivityLevelDropdown extends StatelessWidget {
  const _ActivityLevelDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    required this.options,
  });

  final ActivityLevel value;
  final ValueChanged<ActivityLevel> onChanged;
  final List<ActivityLevelMetadata> options;

  @override
  Widget build(BuildContext context) {
    // Fallback labels nếu metadata lỗi
    const fallbackLabels = <ActivityLevel, String>{
      ActivityLevel.Sedentary: 'Ít vận động',
      ActivityLevel.LightlyActive: 'Nhẹ (1–2 buổi/tuần)',
      ActivityLevel.ModeratelyActive: 'Vừa (3–4 buổi/tuần)',
      ActivityLevel.VeryActive: 'Năng động (5+ buổi/tuần)',
      ActivityLevel.ExtraActive: 'Rất năng động / vận động viên',
    };

    final items = <DropdownMenuItem<ActivityLevel>>[];

    if (options.isNotEmpty) {
      for (final meta in options) {
        final level = _activityFromName(meta.name);
        if (level == null) continue;
        items.add(
          DropdownMenuItem<ActivityLevel>(
            value: level,
            child: Text(meta.displayLabel),
          ),
        );
      }
    } else {
      // fallback: dùng enum trực tiếp
      for (final level in ActivityLevel.values) {
        final label = fallbackLabels[level] ?? level.apiValue;
        items.add(
          DropdownMenuItem<ActivityLevel>(value: level, child: Text(label)),
        );
      }
    }

    return DropdownButtonFormField<ActivityLevel>(
      value: value,
      decoration: const InputDecoration(labelText: 'Mức độ vận động'),
      items: items,
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}

ActivityLevel? _activityFromName(String name) {
  switch (name) {
    case 'Sedentary':
      return ActivityLevel.Sedentary;
    case 'LightlyActive':
      return ActivityLevel.LightlyActive;
    case 'ModeratelyActive':
      return ActivityLevel.ModeratelyActive;
    case 'VeryActive':
      return ActivityLevel.VeryActive;
    case 'ExtraActive':
      return ActivityLevel.ExtraActive;
    default:
      return null;
  }
}

/// =====================
/// STEP 2 – Dữ liệu cơ thể (2 ảnh)
/// =====================
class BodyUploadCard extends StatelessWidget {
  const BodyUploadCard({
    super.key,
    required this.onScanByCamera,
    required this.onContinue,
    this.frontImagePath,
    this.sideImagePath,
  });

  final Future<void> Function() onScanByCamera;
  final VoidCallback onContinue;
  final String? frontImagePath;
  final String? sideImagePath;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasFront = frontImagePath != null && frontImagePath!.isNotEmpty;
    final hasSide = sideImagePath != null && sideImagePath!.isNotEmpty;
    final allDone = hasFront && hasSide;
    final hasAny = hasFront || hasSide;

    return Column(
      children: [
        const StepHeader(
          title: 'Lấy dữ liệu cơ thể',
          subtitle: 'Hình ảnh sẽ được bảo mật.',
          current: 2,
        ),

        // =============================
        // Chỉ hiện "Tư thế chính xác" KHI CHƯA CÓ ẢNH NÀO
        // =============================
        if (!hasAny)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'lib/core/assets/images/front.png',
                              height: 180,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Chính diện',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'lib/core/assets/images/right.png',
                              height: 180,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Bên hông',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Center(
                  child: Text(
                    'Tư thế chính xác',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),

        // =============================
        // SectionCard preview ẢNH THẬT – CHỈ HIỆN KHI ĐÃ CHỤP ÍT NHẤT 1 ẢNH
        // =============================
        if (hasAny)
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _BodyPreviewBox(
                        label: 'Chính diện',
                        path: frontImagePath,
                        isDone: hasFront,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _BodyPreviewBox(
                        label: 'Bên hông',
                        path: sideImagePath,
                        isDone: hasSide,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onScanByCamera,
                    icon: const Icon(Icons.photo_camera_outlined),
                    label: const Text('Quét lại dữ liệu cơ thể'),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ảnh chỉ dùng để phân tích cơ thể, sẽ không công khai.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),

        // =============================
        // NÚT QUÉT khi chưa có ảnh (đặt ngoài SectionCard)
        // =============================
        if (!hasAny)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton.icon(
                  onPressed: onScanByCamera,
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: const Text('Quét dữ liệu cơ thể'),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ảnh của bạn sẽ được bảo mật.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

        AppContinueButton(
          onPressed: () {
            if (allDone) {
              onContinue();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Bạn cần có đủ 2 ảnh (chính diện và bên hông) trước khi tiếp tục.',
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

class _BodyPreviewBox extends StatelessWidget {
  const _BodyPreviewBox({
    required this.label,
    required this.path,
    required this.isDone,
  });

  final String label;
  final String? path;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDone ? cs.primary : cs.outlineVariant,
            width: 1.2,
          ),
          color: cs.surfaceVariant.withOpacity(0.15),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            if (path != null && path!.isNotEmpty)
              Positioned.fill(child: Image.file(File(path!), fit: BoxFit.cover))
            else
              Center(
                child: Icon(
                  Icons.person_outline,
                  size: 40,
                  color: cs.onSurfaceVariant,
                ),
              ),
            Positioned(
              left: 8,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isDone ? Icons.check_circle : Icons.camera_alt_outlined,
                      size: 14,
                      color: isDone ? Colors.greenAccent : Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      label,
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// =====================
/// STEP 3 – Sở thích & Chế độ (giữ logic cũ)
/// =====================
class DietPrefsFormCard extends StatefulWidget {
  const DietPrefsFormCard({
    super.key,
    required this.initial,
    required this.onSubmit,
  });

  final ProfileDraft initial;
  final ValueChanged<ProfileDraft> onSubmit;

  @override
  State<DietPrefsFormCard> createState() => _DietPrefsFormCardState();
}

class _DietPrefsFormCardState extends State<DietPrefsFormCard> {
  late int _meals;
  late Set<String> _likes;
  late Set<String> _dislikes;
  late final TextEditingController _extraCtl;
  late final TextEditingController _cuisineCtl;
  late final TextEditingController _allergyCtl;

  @override
  void initState() {
    super.initState();
    _meals = widget.initial.mealsPerDay;
    _likes = {...widget.initial.dietLikes};
    _dislikes = {...widget.initial.dietDislikes};
    _extraCtl = TextEditingController(text: widget.initial.extraFoods ?? '');
    _cuisineCtl = TextEditingController(text: widget.initial.cuisineType ?? '');
    _allergyCtl = TextEditingController(text: widget.initial.allergies ?? '');
  }

  @override
  void dispose() {
    _extraCtl.dispose();
    _cuisineCtl.dispose();
    _allergyCtl.dispose();
    super.dispose();
  }

  void _toggle(Set<String> set, String item) {
    set.contains(item) ? set.remove(item) : set.add(item);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final groups = <String, List<String>>{
      'Rau / Củ / Quả': [
        'Rau xanh',
        'Cà rốt',
        'Khoai lang',
        'Táo',
        'Chuối',
        'Cam',
      ],
      'Đậu / Ngũ cốc': [
        'Gạo',
        'Yến mạch',
        'Đậu nành',
        'Đậu xanh',
        'Đậu đỏ',
        'Hạt chia',
      ],
      'Thịt / Cá / Hải sản': [
        'Thịt gà',
        'Thịt bò',
        'Thịt heo',
        'Cá hồi',
        'Cá ngừ',
        'Tôm',
      ],
    };

    return Column(
      children: [
        const StepHeader(
          title: 'Sở thích & chế độ ăn',
          subtitle: 'Giúp AI xây thực đơn phù hợp.',
          current: 3,
        ),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Số bữa/ngày',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  _Stepper(
                    value: _meals,
                    min: 2,
                    max: 6,
                    onChanged: (v) => setState(() => _meals = v),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _cuisineCtl,
                decoration: const InputDecoration(
                  labelText: 'Loại ẩm thực ưa thích',
                  hintText: 'Ví dụ: Việt Nam, Nhật Bản, Địa Trung Hải...',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _allergyCtl,
                decoration: const InputDecoration(
                  labelText: 'Dị ứng với thực phẩm',
                  hintText: 'Ví dụ: Hải sản, đậu phộng...',
                ),
              ),
              const SizedBox(height: 16),
              Text('Thường ăn', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              for (final entry in groups.entries) ...[
                Text(
                  entry.key,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: entry.value
                      .map(
                        (e) => FilterChip(
                          selected: _likes.contains(e),
                          label: Text(e),
                          onSelected: (_) => _toggle(_likes, e),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
              ],
              const Divider(height: 32),
              Text(
                'Không ăn được',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: groups.values
                    .expand((x) => x)
                    .map(
                      (e) => FilterChip(
                        selected: _dislikes.contains(e),
                        label: Text(e),
                        onSelected: (_) => _toggle(_dislikes, e),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _extraCtl,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú thêm',
                  hintText:
                      'Ví dụ: Thích ăn sáng nhẹ, không ăn cay, ít dầu mỡ...',
                ),
              ),
            ],
          ),
        ),
        AppContinueButton(
          label: 'Hoàn tất hồ sơ',
          onPressed: () {
            final draft = widget.initial
              ..mealsPerDay = _meals
              ..cuisineType = _cuisineCtl.text.trim().isEmpty
                  ? null
                  : _cuisineCtl.text.trim()
              ..allergies = _allergyCtl.text.trim().isEmpty
                  ? null
                  : _allergyCtl.text.trim()
              ..dietLikes = _likes
              ..dietDislikes = _dislikes
              ..extraFoods = _extraCtl.text.trim().isEmpty
                  ? null
                  : _extraCtl.text.trim();

            debugPrint('[Diet] Payload gửi API: ${draft.toDietDto()}');
            widget.onSubmit(draft);
          },
        ),
      ],
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 10,
  });
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filledTonal(
          onPressed: value > min ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '$value',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        IconButton.filled(
          onPressed: value < max ? () => onChanged(value + 1) : null,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
