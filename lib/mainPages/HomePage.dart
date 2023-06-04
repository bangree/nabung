import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabung/constants/color.dart';
import 'package:nabung/cubit/authenticationDataCubit.dart';
import 'package:nabung/model/transaction.dart';
import 'package:nabung/widgets/transactionsItem.dart';
import 'package:nabung/widgets/wallets.dart';
import 'package:dots_indicator/dots_indicator.dart';

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
      backgroundColor: customBackground.withOpacity(1),
      appBar: _buildAppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // card wallet carousel
            CarouselSlider(
              carouselController: carouselController,
              options: CarouselOptions(
                aspectRatio: 320 / 175,
                viewportFraction: 1,
                autoPlay: true,
                disableCenter: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
              items: List.generate(
                3,
                (index) => const WalletBox(
                  color: Color(0xFF5E657E),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // dots indicator
            DotsIndicator(
              dotsCount: 3,
              position: currentIndex,
              decorator: const DotsDecorator(
                color: grey, // Inactive color
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

            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 50, bottom: 20),
                children: [
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Transactions',
                          style:
                              TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
                        ),
                        Text(
                          'See All',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              color: Colors.blue),
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
                          Transaction.transactionList().length,
                          (index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TransactionItem(
                                transaction:
                                    Transaction.transactionList()[index],
                              ),
                              if (index <
                                  Transaction.transactionList().length - 1) ...[
                                const Divider(),
                              ],
                            ],
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
