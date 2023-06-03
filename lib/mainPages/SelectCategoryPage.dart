import 'package:flutter/material.dart';
import 'package:nabung/model/category_model.dart';
import 'package:nabung/widgets/menuItem.dart';

class SelectCategoryPage extends StatelessWidget {
  const SelectCategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('Select Category'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Text(
              'Expense',
              style: TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(
            CategoryModel.expense.length,
            (index) => Container(
              decoration: index < CategoryModel.expense.length - 1
                  ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              )
                  : null,
              child: MenuItem(
                label: CategoryModel.expense[index].label,
                icon: CategoryModel.expense[index].icon,
                onTap: () {
                  // todo:
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Text(
              'Income',
              style: TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(
            CategoryModel.income.length,
            (index) => Container(
              decoration: index < CategoryModel.income.length - 1
                  ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              )
                  : null,
              child: MenuItem(
                label: CategoryModel.income[index].label,
                icon: CategoryModel.income[index].icon,
                onTap: () {
                  // todo:
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
