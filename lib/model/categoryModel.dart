import 'package:equatable/equatable.dart';
import 'package:nabung/constants/assetPath.dart';

class CategoryModel extends Equatable {
  final String icon;
  final String label;
  final String type;

  const CategoryModel({
    required this.icon,
    required this.label,
    required this.type,
  });

  static List<CategoryModel> expense = const [
    CategoryModel(
      icon: AssetPath.food,
      label: 'Food',
      type: 'expense',
    ),
    CategoryModel(
      icon: AssetPath.transport,
      label: 'Transport',
      type: 'expense',
    ),
    CategoryModel(
      icon: AssetPath.recurringBill,
      label: 'Recurring Bill',
      type: 'expense',
    ),
    CategoryModel(
      icon: AssetPath.otherBill,
      label: 'Other Bill',
      type: 'expense',
    ),
  ];

  static List<CategoryModel> income = const [
    CategoryModel(
      icon: AssetPath.salary,
      label: 'Salary',
      type: 'income',
    ),
    CategoryModel(
      icon: AssetPath.otherIncome,
      label: 'Other Income',
      type: 'income',
    ),
  ];

  @override
  List<Object?> get props => [
        icon,
        label,
        type,
      ];
}
