class MealGroup {
  final String title; // Sáng / Trưa / Bữa phụ...
  final List<MealItem> items;
  MealGroup(this.title, this.items);
}

class MealItem {
  final String name; // tên món
  final Map<String, String> portions; // thành phần -> định lượng
  MealItem(this.name, this.portions);
}
