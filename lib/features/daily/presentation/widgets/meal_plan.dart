import 'package:flutter/material.dart';
import '../../presentation/models/meal_models.dart';
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

  /// Cho phép tuỳ chỉnh nhưng mặc định đã để “không scroll”
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    // Vì chỉ có 1 thẻ MealDayCard, thật ra có thể return thẳng.
    // Tuy nhiên để tương thích nếu sau này muốn chèn thêm phần khác,
    // mình giữ ListView với shrinkWrap + NeverScrollableScrollPhysics.
    return ListView(
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      children: [MealDayCard(dayTitle: 'Thực đơn hôm nay', meals: groups)],
    );
  }
}
