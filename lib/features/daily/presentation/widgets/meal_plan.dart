import 'package:flutter/material.dart';
import '../../data/models/meal_models.dart';
import '../../../home/presentation/widgets/food/meal_day_card.dart';

class TodayMealPlan extends StatelessWidget {
  const TodayMealPlan({
    super.key,
    required this.groups,
    this.padding = const EdgeInsets.symmetric(vertical: 4),
    this.shrinkWrap = true,
    this.physics = const NeverScrollableScrollPhysics(),
  });

  final List<MealGroup> groups;

  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      children: [MealDayCard(dayTitle: 'Thực đơn hôm nay', meals: groups)],
    );
  }
}
