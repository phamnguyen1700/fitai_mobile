import 'package:fitai_mobile/features/profile_setup/data/models/dietary_preference_request.dart';
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
  Set<String> preferredIngredients;
  Set<String> avoidIngredients;
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
    Set<String>? preferredIngredients,
    Set<String>? avoidIngredients,
    this.extraFoods,
    this.cuisineType,
    this.allergies,
  }) : preferredIngredients = preferredIngredients ?? {},
       avoidIngredients = avoidIngredients ?? {};

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

  ProfileDraft copyWith({
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    double? height,
    double? weight,
    Gender? gender,
    Goal? goal,
    ActivityLevel? activityLevel,
    String? localPhotoPath,
    String? frontBodyPhotoPath,
    String? sideBodyPhotoPath,
    int? mealsPerDay,
    Set<String>? preferredIngredients,
    Set<String>? avoidIngredients,
    String? extraFoods,
    String? cuisineType,
    String? allergies,
    bool clearFrontPhoto = false,
    bool clearSidePhoto = false,
  }) {
    return ProfileDraft(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      goal: goal ?? this.goal,
      activityLevel: activityLevel ?? this.activityLevel,
      localPhotoPath: localPhotoPath ?? this.localPhotoPath,
      frontBodyPhotoPath: clearFrontPhoto
          ? null
          : (frontBodyPhotoPath ?? this.frontBodyPhotoPath),
      sideBodyPhotoPath: clearSidePhoto
          ? null
          : (sideBodyPhotoPath ?? this.sideBodyPhotoPath),
      mealsPerDay: mealsPerDay ?? this.mealsPerDay,
      preferredIngredients: preferredIngredients ?? this.preferredIngredients,
      avoidIngredients: avoidIngredients ?? this.avoidIngredients,
      extraFoods: extraFoods ?? this.extraFoods,
      cuisineType: cuisineType ?? this.cuisineType,
      allergies: allergies ?? this.allergies,
    );
  }
}

