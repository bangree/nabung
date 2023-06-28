import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabung/constants/assetPath.dart';
import 'package:nabung/constants/color.dart';
import 'package:nabung/cubit/baseState.dart';
import 'package:nabung/cubit/userCubit.dart';
import 'package:nabung/mainPages/AboutPage.dart';
import 'package:nabung/mainPages/EditProfilePage.dart';
import 'package:nabung/mainPages/SettingPage.dart';
import 'package:nabung/model/userModel.dart';
import 'package:nabung/widgets/menuItem.dart';
import 'package:nabung/widgets/textFieldWidget.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();

  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // padding top
          SizedBox(height: MediaQuery.of(context).padding.top),

          // title
          Container(
            height: kToolbarHeight,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Profile',
              style: TextStyle(fontSize: 18),
            ),
          ),

          BlocBuilder<UserCubit, BaseState<UserModel>>(
            builder: (context, state) {
              if (state.data != null) {
                UserModel user = state.data!;

                // set username controller
                usernameController.text = user.username ?? '';

                return Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    children: [
                      // profile
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              // Container(
                              //   height: 75,
                              //   width: 75,
                              //   decoration: const BoxDecoration(
                              //     shape: BoxShape.circle,
                              //     color: Color(0xffD9D9D9),
                              //   ),
                              // ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    IntrinsicHeight(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: isEdit
                                                ? TextFieldWidget(
                                                    controller:
                                                        usernameController,
                                                    hint: 'Username...',
                                                    validator: (val) {
                                                      if (val?.isEmpty ??
                                                          true) {
                                                        return 'this field cannot be empty';
                                                      }
                                                      return null;
                                                    },
                                                  )
                                                : Text(
                                                    user.username ?? '-',
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                          ),
                                          const SizedBox(width: 8),
                                          InkWell(
                                            onTap: () {
                                              if (isEdit) {
                                                if (formKey.currentState
                                                        ?.validate() ??
                                                    true) {
                                                  isEdit = false;

                                                  // update username
                                                  context
                                                      .read<UserCubit>()
                                                      .update(
                                                        user: user.copyWith(
                                                          username:
                                                              usernameController
                                                                  .text,
                                                        ),
                                                      );
                                                }
                                              } else {
                                                setState(() {
                                                  isEdit = true;
                                                });
                                              }
                                            },
                                            child: Image.asset(
                                              isEdit
                                                  ? AssetPath.check
                                                  : AssetPath.edit,
                                              height: 16,
                                              color: primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(user.email ?? '-'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // edit profile
                      MenuItem(
                        icon: AssetPath.profile,
                        label: 'EDIT PROFILE',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfilePage(),
                            ),
                          );
                        },
                      ),

                      const Divider(height: 0),

                      // setting
                      MenuItem(
                        icon: AssetPath.setting,
                        label: 'SETTING',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingPage(),
                            ),
                          );
                        },
                      ),

                      const Divider(height: 0),

                      // about
                      MenuItem(
                        icon: AssetPath.about,
                        label: 'ABOUT',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutPage(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
