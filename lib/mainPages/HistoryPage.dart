import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nabung/constants/assetPath.dart';
import 'package:nabung/constants/color.dart';
import 'package:nabung/cubit/baseState.dart';
import 'package:nabung/cubit/transactionCubit.dart';
import 'package:nabung/cubit/walletCubit.dart';
import 'package:nabung/mainPages/FormTransactionPage.dart';
import 'package:nabung/mainPages/SelectWalletPage.dart';
import 'package:nabung/model/transactionModel.dart';
import 'package:nabung/model/walletModel.dart';
import 'package:nabung/widgets/dropdownWidget.dart';
import 'package:nabung/widgets/transactionsItem.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final TextEditingController searchController = TextEditingController();

  final List<String> orders = [
    'Date',
    'Highest',
    'Lowest',
  ];

  String? orderBy;
  String? search;
  WalletModel? selectedWallet;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletCubit, BaseState<List<WalletModel>>>(
      listener: (context, walletState) {
        if (walletState is LoadedState) {
          final List<WalletModel> wallets = walletState.data ?? [];
          // update selected wallet
          selectedWallet = wallets.firstWhereOrNull(
                  (element) => element.id == selectedWallet?.id) ??
              (wallets.isNotEmpty ? wallets.first : null);
        }
      },
      builder: (context, walletState) {
        if (walletState is LoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (walletState is LoadedState) {
          final List<WalletModel> wallets = walletState.data ?? [];
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
                                      builder: (context) =>
                                          const SelectWalletPage(),
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
                            AnimSearchBar(
                              width: 200,
                              textController: searchController,
                              onSuffixTap: () {
                                searchController.clear();
                                setState(() {});
                              },
                              onSubmitted: (val) {
                                // search
                                search = val;
                                setState(() {});
                              },
                            ),
                            // const Icon(
                            //   Icons.search,
                            //   color: Colors.white,
                            // ),
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
                          InkWell(
                            onTap: () {
                              // open form transaction page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const FormTransactionPage(),
                                ),
                              );
                            },
                            child: Container(
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
                          ),
                        ],
                      ),
                    ),

                    const Divider(
                      height: 20,
                      color: Colors.white,
                    ),

                    // percentage
                    BlocBuilder<TransactionCubit,
                        BaseState<List<TransactionModel>>>(
                      builder: (context, transactionState) {
                        if (transactionState is LoadedState) {
                          final String day =
                              DateFormat('dd/MM/yyyy').format(DateTime.now());
                          List<TransactionModel> dayTransaction =
                              (transactionState.data ?? [])
                                  .where((element) =>
                                      element.date == day &&
                                      element.walletId == selectedWallet!.id)
                                  .toList();

                          int totalDayTransaction = 0;
                          for (TransactionModel t in dayTransaction) {
                            totalDayTransaction += (t.valueAmount * -1);
                          }

                          bool isOverBudget = totalDayTransaction >
                              (selectedWallet!.budgetPlan ?? 0);

                          return IntrinsicHeight(
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
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: Colors.white.withOpacity(0.15),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                              selectedWallet!.deviationGoal > 0
                                                  ? AssetPath.check
                                                  : AssetPath.cross,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            const Text(
                                              'Goal',
                                              style: TextStyle(
                                                color: white,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              selectedWallet!.textDeviationGoal,
                                              style: TextStyle(
                                                color: selectedWallet!
                                                            .deviationGoal >
                                                        0
                                                    ? green
                                                    : red,
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
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: Colors.white.withOpacity(0.15),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                              isOverBudget
                                                  ? AssetPath.cross
                                                  : AssetPath.check,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            const Text(
                                              'Budget',
                                              style: TextStyle(
                                                color: white,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${currencyFormat(value: totalDayTransaction < 0 ? (totalDayTransaction * -1) : totalDayTransaction)} / ${selectedWallet!.textBudgetPlan}',
                                              style: TextStyle(
                                                color:
                                                    isOverBudget ? red : green,
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
                          );
                        }
                        return const SizedBox();
                      },
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
                    Row(
                      children: [
                        const Text(
                          'Expenses Earnings',
                          style: TextStyle(
                            color: Color(0xff031A6E),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownWidget(
                            items: orders,
                            value: orderBy,
                            hint: 'Sort by',
                            onChange: (val) {
                              setState(() {
                                orderBy = val;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // list history
                    BlocBuilder<TransactionCubit,
                        BaseState<List<TransactionModel>>>(
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
                          List<TransactionModel> transactions =
                              (state.data ?? [])
                                  .where((element) =>
                                      element.walletId == selectedWallet!.id)
                                  .toList();

                          if (search?.trim().isNotEmpty ?? false) {
                            // search by name, category name, date
                            transactions = transactions
                                .where(
                                  (element) =>
                                      element.name!
                                          .toLowerCase()
                                          .contains(search!.toLowerCase()) ||
                                      element.categoryName!
                                          .toLowerCase()
                                          .contains(search!.toLowerCase()) ||
                                      element.date!
                                          .toLowerCase()
                                          .contains(search!.toLowerCase()),
                                )
                                .toList();
                          }

                          if (orderBy != null) {
                            if (orderBy == 'Date') {
                              transactions.sort(
                                  (a, b) => b.dateEpoch.compareTo(a.dateEpoch));
                            }
                            if (orderBy == 'Highest') {
                              transactions.sort((a, b) =>
                                  a.valueAmount.compareTo(b.valueAmount));
                            }
                            if (orderBy == 'Lowest') {
                              transactions.sort((a, b) =>
                                  b.valueAmount.compareTo(a.valueAmount));
                            }
                          }

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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
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
        return const SizedBox();
      },
    );
  }

  String currencyFormat({required int value}) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value);
  }
}