extension ProfileDraftDietDto on ProfileDraft {
  Map<String, dynamic> toDietDto() => {
    'mealsPerDay': mealsPerDay,
    'cuisineType': cuisineType,
    'allergies': allergies ?? '',
    'preferredIngredients': preferredIngredients.isNotEmpty
        ? preferredIngredients.join(', ')
        : '',
    'avoidIngredients': avoidIngredients.isNotEmpty
        ? avoidIngredients.join(', ')
        : '',
    'notes': extraFoods ?? '',
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

/// =====================
/// Ideal weight helper
/// =====================

class IdealWeightRange {
  final double min;
  final double max;
  const IdealWeightRange(this.min, this.max);
}

class _IdealRow {
  final int heightCm;
  final double min;
  final double max;
  const _IdealRow(this.heightCm, this.min, this.max);
}

/// Bảng nữ trưởng thành
const List<_IdealRow> _femaleIdealTable = [
  _IdealRow(135, 30, 34),
  _IdealRow(137, 30, 37),
  _IdealRow(140, 30, 37),
  _IdealRow(142, 32, 40),
  _IdealRow(144, 35, 42),
  _IdealRow(147, 36, 45),
  _IdealRow(150, 39, 47),
  _IdealRow(152, 40, 50),
  _IdealRow(155, 43, 52),
  _IdealRow(157, 45, 55),
  _IdealRow(160, 47, 57),
  _IdealRow(162, 49, 60),
  _IdealRow(165, 51, 62),
  _IdealRow(168, 53, 65),
  _IdealRow(170, 55, 67),
  _IdealRow(173, 57, 70),
  _IdealRow(175, 59, 72),
  _IdealRow(178, 61, 75),
  _IdealRow(180, 63, 77),
  _IdealRow(183, 65, 80),
];

/// Bảng nam trưởng thành
const List<_IdealRow> _maleIdealTable = [
  _IdealRow(135, 30, 39),
  _IdealRow(137, 32, 39),
  _IdealRow(140, 30, 39),
  _IdealRow(142, 33, 40),
  _IdealRow(144, 35, 44),
  _IdealRow(147, 38, 46),
  _IdealRow(150, 40, 50),
  _IdealRow(152, 43, 53),
  _IdealRow(155, 45, 55),
  _IdealRow(157, 48, 59),
  _IdealRow(160, 50, 61),
  _IdealRow(162, 53, 65),
  _IdealRow(165, 56, 68),
  _IdealRow(168, 58, 70),
  _IdealRow(170, 60, 74),
  _IdealRow(173, 63, 76),
  _IdealRow(175, 65, 80),
  _IdealRow(178, 63, 83),
  _IdealRow(180, 70, 85),
  _IdealRow(183, 72, 89),
];

IdealWeightRange? getIdealWeightRange({
  required double heightCm,
  required Gender gender,
}) {
  final table = gender == Gender.F ? _femaleIdealTable : _maleIdealTable;
  if (table.isEmpty) return null;

  // chọn dòng có chiều cao gần nhất
  _IdealRow closest = table.first;
  double bestDiff = (heightCm - closest.heightCm).abs();

  for (final row in table.skip(1)) {
    final diff = (heightCm - row.heightCm).abs();
    if (diff < bestDiff) {
      bestDiff = diff;
      closest = row;
    }
  }

  return IdealWeightRange(closest.min, closest.max);
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

  String? _goalError;

  bool _hasValidHeightAndWeight() {
    final h = double.tryParse(_hCtl.text.replaceAll(',', '.'));
    final w = double.tryParse(_wCtl.text.replaceAll(',', '.'));
    return h != null && w != null && h > 0 && w > 0;
  }

  bool _isUnderweightForHeight() {
    final h = double.tryParse(_hCtl.text.replaceAll(',', '.'));
    final w = double.tryParse(_wCtl.text.replaceAll(',', '.'));
    if (h == null || w == null) return false;
    if (_gender == null) return false;

    final range = getIdealWeightRange(heightCm: h, gender: _gender!);
    if (range == null) return false;

    return w < range.min;
  }

  void _recheckGoal() {
    // Nếu chưa có chiều cao/cân nặng hợp lệ -> reset goal về null
    if (!_hasValidHeightAndWeight()) {
      if (_goal != null || _goalError != null) {
        setState(() {
          _goal = null;
          _goalError = null;
        });
      }
      return;
    }

    if (_goal == Goal.Weight_Loss) {
      final h = double.tryParse(_hCtl.text.replaceAll(',', '.'));
      final w = double.tryParse(_wCtl.text.replaceAll(',', '.'));

      // Nếu không parse được hoặc chưa nhập đủ, không hiển thị lỗi
      if (h == null || w == null || _gender == null) {
        if (_goalError != null) {
          setState(() => _goalError = null);
        }
        return;
      }

      // Nếu parse được và còn underweight -> hiển thị lỗi
      if (_isUnderweightForHeight()) {
        setState(() {
          _goalError = 'Bạn đang nhẹ cân, không nên đặt mục tiêu giảm cân.';
        });
      } else {
        // Không còn underweight -> clear lỗi và reset dropdown về null
        if (_goalError != null || _goal == Goal.Weight_Loss) {
          setState(() {
            _goalError = null;
            _goal = null; // Reset dropdown về trạng thái chưa chọn
          });
        }
      }
    } else {
      // Không phải mục tiêu giảm cân -> clear lỗi nếu có
      if (_goalError != null) {
        setState(() => _goalError = null);
      }
    }
  }

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
    _gender = widget.initial.gender;
    _goal = widget.initial.goal;
    _activityLevel = widget.initial.activityLevel ?? ActivityLevel.Sedentary;

    _hCtl.addListener(() {
      _recheckGoal();
      setState(() {});
    });

    _wCtl.addListener(() {
      _recheckGoal();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _hCtl.removeListener(_recheckGoal);
    _wCtl.removeListener(_recheckGoal);
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
                  validator: (v) => _numReq(v, max: 200),
                ),
                const SizedBox(height: 16),

                _GenderSelector(
                  value: _gender,
                  enabled: _hasValidHeightAndWeight(),
                  onChanged: (g) {
                    setState(() {
                      _gender = g;
                    });
                    _recheckGoal();
                  },
                ),
                const SizedBox(height: 12),
                _GoalDropdown(
                  value: _goal,
                  errorText: _goalError,
                  enabled: _hasValidHeightAndWeight(),
                  onChanged: (g) {
                    if (g == null) return;

                    // chỉ bắt case giảm cân
                    if (g == Goal.Weight_Loss && _isUnderweightForHeight()) {
                      final h = double.tryParse(
                        _hCtl.text.replaceAll(',', '.'),
                      );
                      final gender = _gender ?? Gender.M;
                      final range = (h != null)
                          ? getIdealWeightRange(heightCm: h, gender: gender)
                          : null;

                      final msg = range == null
                          ? 'Bạn đang nhẹ cân so với chiều cao, không nên đặt mục tiêu giảm cân.'
                          : 'Bạn đang nhẹ hơn khoảng cân nặng lý tưởng '
                                '(${range.min.round()}–${range.max.round()} kg) cho chiều cao hiện tại. '
                                'Hãy chọn tăng cân / tăng cơ hoặc duy trì cân nặng.';

                      setState(() {
                        _goal = g;
                        _goalError = msg;
                      });
                      return;
                    }

                    // chọn mục tiêu hợp lệ → clear lỗi
                    setState(() {
                      _goal = g;
                      _goalError = null;
                    });
                  },
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
            // Nếu đang chọn giảm cân và nhẹ cân thì báo lỗi, không cho qua
            if (_goal == Goal.Weight_Loss && _isUnderweightForHeight()) {
              final h = double.tryParse(_hCtl.text.replaceAll(',', '.'));
              final gender = _gender ?? Gender.M;
              final range = (h != null)
                  ? getIdealWeightRange(heightCm: h, gender: gender)
                  : null;

              final msg = range == null
                  ? 'Bạn đang nhẹ cân so với chiều cao, không nên đặt mục tiêu giảm cân.'
                  : 'Bạn đang nhẹ hơn khoảng cân nặng lý tưởng '
                        '(${range.min.round()}–${range.max.round()} kg). '
                        'Hãy chọn tăng cân / tăng cơ hoặc duy trì cân nặng.';

              setState(() {
                _goalError = msg;
              });
              return;
            }

            if (!(_formKey.currentState?.validate() ?? false)) return;

            final heightVal = double.parse(_hCtl.text.replaceAll(',', '.'));
            final weightVal = double.parse(_wCtl.text.replaceAll(',', '.'));

            final draft = widget.initial
              ..firstName = _firstNameCtl.text.trim()
              ..lastName = _lastNameCtl.text.trim()
              ..dateOfBirth = _dob
              ..height = heightVal
              ..weight = weightVal
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
  const _GenderSelector({
    this.value,
    required this.onChanged,
    this.enabled = true,
  });
  final Gender? value;
  final ValueChanged<Gender?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Gender>(
      value: value,
      isExpanded: true,
      decoration: const InputDecoration(labelText: 'Giới tính'),
      items: const [
        DropdownMenuItem(value: Gender.M, child: Text('Nam')),
        DropdownMenuItem(value: Gender.F, child: Text('Nữ')),
      ],
      onChanged: enabled ? onChanged : null,
      validator: (v) {
        if (v == null) return 'Chọn giới tính';
        return null;
      },
    );
  }
}

class _GoalDropdown extends StatelessWidget {
  const _GoalDropdown({
    this.value,
    required this.onChanged,
    this.errorText,
    this.enabled = true,
  });

  final Goal? value;
  final ValueChanged<Goal?> onChanged;
  final String? errorText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Goal>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Mục tiêu',
        errorText: errorText, // 👈 hiện text đỏ dưới dropdown
      ),
      items: const [
        DropdownMenuItem(
          value: Goal.Weight_Loss,
          child: Text('Giảm cân / Giảm mỡ'),
        ),
        DropdownMenuItem(
          value: Goal.Maintenance,
          child: Text('Duy trì cân nặng / Giảm mỡ'),
        ),
        DropdownMenuItem(
          value: Goal.Weight_Gain,
          child: Text('Tăng cân / Tăng cơ'),
        ),
      ],
      onChanged: enabled ? onChanged : null,
      validator: (v) {
        if (v == null) return 'Chọn mục tiêu';
        return null;
      },
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
    this.bodygramError,
    this.isLoading = false,
  });

