// lib/features/setting/presentation/widgets/unit_group.dart
import 'package:flutter/material.dart';

enum WeightUnit { kg, lbs }

enum HeightUnit { cm, inch }

enum EnergyUnit { kcal, kj }

class UnitGroup extends StatelessWidget {
  final WeightUnit weight;
  final HeightUnit height;
  final EnergyUnit energy;
  final ValueChanged<WeightUnit> onChangedWeight;
  final ValueChanged<HeightUnit> onChangedHeight;
  final ValueChanged<EnergyUnit> onChangedEnergy;

  const UnitGroup({
    super.key,
    required this.weight,
    required this.height,
    required this.energy,
    required this.onChangedWeight,
    required this.onChangedHeight,
    required this.onChangedEnergy,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RadioRow<WeightUnit>(
          label: 'Cân nặng:',
          groupValue: weight,
          values: const [(WeightUnit.kg, 'Kg'), (WeightUnit.lbs, 'Lbs')],
          onChanged: onChangedWeight,
        ),
        _RadioRow<HeightUnit>(
          label: 'Chiều cao:',
          groupValue: height,
          values: const [(HeightUnit.cm, 'cm'), (HeightUnit.inch, 'inch')],
          onChanged: onChangedHeight,
        ),
        _RadioRow<EnergyUnit>(
          label: 'Năng lượng:',
          groupValue: energy,
          values: const [
            (EnergyUnit.kcal, 'kcal (mặc định)'),
            (EnergyUnit.kj, 'kJ'),
          ],
          onChanged: onChangedEnergy,
        ),
      ],
    );
  }
}

class _RadioRow<T> extends StatelessWidget {
  final String label;
  final T groupValue;
  final List<(T, String)> values;
  final ValueChanged<T> onChanged;

  const _RadioRow({
    required this.label,
    required this.groupValue,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Row(
      children: [
        SizedBox(width: 88, child: Text(label, style: t.bodyMedium)),
        ...values.map(
          (e) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.scale(
                scale: 0.8,
                child: Radio<T>(
                  value: e.$1,
                  groupValue: groupValue,
                  onChanged: (v) => v != null ? onChanged(v) : null,
                ),
              ),
              Text(e.$2),
              const SizedBox(width: 3),
            ],
          ),
        ),
      ],
    );
  }
}
