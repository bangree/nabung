import 'package:flutter/material.dart';
import 'package:nabung/constants/assetPath.dart';
import 'package:nabung/mainPages/DisplayPage.dart';
import 'package:nabung/mainPages/NotificationPage.dart';
import 'package:nabung/widgets/menuItem.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

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
            icon: AssetPath.notification,
            label: 'Notifications',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationPage(),
                ),
              );
            },
          ),
          const Divider(height: 0),
          MenuItem(
            icon: AssetPath.display,
            label: 'Display',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DisplayPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
