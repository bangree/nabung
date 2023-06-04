import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nabung/constants/assetPath.dart';
import 'package:nabung/constants/color.dart';
import 'package:nabung/cubit/authenticationDataCubit.dart';
import 'package:nabung/cubit/transactionCubit.dart';
import 'package:nabung/cubit/walletCubit.dart';
import 'package:nabung/mainPages/SelectCategoryPage.dart';
import 'package:nabung/mainPages/SelectWalletPage.dart';
import 'package:nabung/model/categoryModel.dart';
import 'package:nabung/model/transactionModel.dart';
import 'package:nabung/model/walletModel.dart';
import 'package:nabung/widgets/textFieldWidget.dart';

class FormTransactionPage extends StatefulWidget {
  final TransactionModel? transaction;

  const FormTransactionPage({
    Key? key,
    this.transaction,
  }) : super(key: key);

  @override
  State<FormTransactionPage> createState() => _FormTransactionPageState();
}

class _FormTransactionPageState extends State<FormTransactionPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController walletController = TextEditingController();

  DateTime? selectedDate;
  CategoryModel? selectedCategory;
  WalletModel? selectedWallet;

  String get textSelectedDate {
    if (selectedDate == null) return '';
    return DateFormat('dd/MM/yyyy').format(selectedDate!);
  }

  @override
  void initState() {
    // init form
    if (widget.transaction != null) {
      final List<WalletModel> wallets =
          context.read<WalletCubit>().state.data ?? [];
      WalletModel? wallet = wallets.firstWhereOrNull(
        (element) => element.id == widget.transaction!.walletId,
      );

      nameController.text = widget.transaction!.name ?? '';
      amountController.text = widget.transaction!.textAmount;
      categoryController.text = widget.transaction!.categoryName ?? '';
      dateController.text = widget.transaction!.date ?? '';
      walletController.text = wallet?.name ?? '';
      selectedCategory = CategoryModel(
        icon: widget.transaction!.categoryIcon!,
        label: widget.transaction!.categoryName!,
        type: widget.transaction!.type!,
      );
      selectedWallet = wallet;
    }
    super.initState();
  }

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
        title: const Text('Add Transaction'),
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
                // update transaction
                context.read<TransactionCubit>().createOrUpdate(
                      userId: context
                          .read<AuthenticationDataCubit>()
                          .state
                          .data!
                          .id!,
                      id: widget.transaction?.id,
                      name: nameController.text,
                      amount: amountController.text,
                      categoryName: categoryController.text,
                      categoryIcon: selectedCategory!.icon,
                      categoryType: selectedCategory!.type,
                      date: dateController.text,
                      walletId: selectedWallet!.id!,
                    );

                // total amount
                int amount =
                    (int.tryParse(amountController.text.replaceAll('.', '')) ??
                            0) *
                        (selectedCategory!.type == 'income' ? 1 : -1);
                int? initAmount = widget.transaction?.amount;
                if (initAmount != null) {
                  amount = amount -
                      (initAmount *
                          (widget.transaction!.type == 'income' ? 1 : -1));
                }

                // update wallet
                context.read<WalletCubit>().addTransaction(
                      userId: context
                          .read<AuthenticationDataCubit>()
                          .state
                          .data!
                          .id!,
                      walletId: selectedWallet!.id!,
                      amount: amount,
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
              hint: 'Name',
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
                  child: Image.asset(AssetPath.wallet),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 8,
              ),
            ),

            // divider
            const Divider(
              height: 0,
              thickness: 1,
            ),

            // amount
            TextFieldWidget(
              controller: amountController,
              hint: 'Insert Amount',
              inputType: TextInputType.number,
              usingCurrency: true,
              filled: true,
              prefix: Container(
                height: 36,
                width: 36,
                color: white,
                child: const FittedBox(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('RP'),
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 8,
              ),
            ),

            // divider
            const Divider(
              height: 0,
              thickness: 1,
            ),

            // category
            TextFieldWidget(
              controller: categoryController,
              hint: 'Select Category',
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
                  child: selectedCategory != null
                      ? Image.asset(selectedCategory!.icon)
                      : const SizedBox(),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 8,
              ),
              onTap: () async {
                CategoryModel? result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SelectCategoryPage(),
                  ),
                );

                if (result != null) {
                  setState(() {
                    categoryController.text = result.label ?? '';
                    selectedCategory = result;
                  });
                }
              },
            ),

            // divider
            const Divider(
              height: 0,
              thickness: 1,
            ),

            // date
            TextFieldWidget(
              controller: dateController,
              hint: 'dd/mm/yyyy',
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
                  child: Image.asset(AssetPath.calendar),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 8,
              ),
              onTap: () async {
                DateTime? result = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2010),
                  lastDate: DateTime.now(),
                );

                if (result != null) {
                  setState(() {
                    selectedDate = result;
                    dateController.text = textSelectedDate;
                  });
                }
              },
            ),

            // divider
            const Divider(
              height: 0,
              thickness: 1,
            ),

            // wallet
            TextFieldWidget(
              controller: walletController,
              hint: 'Select Wallet',
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
                  child: Image.asset(AssetPath.wallet),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 8,
              ),
              onTap: () async {
                WalletModel? result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SelectWalletPage(),
                  ),
                );

                if (result != null) {
                  setState(() {
                    walletController.text = result.name ?? '';
                    selectedWallet = result;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
