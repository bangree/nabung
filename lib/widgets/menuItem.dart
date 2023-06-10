import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nabung/constants/color.dart';

class MenuItem extends StatelessWidget {
  final String? icon;
  final String label;
  final Color? labelColor;
  final TextAlign? textAlign;
  final Function()? onTap;
  final List<Widget> slidableActions;

  const MenuItem({
    Key? key,
    this.icon,
    required this.label,
    this.labelColor,
    this.textAlign,
    this.onTap,
    this.slidableActions = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      enabled: slidableActions.isNotEmpty,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: slidableActions,
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: white,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                if (icon != null) ...[
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: lightGrey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Image.asset(
                        icon!,
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      color: (labelColor ?? customText).withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: textAlign,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
