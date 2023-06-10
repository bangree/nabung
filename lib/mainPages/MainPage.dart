import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabung/cubit/authenticationDataCubit.dart';
import 'package:nabung/cubit/categoryCubit.dart';
import 'package:nabung/cubit/mainCubit.dart';
import 'package:nabung/cubit/transactionCubit.dart';
import 'package:nabung/cubit/userCubit.dart';
import 'package:nabung/cubit/walletCubit.dart';
import 'package:nabung/model/userModel.dart';

import 'AccountPage.dart';
import 'FormTransactionPage.dart';
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

  @override
  void initState() {
    // init wallet & transaction
    UserModel user = context.read<AuthenticationDataCubit>().state.data!;
    context.read<WalletCubit>().init(userId: user.id!);
    context.read<TransactionCubit>().init(userId: user.id!);
    context.read<CategoryCubit>().init(userId: user.id!);
    context.read<UserCubit>().init(user: user);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit(),
      child: Builder(builder: (context) {
        return BlocBuilder<MainCubit, int>(
          builder: (context, currentIndex) {
            return Scaffold(
              body: IndexedStack(
                index: currentIndex,
                children: screens,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  // open form transaction page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FormTransactionPage(),
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
                  context.read<MainCubit>().change(val);
                },
                backgroundColor: Colors.white,
                activeColor: const Color(0xff031A6E),
                inactiveColor: const Color(0xffCBCBDD),
                gapLocation: GapLocation.center,
                notchSmoothness: NotchSmoothness.defaultEdge,
              ),
            );
          },
        );
      }),
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
