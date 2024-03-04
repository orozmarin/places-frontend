import 'package:flutter/material.dart';

class VerticalSpacer extends StatelessWidget {
  const VerticalSpacer(this.height);

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
