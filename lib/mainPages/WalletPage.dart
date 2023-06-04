import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabung/cubit/baseState.dart';
import 'package:nabung/cubit/walletCubit.dart';
import 'package:nabung/mainPages/FormWalletPage.dart';
import 'package:nabung/model/walletModel.dart';
import 'package:nabung/widgets/wallets.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // padding top
        SizedBox(height: MediaQuery.of(context).padding.top),

        // title
        Container(
          height: kToolbarHeight,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: IntrinsicHeight(
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Wallets',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      // go to form wallet
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FormWalletPage(),
                        ),
                      );
                    },
                    child: const Text(
                      '+ New Wallets',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xff7C92E2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // list card
        Expanded(
          child: BlocBuilder<WalletCubit, BaseState<List<WalletModel>>>(
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
                return ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: wallets.isEmpty ? 1 : wallets.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(top: index == 0 ? 0 : 16),
                      child: WalletBox(
                        wallet: wallets.isEmpty ? null : wallets[index],
                        onTap: () {
                          if (wallets.isEmpty) {
                            // go to form wallet
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FormWalletPage(),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
