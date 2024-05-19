import 'package:flutter/material.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/horizontal_spacer.dart';

class CustomToast extends StatelessWidget {
  final String message;
  final bool error;
  final VoidCallback onClose;

  CustomToast({required this.message, this.error = false, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24.0, 12.0, 12.0, 12.0),
        decoration: BoxDecoration(
          color: error ? MyColors.colorRed.withOpacity(0.9) : MyColors.colorGreen.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(child: Text(message, style: const TextStyle(color: Colors.white))),
            const HorizontalSpacer(8.0),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: onClose,
            ),
          ],
        ),
      ),
    );
  }
}
