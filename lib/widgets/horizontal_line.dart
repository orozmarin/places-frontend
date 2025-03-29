import 'package:flutter/material.dart';
import 'package:gastrorate/theme/my_colors.dart';

class HorizontalLine extends StatelessWidget {
  final Color color;
  final double height;

  const HorizontalLine({
    Key? key,
    this.color =  MyColors.horizontalDividerColor,
    this.height = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: color
    );
  }
}
