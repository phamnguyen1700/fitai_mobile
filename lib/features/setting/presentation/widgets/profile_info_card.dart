// lib/features/setting/presentation/widgets/profile_info_card.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fitai_mobile/features/auth/data/models/user_model.dart';

class ProfileInfoCard extends StatefulWidget {
  final String? avatarUrl;
  final String displayName;
  final String subtitle;
  final Map<String, String> stats;
  final Set<String> readOnlyFields;

  /// Gọi khi nhấn Edit (Save) và có thay đổi
  final void Function(Map<String, String> updatedStats, Goal? updatedGoal)?
  onEdit;

  /// Goal hiện tại
  final Goal? goal;

  const ProfileInfoCard({
    super.key,
    required this.avatarUrl,
    required this.displayName,
    required this.subtitle,
    required this.stats,
    this.onEdit,
    this.goal,
    this.readOnlyFields = const {},
  });

  @override
  State<ProfileInfoCard> createState() => _ProfileInfoCardState();
}

class _ProfileInfoCardState extends State<ProfileInfoCard> {
  late final Map<String, TextEditingController> _controllers;
  late Map<String, String> _initialStats;

  late Goal? _selectedGoal;
  late Goal? _initialGoal;

  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    _initialStats = Map<String, String>.from(widget.stats);
    _controllers = {
      for (final entry in widget.stats.entries)
        entry.key: TextEditingController(text: entry.value),
    };

