import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabung/constants/color.dart';
import 'package:nabung/cubit/settingCubit.dart';
import 'package:nabung/model/settingModel.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

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
        title: const Text('Notifications'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Notify At',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            color: white,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Overbudget',
                      style: TextStyle(
                        fontSize: 15,
                        color: customText.withOpacity(0.5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  BlocBuilder<SettingCubit, SettingModel>(
                    builder: (context, state) {
                      return CupertinoSwitch(
                        value: state.isOverBudget,
                        onChanged: (value) =>
                            context.read<SettingCubit>().changeOverBudget(),
                        activeColor: primary,
                        thumbColor: white,
                        trackColor: black,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
