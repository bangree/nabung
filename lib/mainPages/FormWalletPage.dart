import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabung/constants/assetPath.dart';
import 'package:nabung/constants/color.dart';
import 'package:nabung/cubit/authenticationDataCubit.dart';
import 'package:nabung/cubit/walletCubit.dart';
import 'package:nabung/mainPages/SelectColorPage.dart';
import 'package:nabung/model/colorModel.dart';
import 'package:nabung/model/walletModel.dart';
import 'package:nabung/widgets/textFieldWidget.dart';

class FormWalletPage extends StatefulWidget {
  final WalletModel? wallet;

  const FormWalletPage({
    Key? key,
    this.wallet,
  }) : super(key: key);

  @override
  State<FormWalletPage> createState() => _FormWalletPageState();
}

class _FormWalletPageState extends State<FormWalletPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();
  final TextEditingController budgetPlanController = TextEditingController();
  final TextEditingController goalController = TextEditingController();
  final TextEditingController colorController = TextEditingController();

  ColorModel? selectedColor;

  @override
  void initState() {
    // init form
    if (widget.wallet != null) {
      nameController.text = widget.wallet!.name ?? '';
      balanceController.text = widget.wallet!.textBalance;
      budgetPlanController.text = widget.wallet!.textBudgetPlan;
      goalController.text = widget.wallet!.textGoal;
      colorController.text = widget.wallet!.color ?? '';
      selectedColor = ColorModel(
        label: widget.wallet!.color!,
        color: widget.wallet!.walletColor,
      );
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
        title: const Text('Add Wallet'),
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
                context.read<WalletCubit>().createOrUpdate(
                      userId: context
                          .read<AuthenticationDataCubit>()
                          .state
                          .data!
                          .id!,
                      id: widget.wallet?.id,
                      name: nameController.text,
                      balance: balanceController.text,
                      budgetPlan: budgetPlanController.text,
                      goal: goalController.text,
                      color: colorController.text,
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
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 8,
              ),
            ),

            // divider
            const Divider(
              height: 0,
              thickness: 1,
            ),

            // balance
            TextFieldWidget(
              controller: balanceController,
              hint: 'Balance',
              inputType: TextInputType.number,
              usingCurrency: true,
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
                  child: Image.asset(AssetPath.balance),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 8,
              ),
            ),

            // divider
            const Divider(
              height: 0,
              thickness: 1,
            ),

            // budget plan
            TextFieldWidget(
              controller: budgetPlanController,
              hint: 'Budget Plan / per day',
              inputType: TextInputType.number,
              usingCurrency: true,
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
                  child: Image.asset(AssetPath.plan),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 8,
              ),
            ),

            // divider
            const Divider(
              height: 0,
              thickness: 1,
            ),

            // goal
            TextFieldWidget(
              controller: goalController,
              hint: 'Goal',
              inputType: TextInputType.number,
              usingCurrency: true,
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
                  child: Image.asset(AssetPath.goal),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 8,
              ),
            ),

            // divider
            const Divider(
              height: 0,
              thickness: 1,
            ),

            // select color
            TextFieldWidget(
              controller: colorController,
              hint: 'Select Color',
              readOnly: true,
              filled: true,
              prefix: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: selectedColor?.color ?? lightGrey,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 8,
              ),
              onTap: () async {
                ColorModel? result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SelectColorPage(),
                  ),
                );

                if (result != null) {
                  setState(() {
                    colorController.text = result.label ?? '';
                    selectedColor = result;
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
