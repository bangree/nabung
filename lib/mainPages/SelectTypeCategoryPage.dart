import 'package:flutter/material.dart';
import 'package:nabung/constants/assetPath.dart';
import 'package:nabung/widgets/menuItem.dart';

class SelectTypeCategoryPage extends StatelessWidget {
  const SelectTypeCategoryPage({Key? key}) : super(key: key);

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
        title: const Text('Select Type'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        children: [
          const SizedBox(height: 8),
          MenuItem(
            label: 'Expense',
            icon: AssetPath.expense,
            onTap: () {
              Navigator.pop(
                context,
                'Expense',
              );
            },
          ),
          const Divider(height: 0),
          MenuItem(
            label: 'Income',
            icon: AssetPath.income,
            onTap: () {
              Navigator.pop(
                context,
                'Income',
              );
            },
          ),
        ],
      ),
    );
  }
}
