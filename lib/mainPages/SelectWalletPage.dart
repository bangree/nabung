import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabung/constants/color.dart';
import 'package:nabung/cubit/walletCubit.dart';
import 'package:nabung/model/colorModel.dart';
import 'package:nabung/model/walletModel.dart';

class SelectWalletPage extends StatelessWidget {
  const SelectWalletPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<WalletModel> wallets =
        context.read<WalletCubit>().state.data ?? [];

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
        title: const Text('Select Wallet'),
      ),
      body: wallets.isEmpty
          ? const Center(
              child: Text('Wallet not found!'),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              itemCount: wallets.length,
              itemBuilder: (context, index) {
                WalletModel wallet = wallets[index];
                return InkWell(
                  onTap: () {
                    Navigator.pop(
                      context,
                      wallet,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: index < ColorModel.colors.length - 1
                        ? BoxDecoration(
                            color: white,
                            border: Border(
                              bottom: BorderSide(
                                width: 1,
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                          )
                        : const BoxDecoration(
                            color: white,
                          ),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          // color
                          Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              color: wallet.walletColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),

                          const SizedBox(width: 8),

                          // label
                          Expanded(
                            child: Text(
                              wallet.name ?? '-',
                              style: TextStyle(
                                fontSize: 15,
                                color: customText.withOpacity(0.5),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
