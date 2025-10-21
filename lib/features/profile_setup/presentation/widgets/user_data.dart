import 'package:flutter/material.dart';

/// =====================
/// Models (đơn giản hóa)
/// =====================
enum Gender { male, female, other }

enum Goal { loseFat, maintain, gainMuscle }

class ProfileDraft {
  double? heightCm;
  double? weightKg;
  int? age;
  Gender gender = Gender.male;
  Goal? goal;

  // body & diet
  String? localPhotoPath; // ảnh từ thư viện/camera
  int mealsPerDay = 3;
  Set<String> dietLikes = {};
  Set<String> dietDislikes = {};
  String? extraFoods;

  ProfileDraft();
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
              // (icon placeholder) – tuỳ bạn thay asset
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
/// STEP 1 – Tổng quan
/// =====================
class UserDataFormCard extends StatefulWidget {
  const UserDataFormCard({
    super.key,
    required this.initial,
    required this.onSubmit,
  });

  final ProfileDraft initial;
  final ValueChanged<ProfileDraft> onSubmit;

  @override
  State<UserDataFormCard> createState() => _UserDataFormCardState();
}

class _UserDataFormCardState extends State<UserDataFormCard> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _hCtl;
  late final TextEditingController _wCtl;
  late final TextEditingController _ageCtl;
  Gender _gender = Gender.male;
  Goal? _goal;

  @override
  void initState() {
    super.initState();
    _hCtl = TextEditingController(
      text: widget.initial.heightCm?.toString() ?? '',
    );
    _wCtl = TextEditingController(
      text: widget.initial.weightKg?.toString() ?? '',
    );
    _ageCtl = TextEditingController(text: widget.initial.age?.toString() ?? '');
    _gender = widget.initial.gender;
    _goal = widget.initial.goal;
  }

  @override
  void dispose() {
    _hCtl.dispose();
    _wCtl.dispose();
    _ageCtl.dispose();
    super.dispose();
  }

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
          subtitle:
              'Điền thông tin cơ bản để AI thiết kế kế hoạch riêng cho bạn.',
          current: 1,
        ),
        SectionCard(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                const SizedBox(height: 12),
                TextFormField(
                  controller: _ageCtl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Tuổi',
                    hintText: 'Nhập tuổi',
                  ),
                  validator: (v) {
                    final err = _numReq(v, min: 10, max: 100);
                    return err;
                  },
                ),
                const SizedBox(height: 16),
                _GenderSelector(
                  value: _gender,
                  onChanged: (g) => setState(() => _gender = g),
                ),
                const SizedBox(height: 12),
                _GoalDropdown(
                  value: _goal,
                  onChanged: (g) => setState(() => _goal = g),
                ),
              ],
            ),
          ),
        ),
        AppContinueButton(
          onPressed: () {
            if (!(_formKey.currentState?.validate() ?? false)) return;
            final draft = widget.initial
              ..heightCm = double.parse(_hCtl.text.replaceAll(',', '.'))
              ..weightKg = double.parse(_wCtl.text.replaceAll(',', '.'))
              ..age = int.parse(_ageCtl.text)
              ..gender = _gender
              ..goal = _goal;
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
          selected: value == Gender.male,
          label: const Text('Nam'),
          onSelected: (_) => onChanged(Gender.male),
        ),
        const SizedBox(width: 8),
        ChoiceChip(
          selected: value == Gender.female,
          label: const Text('Nữ'),
          onSelected: (_) => onChanged(Gender.female),
        ),
        const SizedBox(width: 8),
        ChoiceChip(
          selected: value == Gender.other,
          label: const Text('Khác'),
          onSelected: (_) => onChanged(Gender.other),
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
        DropdownMenuItem(value: Goal.loseFat, child: Text('Giảm mỡ')),
        DropdownMenuItem(value: Goal.maintain, child: Text('Giữ cân')),
        DropdownMenuItem(value: Goal.gainMuscle, child: Text('Tăng cơ')),
      ],
      onChanged: onChanged,
      validator: (v) => v == null ? 'Chọn mục tiêu' : null,
    );
  }
}

/// =====================
/// STEP 2 – Upload cơ thể
/// =====================
class BodyUploadCard extends StatelessWidget {
  const BodyUploadCard({
    super.key,
    required this.onPickFromLibrary,
    required this.onScanByCamera,
    required this.onContinue,
  });

  final Future<void> Function() onPickFromLibrary;
  final Future<void> Function() onScanByCamera;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const StepHeader(
          title: 'Upload ảnh cơ thể',
          subtitle: 'AI sẽ phân tích Bodygram để cá nhân hoá kế hoạch.',
          current: 2,
        ),
        SectionCard(
          child: Column(
            children: [
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: Center(
                  child: TextButton.icon(
                    onPressed: onPickFromLibrary,
                    icon: const Icon(Icons.add),
                    label: const Text('Upload'),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Ảnh chỉ dùng để phân tích, sẽ không công khai.',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onScanByCamera,
                icon: const Icon(Icons.photo_camera_outlined),
                label: const Text('Quét body bằng camera'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ảnh chỉ dùng để phân tích, sẽ không công khai.',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        AppContinueButton(onPressed: onContinue),
      ],
    );
  }
}

/// =====================
/// STEP 3 – Sở thích & Chế độ
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

  @override
  void initState() {
    super.initState();
    _meals = widget.initial.mealsPerDay;
    _likes = {...widget.initial.dietLikes};
    _dislikes = {...widget.initial.dietDislikes};
    _extraCtl = TextEditingController(text: widget.initial.extraFoods ?? '');
  }

  @override
  void dispose() {
    _extraCtl.dispose();
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
              // Tabs Thường ăn / Không ăn được (đổi giữa likes & dislikes)
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Thường ăn')),
                  ButtonSegment(value: false, label: Text('Không ăn được')),
                ],
                selected: const {true},
                onSelectionChanged: (_) {},
              ),
              const SizedBox(height: 16),

              // Số bữa / ngày
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

              // Chips – chọn likes
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

              // Chips – chọn dislikes
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
                  labelText: 'Thêm thực phẩm khác',
                  hintText: 'Nhập thực phẩm khác',
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
              ..dietLikes = _likes
              ..dietDislikes = _dislikes
              ..extraFoods = _extraCtl.text.trim().isEmpty
                  ? null
                  : _extraCtl.text.trim();
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
