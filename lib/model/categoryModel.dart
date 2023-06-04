import 'package:nabung/constants/assetPath.dart';

class CategoryModel {
  final String icon;
  final String label;

  CategoryModel({
    required this.icon,
    required this.label,
  });

  static List<CategoryModel> expense = [
    CategoryModel(
      icon: AssetPath.food,
      label: 'Food',
    ),
    CategoryModel(
      icon: AssetPath.transport,
      label: 'Transport',
    ),
    CategoryModel(
      icon: AssetPath.recurringBill,
      label: 'Recurring Bill',
    ),
    CategoryModel(
      icon: AssetPath.otherBill,
      label: 'Other Bill',
    ),
  ];

  static List<CategoryModel> income = [
    CategoryModel(
      icon: AssetPath.salary,
      label: 'Salary',
    ),
    CategoryModel(
      icon: AssetPath.otherIncome,
      label: 'Other Income',
    ),
  ];
}
