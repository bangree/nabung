import 'package:flutter/material.dart';
import 'package:nabung/constants/color.dart';
import 'package:nabung/mainPages/ChangePasswordPage.dart';
import 'package:nabung/widgets/menuItem.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

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
              // todo: show dialog
            },
          ),
          const Divider(height: 0),
          MenuItem(
            label: 'Delete Account',
            labelColor: red,
            textAlign: TextAlign.center,
            onTap: () {
              // todo: show dialog
            },
          ),
        ],
      ),
    );
  }
}
