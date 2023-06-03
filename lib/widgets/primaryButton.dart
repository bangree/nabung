import 'package:flutter/material.dart';
import 'package:nabung/constants/color.dart';

class PrimaryButton extends StatelessWidget {
  final Function() onTap;
  final String text;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final bool isOutlined;

  const PrimaryButton({
    Key? key,
    required this.onTap,
    required this.text,
    this.foregroundColor,
    this.backgroundColor,
    this.padding,
    this.isOutlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isOutlined ? outlinedButton : elevatedButton;
  }

  Widget get elevatedButton {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
        foregroundColor: foregroundColor ?? white,
        backgroundColor: backgroundColor ?? primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget get outlinedButton {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
        foregroundColor: foregroundColor ?? black,
        backgroundColor: backgroundColor ?? white,
        side: BorderSide(
          width: 1,
          color: foregroundColor ?? black,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
