import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ColorModel extends Equatable {
  final String label;
  final Color color;

  const ColorModel({
    required this.label,
    required this.color,
  });

  @override
  List<Object?> get props => [
        label,
        color,
      ];

  // list color
  static List<ColorModel> colors = const [
    ColorModel(
      label: 'Blue',
      color: Color(0xFF4B69D8),
    ),
    ColorModel(
      label: 'Red',
      color: Color(0xFFD84B4B),
    ),
    ColorModel(
      label: 'Orange',
      color: Color(0xFFD89F4B),
    ),
    ColorModel(
      label: 'Green',
      color: Color(0xFF5ED84B),
    ),
    ColorModel(
      label: 'Light Blue',
      color: Color(0xFF4BA5D8),
    ),
    ColorModel(
      label: 'Pink',
      color: Color(0xFFD84B9F),
    ),
  ];
}
