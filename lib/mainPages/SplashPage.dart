import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabung/constants/assetPath.dart';
import 'package:nabung/cubit/authenticationDataCubit.dart';
import 'package:nabung/cubit/baseState.dart';
import 'package:nabung/mainPages/LoginPage.dart';
import 'package:nabung/mainPages/MainPage.dart';
import 'package:nabung/model/userModel.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationDataCubit, BaseState<UserModel>>(
      listener: (context, state) {
        if (state is UnAuthenticationState) {
          // go to login page
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
            (route) => false,
          );
        }
        if (state is AuthenticatedState) {
          // go to main page
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MainPage(),
            ),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Image.asset(AssetPath.logoName),
          ),
        ),
      ),
    );
  }
}
