import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:nabung/constants/assetPath.dart';
import 'package:nabung/constants/color.dart';
import 'package:nabung/cubit/authenticationActionCubit.dart';
import 'package:nabung/cubit/baseState.dart';
import 'package:nabung/model/userModel.dart';
import 'package:nabung/repository/authenticationRepository.dart';
import 'package:nabung/widgets/primaryButton.dart';
import 'package:nabung/widgets/textFieldWidget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationActionCubit(
          authenticationRepository: context.read<AuthenticationRepository>()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: BlocConsumer<AuthenticationActionCubit, BaseState<UserModel>>(
              listener: (context, state) {
                if (state is SuccessState) {
                  Navigator.pop(context);

                  Flushbar(
                    message:
                        (state as SuccessState).message ?? 'Sign up success',
                    backgroundColor: green,
                    duration: const Duration(seconds: 2),
                  ).show(context);
                }
                if (state is ErrorState) {
                  Flushbar(
                    message: (state as ErrorState).message ?? 'Register fail',
                    backgroundColor: red,
                    duration: const Duration(seconds: 2),
                  ).show(context);
                }
              },
              builder: (context, state) {
                return LoadingOverlay(
                  isLoading: state is LoadingState,
                  child: Form(
                    key: formKey,
                    child: CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 24,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                const SizedBox(height: 60),

                                // icon
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  child: Image.asset(
                                    AssetPath.logoName,
                                  ),
                                ),

                                const SizedBox(height: 40),

                                // welcome
                                const Text(
                                  'Welcome to Nabung!',
                                  style: TextStyle(
                                    color: black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'ayo menabung sekarang',
                                  textAlign: TextAlign.center,
                                ),

                                const SizedBox(height: 60),

                                // email, username, pass & confirm pass
                                TextFieldWidget(
                                  controller: emailController,
                                  hint: 'Email...',
                                  inputType: TextInputType.emailAddress,
                                  validator: (val) {
                                    if (val?.isEmpty ?? true) {
                                      return 'this field cannot be empty';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                TextFieldWidget(
                                  controller: usernameController,
                                  hint: 'Username...',
                                  validator: (val) {
                                    if (val?.isEmpty ?? true) {
                                      return 'this field cannot be empty';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                TextFieldWidget(
                                  controller: passwordController,
                                  hint: 'Password...',
                                  obscure: true,
                                  validator: (val) {
                                    if (val?.isEmpty ?? true) {
                                      return 'this field cannot be empty';
                                    }
                                    if (val!.length < 6) {
                                      return 'min. 6 character';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                TextFieldWidget(
                                  controller: confirmPasswordController,
                                  hint: 'Confirm Password...',
                                  obscure: true,
                                  validator: (val) {
                                    if (val?.isEmpty ?? true) {
                                      return 'this field cannot be empty';
                                    }
                                    if (val!.length < 6) {
                                      return 'min. 6 character';
                                    }
                                    if (val != passwordController.text) {
                                      return 'password does not match';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          sliver: SliverFillRemaining(
                            hasScrollBody: false,
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // login & register
                                  PrimaryButton(
                                    onTap: () {
                                      if (formKey.currentState?.validate() ??
                                          false) {
                                        context
                                            .read<AuthenticationActionCubit>()
                                            .register(
                                              username: usernameController.text,
                                              email: emailController.text,
                                              password: passwordController.text,
                                            );
                                      }
                                    },
                                    text: 'REGISTER',
                                  ),
                                  const SizedBox(height: 12),
                                  PrimaryButton(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    text: 'SIGN IN',
                                    isOutlined: true,
                                  ),

                                  const SizedBox(height: 40),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
