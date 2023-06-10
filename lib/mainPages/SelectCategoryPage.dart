import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nabung/constants/color.dart';
import 'package:nabung/cubit/authenticationDataCubit.dart';
import 'package:nabung/cubit/baseState.dart';
import 'package:nabung/cubit/categoryCubit.dart';
import 'package:nabung/mainPages/FormCategoryPage.dart';
import 'package:nabung/model/categoryModel.dart';
import 'package:nabung/model/userModel.dart';
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
      body: BlocBuilder<CategoryCubit, BaseState<List<CategoryModel>>>(
        builder: (context, state) {
          final List<CategoryModel> categories =
              state.data ?? [...CategoryModel.expense, ...CategoryModel.income];

          final List<CategoryModel> categoryExpenses =
              categories.where((element) => element.type == 'expense').toList();

          final List<CategoryModel> categoryIncome =
              categories.where((element) => element.type == 'income').toList();

          return ListView(
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
                categoryExpenses.length,
                (index) => Container(
                  decoration: index < categoryExpenses.length - 1
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
                    label: categoryExpenses[index].label,
                    icon: categoryExpenses[index].icon,
                    onTap: () {
                      Navigator.pop(
                        context,
                        categoryExpenses[index],
                      );
                    },
                    slidableActions: [
                      if (!categoryExpenses[index].isDefault) ...[
                        SlidableAction(
                          onPressed: (_) {
                            // show alert dialog remove
                            UserModel user = context
                                .read<AuthenticationDataCubit>()
                                .state
                                .data!;
                            CategoryCubit categoryCubit =
                                context.read<CategoryCubit>();
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: const Text('Are you sure ?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        // delete transaction
                                        categoryCubit.delete(
                                          userId: user.id!,
                                          label: categoryExpenses[index].label,
                                        );

                                        Navigator.pop(context);
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          backgroundColor: red,
                          foregroundColor: white,
                          icon: Icons.delete,
                          label: 'Remove',
                        ),
                      ],
                    ],
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
                categoryIncome.length,
                (index) => Container(
                  decoration: index < categoryIncome.length - 1
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
                    label: categoryIncome[index].label,
                    icon: categoryIncome[index].icon,
                    onTap: () {
                      Navigator.pop(
                        context,
                        categoryIncome[index],
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormCategoryPage(),
            ),
          );
        },
        backgroundColor: primary,
        child: const Icon(
          Icons.add,
          color: white,
        ),
      ),
    );
  }
}
