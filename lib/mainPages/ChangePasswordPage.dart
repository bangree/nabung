import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:nabung/constants/color.dart';
import 'package:nabung/cubit/authenticationActionCubit.dart';
import 'package:nabung/cubit/authenticationDataCubit.dart';
import 'package:nabung/cubit/baseState.dart';
import 'package:nabung/model/userModel.dart';
import 'package:nabung/repository/authenticationRepository.dart';
import 'package:nabung/widgets/primaryButton.dart';
import 'package:nabung/widgets/textFieldWidget.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationActionCubit(
        authenticationRepository: context.read<AuthenticationRepository>(),
      ),
      child: Builder(builder: (context) {
        return Builder(builder: (context) {
          return BlocConsumer<AuthenticationActionCubit, BaseState<UserModel>>(
            listener: (context, state) {
              if (state is SuccessState) {
                // back to edit profile
                Navigator.pop(context);

                Flushbar(
                  message: (state as SuccessState).message ??
                      'Change Password success',
                  backgroundColor: green,
                  duration: const Duration(seconds: 2),
                ).show(context);
              }
              if (state is ErrorState) {
                Flushbar(
                  message:
                      (state as ErrorState).message ?? 'Change Password fail',
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
                    title: const Text('Change Password'),
                  ),
                  body: Form(
                    key: formKey,
                    child: ListView(
                      children: [
                        const SizedBox(height: 8),
                        TextFieldWidget(
                          controller: oldPasswordController,
                          hint: 'Old Password',
                          obscure: true,
                          filled: true,
                        ),
                        const Divider(height: 0),
                        TextFieldWidget(
                          controller: newPasswordController,
                          hint: 'New Password',
                          obscure: true,
                          filled: true,
                        ),
                        const Divider(height: 0),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: PrimaryButton(
                            onTap: () {
                              if (formKey.currentState?.validate() ?? false) {
                                context
                                    .read<AuthenticationActionCubit>()
                                    .changePassword(
                                      email: context
                                          .read<AuthenticationDataCubit>()
                                          .state
                                          .data!
                                          .email!,
                                      oldPassword: oldPasswordController.text,
                                      newPassword: newPasswordController.text,
                                    );
                              }
                            },
                            text: 'Change Password',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
      }),
    );
  }
}