    _selectedGoal = widget.goal;
    _initialGoal = widget.goal;
  }

  @override
  void didUpdateWidget(covariant ProfileInfoCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Nếu stats từ ngoài đổi (VD: refresh từ server) thì sync lại
    if (!mapEquals(oldWidget.stats, widget.stats)) {
      _initialStats = Map<String, String>.from(widget.stats);
      for (final e in widget.stats.entries) {
        _controllers[e.key]?.text = e.value;
      }
    }

    // Sync goal từ ngoài
    if (oldWidget.goal != widget.goal) {
      _initialGoal = widget.goal;
      _selectedGoal = widget.goal;
    }

    _checkDirty();
  }

  void _onFieldChanged(String key, String value) {
    _checkDirty();
  }

  void _onGoalChanged(Goal? goal) {
    setState(() {
      _selectedGoal = goal;
    });
    _checkDirty();
  }

  void _checkDirty() {
    bool dirty = false;

    // check stats
    for (final e in _controllers.entries) {
      final initial = _initialStats[e.key] ?? '';
      if (e.value.text != initial) {
        dirty = true;
        break;
      }
    }

    // check goal
    if (!dirty) {
      if (_selectedGoal != _initialGoal) {
        dirty = true;
      }
    }

    if (dirty != _dirty) {
      setState(() {
        _dirty = dirty;
      });
    }
  }

  void _handleEditPressed() {
    final updatedStats = <String, String>{
      for (final e in _controllers.entries) e.key: e.value.text,
    };

    widget.onEdit?.call(updatedStats, _selectedGoal);

    // Sau khi save: reset trạng thái ban đầu
    _initialStats = Map<String, String>.from(updatedStats);
    _initialGoal = _selectedGoal;

    setState(() {
      _dirty = false;
    });
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // ===== Phần bên trái: avatar + name + email =====
    Widget left = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundImage: widget.avatarUrl != null
              ? NetworkImage(widget.avatarUrl!)
              : null,
          child: widget.avatarUrl == null ? const Icon(Icons.person) : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.displayName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                widget.subtitle,
                style: TextStyle(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );

    // (optional) tap vào header để save nếu đang dirty
    if (widget.onEdit != null) {
      left = InkWell(
        onTap: _dirty ? _handleEditPressed : null,
        borderRadius: BorderRadius.circular(8),
        child: left,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ===== Header: avatar + name + email + nút Edit góc phải =====
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: left),
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 0),
              child: OutlinedButton.icon(
                onPressed: _dirty ? _handleEditPressed : null,
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Edit'),
                style:
                    OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      visualDensity: VisualDensity.compact,
                      minimumSize: const Size(0, 32),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ).merge(
                      const ButtonStyle(
                        fixedSize: MaterialStatePropertyAll<Size?>(null),
                      ),
                    ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ===== Grid TextFields (Họ, Tên, Ngày sinh, ...) =====
        _StatsGrid(
          controllers: _controllers,
          onFieldChanged: _onFieldChanged,
          readOnlyFields: widget.readOnlyFields,
        ),

        const SizedBox(height: 12),

        // ===== Selector Mục tiêu nằm trong card =====
        DropdownButtonFormField<Goal>(
          value: _selectedGoal,
          decoration: const InputDecoration(labelText: 'Mục tiêu'),
          items: const [
            DropdownMenuItem(value: Goal.Weight_Loss, child: Text('Giảm cân')),
            DropdownMenuItem(value: Goal.Weight_Gain, child: Text('Tăng cân')),
            DropdownMenuItem(value: Goal.Build_Muscle, child: Text('Tăng cơ')),
            DropdownMenuItem(
              value: Goal.Maintain_Weight,
              child: Text('Duy trì cân nặng'),
            ),
          ],
          onChanged: _onGoalChanged,
        ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final Map<String, TextEditingController> controllers;
  final void Function(String key, String value) onFieldChanged;
  final Set<String> readOnlyFields;

  const _StatsGrid({
    required this.controllers,
    required this.onFieldChanged,
    required this.readOnlyFields,
  });

  @override
  Widget build(BuildContext context) {
    final entries = controllers.entries.toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 340;
        final children = <Widget>[];

        if (isNarrow) {
          // ----- 1 CỘT -----
          for (final e in entries) {
            children.add(
              _buildField(
                label: e.key,
                controller: e.value,
                readOnly: readOnlyFields.contains(e.key),
                onChanged: (v) => onFieldChanged(e.key, v),
              ),
            );
            children.add(const SizedBox(height: 12));
          }
        } else {
          // ----- 2 CỘT -----
          for (int i = 0; i < entries.length; i += 2) {
            final left = entries[i];
            final right = (i + 1 < entries.length) ? entries[i + 1] : null;

            children.add(
              Row(
                children: [
                  Expanded(
                    child: _buildField(
                      label: left.key,
                      controller: left.value,
                      readOnly: readOnlyFields.contains(left.key),
                      onChanged: (v) => onFieldChanged(left.key, v),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (right != null)
                    Expanded(
                      child: _buildField(
                        label: right.key,
                        controller: right.value,
                        readOnly: readOnlyFields.contains(right.key),
                        onChanged: (v) => onFieldChanged(right.key, v),
                      ),
                    )
                  else
                    const Spacer(),
                ],
              ),
            );
            children.add(const SizedBox(height: 12));
          }
        }

        return Column(children: children);
      },
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required bool readOnly,
    required ValueChanged<String> onChanged,
  }) {
    if (label == 'Giới tính') {
      return _GenderField(controller: controller, onChanged: onChanged);
    }
    return _StatTextField(
      label: label,
      controller: controller,
      readOnly: readOnly,
      onChanged: onChanged,
    );
  }
}

class _StatTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool readOnly;

  const _StatTextField({
    required this.label,
    required this.controller,
    required this.onChanged,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final cs = theme.colorScheme;
    final inputTheme = theme.inputDecorationTheme;

    return TextFormField(
      controller: controller,
      onChanged: readOnly ? null : onChanged, // khoá thì không onChanged
      readOnly: readOnly,
      enabled: !readOnly,
      style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      decoration: const InputDecoration().copyWith(
        labelText: label,
        contentPadding: inputTheme.contentPadding,
        suffixIconColor: inputTheme.suffixIconColor ?? cs.onSurfaceVariant,
        prefixIconColor: inputTheme.prefixIconColor ?? cs.onSurfaceVariant,
      ),
    );
  }
}

class _GenderField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _GenderField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final inputTheme = theme.inputDecorationTheme;

    String? value;
    final text = controller.text.trim();
    if (text == 'Nam' || text == 'Nữ') {
      value = text;
    }

    return DropdownButtonFormField<String>(
      value: value,
      decoration: const InputDecoration().copyWith(
        labelText: 'Giới tính',
        contentPadding: inputTheme.contentPadding,
        suffixIconColor: inputTheme.suffixIconColor ?? cs.onSurfaceVariant,
        prefixIconColor: inputTheme.prefixIconColor ?? cs.onSurfaceVariant,
      ),
      items: const [
        DropdownMenuItem(value: 'Nam', child: Text('Nam')),
        DropdownMenuItem(value: 'Nữ', child: Text('Nữ')),
      ],
      onChanged: (v) {
        final newText = v ?? '';
        controller.text = newText;
        onChanged(newText);
      },
    );
  }
}
