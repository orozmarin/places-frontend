import 'package:flutter/material.dart';

class CloseButtonWidget extends StatelessWidget {
  final VoidCallback onCloseButtonTap;

  const CloseButtonWidget({Key? key, required this.onCloseButtonTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onCloseButtonTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          color: Colors.white,
          child: const Icon(Icons.close, size: 28, color: Colors.black),
        ),
      ),
    );
  }
}
