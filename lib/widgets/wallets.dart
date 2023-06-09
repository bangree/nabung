import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabung/constants/assetPath.dart';
import 'package:nabung/constants/color.dart';
import 'package:nabung/cubit/authenticationDataCubit.dart';
import 'package:nabung/cubit/walletCubit.dart';
import 'package:nabung/mainPages/FormWalletPage.dart';
import 'package:nabung/model/userModel.dart';
import 'package:nabung/model/walletModel.dart';

class WalletBox extends StatefulWidget {
  final WalletModel? wallet;
  final Function()? onTap;

  const WalletBox({
    super.key,
    this.wallet,
    this.onTap,
  });

  @override
  State<WalletBox> createState() => _WalletBoxState();
}

class _WalletBoxState extends State<WalletBox> {
  bool showBalance = true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: AspectRatio(
        aspectRatio: 300 / 170,
        child: Container(
          decoration: BoxDecoration(
            color: widget.wallet == null
                ? const Color(0xFF5E657E)
                : widget.wallet!.walletColor,
            borderRadius: BorderRadius.circular(15),
            image: const DecorationImage(
              image: AssetImage(
                AssetPath.bgCard,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 32,
            ),
            child: widget.wallet == null
                ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // add
                        Image.asset(
                          AssetPath.addCircle,
                          height: 24,
                          width: 24,
                        ),

                        const SizedBox(width: 12),

                        // new wallet
                        const Text(
                          'New Wallet',
                          style: TextStyle(
                            fontSize: 24,
                            color: white,
                          ),
                        ),
                      ],
                    ),
                  )
                : Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Balance',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                PopupMenuButton(
                                  onSelected: (val) {
                                    if (val == 'edit') {
                                      // open form wallet
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FormWalletPage(
                                            wallet: widget.wallet!,
                                          ),
                                        ),
                                      );
                                    }
                                    if (val == 'delete') {
                                      WalletCubit walletCubit =
                                          context.read<WalletCubit>();
                                      UserModel user = context
                                          .read<AuthenticationDataCubit>()
                                          .state
                                          .data!;

                                      // show dialog delete
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content:
                                                const Text('Are you sure ?'),
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
                                                  walletCubit.delete(
                                                    userId: user.id!,
                                                    walletId:
                                                        widget.wallet!.id!,
                                                  );

                                                  // dismiss dialog
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Yes'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                        child: IntrinsicHeight(
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                AssetPath.edit2,
                                                height: 10,
                                                width: 10,
                                              ),
                                              const SizedBox(width: 8),
                                              const Text("Edit"),
                                            ],
                                          ),
                                        ),
                                        value: 'edit',
                                      ),
                                      PopupMenuItem(
                                        child: IntrinsicHeight(
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                AssetPath.trash,
                                                height: 10,
                                                width: 10,
                                              ),
                                              const SizedBox(width: 8),
                                              const Text("Delete"),
                                            ],
                                          ),
                                        ),
                                        value: 'delete',
                                      ),
                                    ];
                                  },
                                  icon: const Icon(
                                    Icons.more_horiz,
                                    color: Colors.white,
                                  ),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.wallet!.dateUpdatedAt,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(height: 25),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  showBalance
                                      ? widget.wallet!.textBalance
                                      : widget.wallet!.textBalance
                                          .replaceAll(RegExp(r'\d'), '*'),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    showBalance = !showBalance;
                                  });
                                },
                                child: Image.asset(
                                  showBalance ? AssetPath.blind : AssetPath.eye,
                                  width: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.wallet!.name ?? '',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _head() {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              height: 500,
              decoration: const BoxDecoration(
                color: Color(0xff368983),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 35,
                    left: 340,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Container(
                        height: 40,
                        width: 40,
                        color: const Color.fromRGBO(250, 250, 250, 0.1),
                        child: const Icon(
                          Icons.notification_add_outlined,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 35, left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good afternoon',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color.fromARGB(255, 224, 223, 223),
                          ),
                        ),
                        Text(
                          'Enjelin Morgeana',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 140,
          left: 37,
          child: Container(
            height: 175,
            width: 320,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(47, 125, 121, 0.3),
                  offset: Offset(0, 6),
                  blurRadius: 12,
                  spreadRadius: 6,
                ),
              ],
              color: const Color.fromARGB(255, 47, 125, 121),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Column(
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Balance',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 7),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        'TOTAL',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: Color.fromARGB(255, 85, 145, 141),
                            child: Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                              size: 19,
                            ),
                          ),
                          SizedBox(width: 7),
                          Text(
                            'Income',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color.fromARGB(255, 216, 216, 216),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: Color.fromARGB(255, 85, 145, 141),
                            child: Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                              size: 19,
                            ),
                          ),
                          SizedBox(width: 7),
                          Text(
                            'Expenses',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color.fromARGB(255, 216, 216, 216),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'INCOME',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'EXPENSES',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
