import 'package:flutter/material.dart';
import 'package:nabung/constants/assetPath.dart';
import 'package:nabung/constants/color.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {},
          child: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: const Text('Back'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 20,
        ),
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Image.asset(
              AssetPath.logoName,
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Nabung',
            style: TextStyle(
              color: black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          const Text(
            'Version 1.1',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            'Nabung is a money management app  designed to help users to budget their expenses and create goals for them',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
