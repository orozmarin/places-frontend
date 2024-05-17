import 'package:flutter/material.dart';
import 'package:gastrorate/theme/my_colors.dart';

class PageBodyCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const PageBodyCard({required this.child, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: MediaQuery.sizeOf(context).height),
      width: double.infinity,
      decoration: BoxDecoration(
          color: (backgroundColor != null) ? backgroundColor : MyColors.mainBackgroundColor,
          ),
      child: child,
    );
  }
}
