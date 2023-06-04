import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nabung/constants/assetPath.dart';
import 'package:nabung/constants/color.dart';
import 'package:nabung/model/transactionModel.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionItem({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        print('clicked on transaction item');
      },
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
            NumberFormat.currency(
              locale: 'id',
              symbol: 'Rp ',
              decimalDigits: 0,
            ).format(transaction.amount ?? 0),
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              color: Colors.red,
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
    );
  }
}
