import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:nabung/constants/color.dart';
import 'package:nabung/cubit/authenticationActionCubit.dart';
import 'package:nabung/cubit/authenticationDataCubit.dart';
import 'package:nabung/cubit/baseState.dart';
import 'package:nabung/cubit/categoryCubit.dart';
import 'package:nabung/cubit/transactionCubit.dart';
import 'package:nabung/cubit/userCubit.dart';
import 'package:nabung/cubit/walletCubit.dart';
import 'package:nabung/mainPages/ChangePasswordPage.dart';
import 'package:nabung/mainPages/LoginPage.dart';
import 'package:nabung/model/userModel.dart';
import 'package:nabung/repository/authenticationRepository.dart';
import 'package:nabung/widgets/menuItem.dart';
import 'package:nabung/widgets/textFieldWidget.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationActionCubit(
        authenticationRepository: context.read<AuthenticationRepository>(),
      ),
      child: Builder(builder: (context) {
        return BlocConsumer<AuthenticationActionCubit, BaseState<UserModel>>(
          listener: (context, state) {
            if (state is SuccessState) {
              // update authentication data
              context.read<AuthenticationDataCubit>().update(userModel: null);

              // reinit wallet, transaction & user
              context.read<WalletCubit>().reInit();
              context.read<TransactionCubit>().reInit();
              context.read<CategoryCubit>().reInit();
              context.read<UserCubit>().reInit();

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
                appBar: AppBar(
                  leading: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                    ),
                  ),
                  title: const Text('Back'),
                ),
                body: ListView(
                  children: [
                    const SizedBox(height: 8),
                    MenuItem(
                      label: 'Change Password',
                      labelColor: green,
                      textAlign: TextAlign.center,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePasswordPage(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 0),
                    MenuItem(
                      label: 'Sign Out',
                      labelColor: red,
                      textAlign: TextAlign.center,
                      onTap: () {
                        AuthenticationActionCubit authenticationActionCubit =
                            context.read<AuthenticationActionCubit>();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: const Text('Are you sure ?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    authenticationActionCubit.logout();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    const Divider(height: 0),
                    MenuItem(
                      label: 'Delete Account',
                      labelColor: red,
                      textAlign: TextAlign.center,
                      onTap: () {
                        AuthenticationActionCubit authenticationActionCubit =
                            context.read<AuthenticationActionCubit>();
                        String email = context
                            .read<AuthenticationDataCubit>()
                            .state
                            .data!
                            .email!;

                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: const Text('Are you sure ?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);

                                    // show dialog input password
                                    String? password = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const InputPasswordDialog();
                                      },
                                    );

                                    if (password != null) {
                                      authenticationActionCubit.deleteAccount(
                                        email: email,
                                        password: password,
                                      );
                                    }
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class InputPasswordDialog extends StatefulWidget {
  const InputPasswordDialog({Key? key}) : super(key: key);

  @override
  State<InputPasswordDialog> createState() => _InputPasswordDialogState();
}

class _InputPasswordDialogState extends State<InputPasswordDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFieldWidget(
              controller: passwordController,
              hint: 'Masukkan password',
              obscure: true,
              validator: (val) {
                if (val?.isEmpty ?? true) {
                  return 'this field cannot be empty';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (formKey.currentState?.validate() ?? false) {
              Navigator.pop(context, passwordController.text);
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
