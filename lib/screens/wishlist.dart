import 'package:flutter/material.dart';
import 'package:gastrorate/theme/my_colors.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<StatefulWidget> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wishlist", style: TextStyle(color: MyColors.navbarItemColor)),
        backgroundColor: MyColors.appbarColor,
      ),
      body: const Center(
        child: Text("Your wishlist"),
      ),
    );
  }
}