  final Future<void> Function() onScanByCamera;
  final VoidCallback onContinue;
  final String? frontImagePath;
  final String? sideImagePath;
  final String? bodygramError;
  final bool isLoading;

  Widget _buildLoadingSection(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          'Đang gửi dữ liệu Bodygram để AI phân tích...',
          style: t.bodyMedium?.copyWith(color: cs.primary),
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          backgroundColor: cs.primary.withOpacity(0.15),
          valueColor: AlwaysStoppedAnimation(cs.primary),
          minHeight: 4,
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasFront = frontImagePath != null && frontImagePath!.isNotEmpty;
    final hasSide = sideImagePath != null && sideImagePath!.isNotEmpty;
    final allDone = hasFront && hasSide;
    final hasAny = hasFront || hasSide;

    // Debug: log paths
    debugPrint(
      '[BodyUploadCard] frontPath: $frontImagePath, sidePath: $sideImagePath',
    );
    debugPrint('[BodyUploadCard] hasFront: $hasFront, hasSide: $hasSide');

    return Column(
      children: [
        const StepHeader(
          title: 'Lấy dữ liệu cơ thể',
          subtitle: 'Hình ảnh sẽ được bảo mật.',
          current: 2,
        ),

        // =============================
        // Hiển thị ảnh hướng dẫn hoặc ảnh thực tế
        // =============================
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
                          child: hasFront
                              ? Image.file(
                                  File(frontImagePath!),
                                  height: 180,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    debugPrint(
                                      '[BodyUploadCard] Error loading front image: $error',
                                    );
                                    return Image.asset(
                                      'lib/core/assets/images/front.png',
                                      height: 180,
                                      fit: BoxFit.contain,
                                    );
                                  },
                                )
                              : Image.asset(
                                  'lib/core/assets/images/front.png',
                                  height: 180,
                                  fit: BoxFit.contain,
                                ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Chính diện',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: hasFront ? cs.primary : null,
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
                          child: hasSide
                              ? Image.file(
                                  File(sideImagePath!),
                                  height: 180,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    debugPrint(
                                      '[BodyUploadCard] Error loading side image: $error',
                                    );
                                    return Image.asset(
                                      'lib/core/assets/images/right.png',
                                      height: 180,
                                      fit: BoxFit.contain,
                                    );
                                  },
                                )
                              : Image.asset(
                                  'lib/core/assets/images/right.png',
                                  height: 180,
                                  fit: BoxFit.contain,
                                ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Mặt cạnh',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: hasSide ? cs.primary : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (!hasAny) ...[
                const SizedBox(height: 4),
                const Center(
                  child: Text(
                    'Tư thế chính xác',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
                  ),
                ),
              ],
            ],
          ),
        ),

        // =============================
        // NÚT QUÉT
        // =============================
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hướng dẫn chụp:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '• Đứng thẳng, toàn thân nằm trong khung hình.\n'
                      '• Ánh sáng đủ, nền phía sau đơn giản.\n'
                      '• Mặc đồ ôm vừa, không quá rộng.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              hasAny
                  ? OutlinedButton.icon(
                      onPressed: isLoading ? null : onScanByCamera,
                      icon: const Icon(Icons.photo_camera_outlined),
                      label: const Text('Quét lại dữ liệu cơ thể'),
                    )
                  : OutlinedButton.icon(
                      onPressed: isLoading ? null : onScanByCamera,
                      icon: const Icon(Icons.photo_camera_outlined),
                      label: const Text('Quét dữ liệu cơ thể'),
                    ),
              const SizedBox(height: 8),
              if (bodygramError != null) ...[
                const SizedBox(height: 6),
                Text(
                  bodygramError!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),

        if (isLoading)
          _buildLoadingSection(context)
        else
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
  final ValueChanged<DietaryPreferenceRequest> onSubmit;

  @override
  State<DietPrefsFormCard> createState() => _DietPrefsFormCardState();
}

