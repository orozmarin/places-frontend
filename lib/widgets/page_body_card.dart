import 'package:flutter/material.dart';
import 'package:gastrorate/theme/my_colors.dart';

class PageBodyCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const PageBodyCard({required this.child, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 0),
      constraints: BoxConstraints(minHeight: MediaQuery.sizeOf(context).height),
      width: double.infinity,
      decoration: BoxDecoration(
          color: (backgroundColor != null) ? backgroundColor : MyColors.mainBackgroundColor,
          ),
      child: child,
    );
  }
}
