import 'package:flutter/material.dart';
import 'package:nabung/constants/assetPath.dart';
import 'package:nabung/constants/color.dart';
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
    return Scaffold(
      body: Form(
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
                      padding: const EdgeInsets.symmetric(horizontal: 40),
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
                    ),
                    const SizedBox(height: 20),
                    TextFieldWidget(
                      controller: usernameController,
                      hint: 'Username...',
                    ),
                    const SizedBox(height: 20),
                    TextFieldWidget(
                      controller: passwordController,
                      hint: 'Password...',
                      obscure: true,
                    ),
                    const SizedBox(height: 20),
                    TextFieldWidget(
                      controller: confirmPasswordController,
                      hint: 'Confirm Password...',
                      obscure: true,
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
                          /// todo:
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
  }
}