class _DietPrefsFormCardState extends State<DietPrefsFormCard> {
  late int _meals;
  final Set<String> _preferred = {};

  late final TextEditingController _extraCtl;
  late final TextEditingController _cuisineCtl;
  late final TextEditingController _allergyCtl;
  late final TextEditingController _proteinCtl;
  late final TextEditingController _carbCtl;
  late final TextEditingController _fatCtl;
  late final TextEditingController _fiberCtl;
  late final TextEditingController _avoidCtl;

  final List<String> _customProteins = [];
  final List<String> _customCarbs = [];
  final List<String> _customFats = [];
  final List<String> _customFibers = [];

  @override
  void initState() {
    super.initState();
    _meals = widget.initial.mealsPerDay;

    // Nếu draft cũ có preferredIngredients -> parse ra _preferred
    _preferred.addAll(widget.initial.preferredIngredients);

    _extraCtl = TextEditingController(text: widget.initial.extraFoods ?? '');
    _cuisineCtl = TextEditingController(text: widget.initial.cuisineType ?? '');
    _allergyCtl = TextEditingController(text: widget.initial.allergies ?? '');

    _avoidCtl = TextEditingController(
      text: widget.initial.avoidIngredients.join(', '),
    );

    _proteinCtl = TextEditingController();
    _carbCtl = TextEditingController();
    _fatCtl = TextEditingController();
    _fiberCtl = TextEditingController();
  }

