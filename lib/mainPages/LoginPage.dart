import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:nabung/constants/assetPath.dart';
import 'package:nabung/constants/color.dart';
import 'package:nabung/cubit/authenticationActionCubit.dart';
import 'package:nabung/cubit/authenticationDataCubit.dart';
import 'package:nabung/cubit/baseState.dart';
import 'package:nabung/mainPages/MainPage.dart';
import 'package:nabung/mainPages/RegisterPage.dart';
import 'package:nabung/model/userModel.dart';
import 'package:nabung/repository/authenticationRepository.dart';
import 'package:nabung/widgets/primaryButton.dart';
import 'package:nabung/widgets/textFieldWidget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationActionCubit(
        authenticationRepository: context.read<AuthenticationRepository>(),
      ),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: BlocConsumer<AuthenticationActionCubit, BaseState<UserModel>>(
              listener: (context, state) {
                if (state is SuccessState) {
                  // update authentication data
                  context.read<AuthenticationDataCubit>().update(
                        userModel: state.data,
                      );

                  Flushbar(
                    message: (state as SuccessState).message ?? 'Login success',
                    backgroundColor: green,
                    duration: const Duration(seconds: 2),
                  ).show(context);

                  // go to main page
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainPage(),
                    ),
                    (route) => false,
                  );
                }
                if (state is ErrorState) {
                  Flushbar(
                    message: (state as ErrorState).message ?? 'Login fail',
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

                                // email & pass
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
                                            .login(
                                              email: emailController.text,
                                              password: passwordController.text,
                                            );
                                      }
                                    },
                                    text: 'LOGIN',
                                  ),
                                  const SizedBox(height: 12),
                                  PrimaryButton(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterPage(),
                                        ),
                                      );
                                    },
                                    text: 'CREATE NEW ACCOUNT',
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
