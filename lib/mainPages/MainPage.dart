import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:nabung/constants/color.dart';
import 'package:nabung/cubit/authenticationActionCubit.dart';
import 'package:nabung/cubit/authenticationDataCubit.dart';
import 'package:nabung/cubit/baseState.dart';
import 'package:nabung/cubit/transactionCubit.dart';
import 'package:nabung/cubit/walletCubit.dart';
import 'package:nabung/mainPages/LoginPage.dart';
import 'package:nabung/model/userModel.dart';
import 'package:nabung/repository/authenticationRepository.dart';

import 'AccountPage.dart';
import 'AddPage.dart';
import 'HistoryPage.dart';
import 'HomePage.dart';
import 'WalletPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> screens = [
    const HomePage(),
    const HistoryPage(),
    const WalletPage(),
    const AccountPage(),
  ];

  final List<BottomNavMenu> menus = [
    BottomNavMenu(
      label: 'Home',
      icon: Icons.home,
    ),
    BottomNavMenu(
      label: 'History',
      icon: Icons.bar_chart,
    ),
    BottomNavMenu(
      label: 'Wallet',
      icon: Icons.credit_card,
    ),
    BottomNavMenu(
      label: 'Account',
      icon: Icons.person,
    ),
  ];

  final List<IconData> icons = [
    Icons.home,
    Icons.bar_chart,
    Icons.credit_card,
    Icons.person,
  ];

  int currentIndex = 0;

  @override
  void initState() {
    // init wallet & transaction
    UserModel user = context.read<AuthenticationDataCubit>().state.data!;
    context.read<WalletCubit>().init(userId: user.id!);
    context.read<TransactionCubit>().init(userId: user.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationActionCubit(
        authenticationRepository: context.read<AuthenticationRepository>(),
      ),
      child: Builder(
        builder: (context) {
          return BlocConsumer<AuthenticationActionCubit, BaseState<UserModel>>(
            listener: (context, state) {
              if (state is SuccessState) {
                // update authentication data
                context.read<AuthenticationDataCubit>().update(userModel: null);

                // reinit wallet & transaction
                context.read<WalletCubit>().reInit();
                context.read<TransactionCubit>().reInit();

                // go to login page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );

                Flushbar(
                  message: (state as SuccessState).message ?? 'Logout success',
                  backgroundColor: green,
                  duration: const Duration(seconds: 2),
                ).show(context);
              }
              if (state is ErrorState) {
                Flushbar(
                  message: (state as ErrorState).message ?? 'Logout fail',
                  backgroundColor: red,
                  duration: const Duration(seconds: 2),
                ).show(context);
              }
            },
            builder: (context, state) {
              return LoadingOverlay(
                isLoading: state is LoadingState,
                child: Scaffold(
                  body: IndexedStack(
                    index: currentIndex,
                    children: screens,
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      // open add transaction page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddPage(),
                        ),
                      );
                    },
                    backgroundColor: const Color(0xff031A6E),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerDocked,
                  bottomNavigationBar: AnimatedBottomNavigationBar(
                    icons: const [
                      Icons.home,
                      Icons.bar_chart,
                      Icons.credit_card,
                      Icons.person,
                    ],
                    activeIndex: currentIndex,
                    onTap: (val) {
                      setState(() {
                        currentIndex = val;
                      });
                    },
                    backgroundColor: Colors.white,
                    activeColor: const Color(0xff031A6E),
                    inactiveColor: const Color(0xffCBCBDD),
                    gapLocation: GapLocation.center,
                    notchSmoothness: NotchSmoothness.defaultEdge,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class BottomNavMenu {
  final String label;
  final IconData icon;

  BottomNavMenu({
    required this.label,
    required this.icon,
  });
}
