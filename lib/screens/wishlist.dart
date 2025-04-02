import 'package:flutter/material.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:lottie/lottie.dart';

import '../widgets/custom_text.dart';

class Wishlist extends StatefulWidget {
  Wishlist({super.key});

  @override
  State<StatefulWidget> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText("Wishlist", style: TextStyle(color: MyColors.navbarItemColor)),
        backgroundColor: MyColors.appbarColor,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Lottie.asset("assets/empty_state_wishlist.json"),
          CustomText(
            "Add Places to your Wishlist!",
            style: Theme.of(context).textTheme.titleMedium,
          )
        ],
      )),
    );
  }
}
