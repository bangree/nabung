import 'package:flutter/material.dart';
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
    return Scaffold(
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
              filled: true,
            ),
            const Divider(height: 0),
            TextFieldWidget(
              controller: newPasswordController,
              hint: 'New Password',
              filled: true,
            ),
            const Divider(height: 0),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: PrimaryButton(
                onTap: () {
                  /// TODO:
                },
                text: 'Change Password',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
