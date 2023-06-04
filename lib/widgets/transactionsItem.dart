import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nabung/constants/assetPath.dart';
import 'package:nabung/constants/color.dart';
import 'package:nabung/cubit/authenticationDataCubit.dart';
import 'package:nabung/cubit/transactionCubit.dart';
import 'package:nabung/cubit/walletCubit.dart';
import 'package:nabung/mainPages/FormTransactionPage.dart';
import 'package:nabung/model/transactionModel.dart';
import 'package:nabung/model/userModel.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;
  final Function()? onTap;

  const TransactionItem({
    Key? key,
    required this.transaction,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              // open form transaction page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FormTransactionPage(
                    transaction: transaction,
                  ),
                ),
              );
            },
            backgroundColor: green,
            foregroundColor: white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (_) {
              // show alert dialog remove
              UserModel user =
                  context.read<AuthenticationDataCubit>().state.data!;
              TransactionCubit transactionCubit =
                  context.read<TransactionCubit>();
              WalletCubit walletCubit = context.read<WalletCubit>();
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
                          transactionCubit.delete(
                            userId: user.id!,
                            transactionId: transaction.id!,
                          );

                          // update balance wallet
                          walletCubit.addTransaction(
                            userId: user.id!,
                            walletId: transaction.walletId!,
                            amount: transaction.amount! *
                                (transaction.type == 'income' ? -1 : 1),
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
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: customBackground.withOpacity(1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Image.asset(
              transaction.categoryIcon ?? AssetPath.logo,
              height: 20,
              width: 20,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.name ?? '-',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  transaction.categoryName ?? '-',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xff222222).withOpacity(0.4),
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${transaction.type == 'income' ? '' : '- '}Rp ${transaction.textAmount}',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16,
                color: transaction.type == 'income' ? green : red,
              ),
            ),
            Text(
              transaction.date ?? '-',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                color: const Color(0xff222222).withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
