import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nabung/constants/color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabung/cubit/settingCubit.dart';
import 'package:nabung/model/settingModel.dart';

class DisplayPage extends StatelessWidget {
  const DisplayPage({Key? key}) : super(key: key);

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
        title: const Text('Display'),
      ),
      body: ListView(
        children: [
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
                      'Wallet Auto-Scroll',
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
                        value: state.isAutoPlay,
                        onChanged: (value) =>
                            context.read<SettingCubit>().changeAutoPlay(),
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
