import 'package:flutter/material.dart';

class HorizontalSpacer extends StatelessWidget {
  const HorizontalSpacer(this.width);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
    );
  }
}