  @override
  void dispose() {
    _extraCtl.dispose();
    _cuisineCtl.dispose();
    _allergyCtl.dispose();
    _avoidCtl.dispose();
    _proteinCtl.dispose();
    _carbCtl.dispose();
    _fatCtl.dispose();
    _fiberCtl.dispose();
    super.dispose();
  }

  Set<String> _parseFreeTextToSet(String s) => s
      .split(RegExp(r'[,\n;]+'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toSet();

  void _togglePreferred(String item) {
    if (_preferred.contains(item)) {
      _preferred.remove(item);
    } else {
      _preferred.add(item);
    }
    setState(() {});
  }

  void _commitCustom(TextEditingController ctl, List<String> bucket) {
    final items = _parseFreeTextToSet(ctl.text);
    if (items.isEmpty) return;

    bool changed = false;
    for (final p in items) {
      if (!bucket.contains(p)) bucket.add(p);
      if (_preferred.add(p)) changed = true;
    }
    if (changed) setState(() {});
    ctl.clear();
  }

  void _onTypeCommit(String v, TextEditingController ctl, List<String> bucket) {
    if (v.endsWith(',') || v.endsWith(';') || v.endsWith('\n')) {
      _commitCustom(ctl, bucket);
    }
  }

  Widget _underlinedInput({
    required String label,
    required String hint,
    required TextEditingController controller,
    required List<String> targetBucket,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        width: double.infinity, // ✅ chiếm toàn bộ chiều ngang
        child: TextField(
          controller: controller,
          textInputAction: TextInputAction.done,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            border: const UnderlineInputBorder(),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 4,
            ),
            labelStyle: const TextStyle(fontSize: 13),
            hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          onChanged: (v) => _onTypeCommit(v, controller, targetBucket),
          onSubmitted: (_) => _commitCustom(controller, targetBucket),
          onEditingComplete: () => _commitCustom(controller, targetBucket),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isVeg = _cuisineCtl.text == 'Chay';

    // Nguồn đạm theo chế độ ăn
    final proteinList = isVeg
        ? <String>[
            'Đậu hũ',
            'Tempeh',
            'Seitan',
            'Đậu nành',
            'Đậu gà',
            'Đậu lăng',
            'Edamame',
            'Sữa hạt tăng cường protein',
          ]
        : <String>[
            'Thịt gà',
            'Thịt bò',
            'Thịt heo',
            'Cá hồi',
            'Cá ngừ',
            'Tôm',
            'Trứng',
            'Đậu giàu protein',
          ];

    // Nguồn tinh bột theo chế độ ăn
    final carbList = isVeg
        ? <String>['Yến mạch', 'Quinoa', 'Khoai', 'Gạo lứt', 'Bắp', 'Trái cây']
        : <String>[
            'Gạo',
            'Yến mạch',
            'Khoai lang',
            'Bánh mì nguyên cám',
            'Chuối',
            'Dưa hấu',
            'Đậu giàu tinh bột',
          ];

    // Nguồn chất béo theo chế độ ăn
    final fatList = isVeg
        ? <String>[
            'Các loại hạt',
            'Mè, hạt lanh, chia',
            'Bơ đậu phộng',
            'Bơ/avocado',
            'Dầu oliu',
          ]
        : <String>[
            'Đậu giàu chất béo',
            'Dầu ô liu',
            'Hạt óc chó',
            'Hạnh nhân',
            'Bơ (avocado)',
          ];

    final fiberList = <String>[
      'Rau lá xanh',
      'Bông cải xanh',
      'Dưa leo',
      'Bí ngòi',
      'Măng tây',
      'Cà rốt',
      'Rau trộn',
    ];

    final dietOptions = ['Bình thường', 'Chay'];

    String? joinOrNull(Set<String> s) {
      final xs = s.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      return xs.isEmpty ? null : xs.join(', ');
    }

    return Column(
      children: [
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StepHeader(
                title: 'Sở thích & chế độ ăn',
                subtitle: 'Giúp AI xây thực đơn phù hợp.',
                current: 3,
              ),
              Row(
                children: [
                  const Text(
                    'Số bữa/ngày',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  _Stepper(
                    value: _meals,
                    min: 3,
                    max: 5,
                    onChanged: (v) => setState(() => _meals = v),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Chế độ ăn', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                children: dietOptions.map((option) {
                  final selected = _cuisineCtl.text == option;
                  return ChoiceChip(
                    label: Text(option),
                    selected: selected,
                    onSelected: (_) =>
                        setState(() => _cuisineCtl.text = option),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              // ===== Nguồn đạm =====
              const Text(
                'Nguồn đạm',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 4,
                runSpacing: 1,
                children: <String>[...proteinList, ..._customProteins]
                    .map(
                      (e) => FilterChip(
                        selected: _preferred.contains(e),
                        label: Text(e),
                        onSelected: (_) => _togglePreferred(e),
                      ),
                    )
                    .toList(),
              ),
              _underlinedInput(
                label: 'Đạm khác',
                hint: 'Ví dụ: Thịt vịt, cá trê...',
                controller: _proteinCtl,
                targetBucket: _customProteins,
              ),

              const SizedBox(height: 8),

              // ===== Nguồn tinh bột =====
              const Text(
                'Nguồn tinh bột',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 4,
                runSpacing: 1,
                children: <String>[...carbList, ..._customCarbs]
                    .map(
                      (e) => FilterChip(
                        selected: _preferred.contains(e),
                        label: Text(e),
                        onSelected: (_) => _togglePreferred(e),
                      ),
                    )
                    .toList(),
              ),
              _underlinedInput(
                label: 'Tinh bột khác',
                hint: 'Ví dụ: Lúa mạch đen, khoai tây...',
                controller: _carbCtl,
                targetBucket: _customCarbs,
              ),
              const SizedBox(height: 8),

              // ===== Chất béo =====
              const Text(
                'Chất béo',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 4,
                runSpacing: 1,
                children: <String>[...fatList, ..._customFats]
                    .map(
                      (e) => FilterChip(
                        selected: _preferred.contains(e),
                        label: Text(e),
                        onSelected: (_) => _togglePreferred(e),
                      ),
                    )
                    .toList(),
              ),
              _underlinedInput(
                label: 'Chất béo khác',
                hint: 'Ví dụ: Dầu mè, hạt điều...',
                controller: _fatCtl,
                targetBucket: _customFats,
              ),
              const SizedBox(height: 8),

              // ===== Chất xơ =====
              const Text(
                'Chất xơ',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 4,
                runSpacing: 1,
                children: <String>[...fiberList, ..._customFibers]
                    .map(
                      (e) => FilterChip(
                        selected: _preferred.contains(e),
                        label: Text(e),
                        onSelected: (_) => _togglePreferred(e),
                      ),
                    )
                    .toList(),
              ),
              _underlinedInput(
                label: 'Chất xơ khác',
                hint: 'Ví dụ: Cải xoăn, bắp cải thảo...',
                controller: _fiberCtl,
                targetBucket: _customFibers,
              ),
              const Divider(height: 8),
              Text('Dị ứng', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _allergyCtl,
                decoration: const InputDecoration(
                  labelText: 'Dị ứng với thực phẩm',
                  hintText: 'Ví dụ: Hải sản, đậu phộng...',
                  border: UnderlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
        AppContinueButton(
          label: 'Hoàn tất hồ sơ',
          onPressed: () {
            // parse avoid
            final avoidSet = _parseFreeTextToSet(_avoidCtl.text);
            final avoidStr = avoidSet.isEmpty ? '' : avoidSet.join(', '); // 👈

            // notes
            final notesText = _extraCtl.text.trim();
            final notesValue = notesText.isEmpty ? '' : notesText; // 👈

            final req = DietaryPreferenceRequest(
              mealsPerDay: _meals,
              cuisineType: _cuisineCtl.text.trim().isEmpty
                  ? null
                  : _cuisineCtl.text.trim(),
              allergies: _allergyCtl.text.trim().isEmpty
                  ? ''
                  : _allergyCtl.text.trim(), // ✅ đã đúng
              preferredIngredients: joinOrNull(_preferred),
              avoidIngredients: avoidStr, // 👈 luôn truyền string
              notes: notesValue, // 👈 luôn truyền string
            );

            debugPrint('[Diet] Request: ${req.toJson()}');
            widget.onSubmit(req);
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
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Nút trừ
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: value > min ? () => onChanged(value - 1) : null,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: value > min
                    ? cs.primary.withOpacity(0.08)
                    : Colors.transparent,
              ),
              child: Icon(
                Icons.remove,
                size: 18,
                color: value > min ? cs.primary : cs.outline,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Số bữa
          Text(
            '$value',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(width: 12),
          // Nút cộng
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: value < max ? () => onChanged(value + 1) : null,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: value < max ? cs.primary : cs.primary,
              ),
              child: Icon(Icons.add, size: 18, color: cs.onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
