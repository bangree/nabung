import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabung/constants/assetPath.dart';
import 'package:nabung/constants/color.dart';
import 'package:nabung/cubit/baseState.dart';
import 'package:nabung/cubit/transactionCubit.dart';
import 'package:nabung/cubit/walletCubit.dart';
import 'package:nabung/mainPages/SelectWalletPage.dart';
import 'package:nabung/model/transactionModel.dart';
import 'package:nabung/model/walletModel.dart';
import 'package:nabung/widgets/transactionsItem.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  WalletModel? selectedWallet;

  @override
  Widget build(BuildContext context) {
    final List<WalletModel> wallets =
        context.watch<WalletCubit>().state.data ?? [];
    if (wallets.isEmpty) {
      return const Center(
        child: Text('Wallet not found!'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // header
        Container(
          color: const Color(0xff5E657E),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // padding top
              SizedBox(height: MediaQuery.of(context).padding.top),

              // title and search
              SizedBox(
                height: kToolbarHeight,
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            WalletModel? result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SelectWalletPage(),
                              ),
                            );

                            if (result != null) {
                              setState(() {
                                selectedWallet = result;
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Text(
                                selectedWallet!.name ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_drop_down,
                                color: white,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // total balance
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // active total balance
                          const Text(
                            'Active Total Balance',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // balance
                          Text(
                            selectedWallet!.textBalance,
                            style: const TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white.withOpacity(0.15),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(
                height: 20,
                color: Colors.white,
              ),

              // percentage
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.white.withOpacity(0.15),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(AssetPath.cross),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  'Goal',
                                  style: TextStyle(
                                    color: white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  selectedWallet!.textGoal,
                                  style: const TextStyle(
                                    color: red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.white.withOpacity(0.15),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(AssetPath.check),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  'Budget',
                                  style: TextStyle(
                                    color: white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  selectedWallet!.textBudgetPlan,
                                  style: const TextStyle(
                                    color: green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),

        // expenses earnings
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // title
              const Row(
                children: [
                  Expanded(
                    child: Text(
                      'Expenses Earnings',
                      style: TextStyle(
                        color: Color(0xff031A6E),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text('Sort by'),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // list history
              BlocBuilder<TransactionCubit, BaseState<List<TransactionModel>>>(
                builder: (context, state) {
                  if (state is LoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is ErrorState) {
                    return const Center(
                      child: Text('Error, Something Wrong!'),
                    );
                  }

                  if (state is LoadedState) {
                    selectedWallet = selectedWallet ?? wallets.first;
                    final List<TransactionModel> transactions = (state.data ??
                            [])
                        .where(
                            (element) => element.walletId == selectedWallet!.id)
                        .toList();

                    if (transactions.isEmpty) {
                      return const Center(
                        child: Text('Transaction not found!'),
                      );
                    }

                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ...List.generate(
                            transactions.length,
                            (index) => Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TransactionItem(
                                  transaction: transactions[index],
                                ),
                                if (index < transactions.length - 1) ...[
                                  const Divider(),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
