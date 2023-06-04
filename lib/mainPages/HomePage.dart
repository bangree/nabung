import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabung/constants/color.dart';
import 'package:nabung/cubit/authenticationDataCubit.dart';
import 'package:nabung/cubit/baseState.dart';
import 'package:nabung/cubit/transactionCubit.dart';
import 'package:nabung/cubit/walletCubit.dart';
import 'package:nabung/mainPages/FormTransactionPage.dart';
import 'package:nabung/mainPages/FormWalletPage.dart';
import 'package:nabung/model/transaction.dart';
import 'package:nabung/model/transactionModel.dart';
import 'package:nabung/model/walletModel.dart';
import 'package:nabung/widgets/transactionsItem.dart';
import 'package:nabung/widgets/wallets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CarouselController carouselController = CarouselController();

  int currentIndex = 0;

  final transList = Transaction.transactionList();

  final children = List<Widget>.generate(5, (i) => ListTile(title: Text('$i')));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),

          // wallet carousel
          BlocBuilder<WalletCubit, BaseState<List<WalletModel>>>(
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
                final List<WalletModel> wallets = state.data ?? [];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // card wallet carousel
                      CarouselSlider(
                        carouselController: carouselController,
                        options: CarouselOptions(
                          aspectRatio: 300 / 170,
                          viewportFraction: 1,
                          autoPlay: wallets.length > 1,
                          disableCenter: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                        ),
                        items: List.generate(
                          wallets.isEmpty
                              ? 1
                              : wallets.length > 3
                                  ? 3
                                  : wallets.length,
                          (index) => WalletBox(
                            wallet: wallets.isNotEmpty ? wallets[index] : null,
                            onTap: () {
                              if (wallets.isEmpty) {
                                // go to form wallet
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const FormWalletPage(),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // dots indicator
                      DotsIndicator(
                        dotsCount: wallets.isEmpty
                            ? 1
                            : wallets.length > 3
                                ? 3
                                : wallets.length,
                        position: currentIndex,
                        decorator: const DotsDecorator(
                          color: grey,
                          // Inactive color
                          activeColor: primary,
                          size: Size(6.0, 6.0),
                          activeSize: Size(24.0, 6.0),
                          activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          spacing: EdgeInsets.symmetric(horizontal: 2),
                        ),
                        onTap: (val) {
                          carouselController.animateToPage(val.toInt());
                        },
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),

          const SizedBox(height: 50),

          Expanded(
            child: BlocBuilder<TransactionCubit,
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
                  final List<TransactionModel> transactions = state.data ?? [];
                  if (transactions.isEmpty) return const SizedBox();

                  return ListView(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),
                    children: [
                      const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Transactions',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'See All',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ]),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
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
                                    onTap: () {
                                      // open form transaction page
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FormTransactionPage(
                                            transaction: transactions[index],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  if (index < transactions.length - 1) ...[
                                    const Divider(),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: customBackground,
      title: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome Back,',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.4),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                context.read<AuthenticationDataCubit>().state.data?.username ??
                    '-',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
