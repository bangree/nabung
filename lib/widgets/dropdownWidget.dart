import 'package:flutter/material.dart';

class DropdownWidget extends StatelessWidget {
  final List<String> items;
  final String? value;
  final String? hint;
  final Function(String)? onChange;

  const DropdownWidget({
    Key? key,
    required this.items,
    this.value,
    this.onChange,
    this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        hint: Text(hint ?? ''),
        items: List.generate(
          items.length,
          (index) => DropdownMenuItem(
            value: items[index],
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(items[index]),
            ),
          ),
        ),
        onChanged: (value) {
          if (value != null && onChange != null) {
            onChange!(value);
          }
        },
        isExpanded: true,
        isDense: true,
        alignment: Alignment.centerRight,
      ),
    );
  }
}
