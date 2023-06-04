import 'package:flutter/material.dart';
import 'package:nabung/constants/color.dart';
import 'package:nabung/model/colorModel.dart';

class SelectColorPage extends StatelessWidget {
  const SelectColorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text('Select Color'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        itemCount: ColorModel.colors.length,
        itemBuilder: (context, index) {
          ColorModel colorModel = ColorModel.colors[index];
          return InkWell(
            onTap: () {
              Navigator.pop(
                context,
                colorModel,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: index < ColorModel.colors.length - 1
                  ? BoxDecoration(
                      color: white,
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    )
                  : const BoxDecoration(
                      color: white,
                    ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    // color
                    Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: colorModel.color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // label
                    Expanded(
                      child: Text(
                        colorModel.label ?? '-',
                        style: TextStyle(
                          fontSize: 15,
                          color: customText.withOpacity(0.5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
