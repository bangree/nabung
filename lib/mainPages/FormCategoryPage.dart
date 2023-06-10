import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabung/constants/assetPath.dart';
import 'package:nabung/constants/color.dart';
import 'package:nabung/cubit/authenticationDataCubit.dart';
import 'package:nabung/cubit/categoryCubit.dart';
import 'package:nabung/mainPages/SelectTypeCategoryPage.dart';
import 'package:nabung/widgets/textFieldWidget.dart';

class FormCategoryPage extends StatefulWidget {
  const FormCategoryPage({Key? key}) : super(key: key);

  @override
  State<FormCategoryPage> createState() => _FormCategoryPageState();
}

class _FormCategoryPageState extends State<FormCategoryPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

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
        title: const Text('Add Category'),
        actions: [
          TextButton(
            child: const Text(
              'Save',
              style: TextStyle(
                color: Color(0xff7C92E2),
                fontSize: 18,
              ),
            ),
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                // create category
                context.read<CategoryCubit>().create(
                      userId: context
                          .read<AuthenticationDataCubit>()
                          .state
                          .data!
                          .id!,
                      label: nameController.text,
                      type: typeController.text.toLowerCase(),
                      icon: typeController.text == 'Expense'
                          ? AssetPath.expense
                          : AssetPath.income,
                    );

                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            // name
            TextFieldWidget(
              controller: nameController,
              hint: 'Category Name',
              filled: true,
              prefix: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: lightGrey,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(AssetPath.list),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 8,
              ),
              validator: (val) {
                if (val?.trim().isEmpty ?? true) {
                  return 'Category name cannot be empty';
                }
                return null;
              },
            ),

            // divider
            const Divider(
              height: 0,
              thickness: 1,
            ),

            // type
            TextFieldWidget(
              controller: typeController,
              hint: 'Select Type',
              readOnly: true,
              filled: true,
              prefix: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: lightGrey,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: typeController.text.trim().isNotEmpty
                      ? Image.asset(
                          typeController.text == 'Expense'
                              ? AssetPath.expense
                              : AssetPath.income,
                        )
                      : const SizedBox(),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 8,
              ),
              onTap: () async {
                String? result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SelectTypeCategoryPage(),
                  ),
                );

                if (result != null) {
                  setState(() {
                    typeController.text = result;
                  });
                }
              },
              validator: (val) {
                if (val?.trim().isEmpty ?? true) {
                  return 'Type cannot be empty';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
