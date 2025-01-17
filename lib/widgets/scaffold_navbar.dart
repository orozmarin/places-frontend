import 'package:flutter/material.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
        bottomNavigationBar: Container(
          color: MyColors.backgroundNavBarColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: GNav(
              selectedIndex: selectedIndex,
              color: MyColors.navbarItemColor,
              activeColor: MyColors.navbarItemColor,
              tabBackgroundColor: MyColors.activeItemColor,
              padding: const EdgeInsets.all(10),
              gap: 8,
              onTabChange: onDestinationSelected,
            tabs: [
              GButton(
                  icon: Icons.home,
                  textStyle: GoogleFonts.outfit(textStyle: const TextStyle(color: MyColors.navbarItemColor)),
                  text: "Home"),
              GButton(
                  icon: Icons.restaurant_menu,
                  textStyle: GoogleFonts.outfit(textStyle: const TextStyle(color: MyColors.navbarItemColor)),
                  text: "Places"),
              GButton(
                  icon: Icons.favorite_border,
                  textStyle: GoogleFonts.outfit(textStyle: const TextStyle(color: MyColors.navbarItemColor)),
                  text: "Wishlist"),
              GButton(
                  icon: Icons.settings,
                  textStyle: GoogleFonts.outfit(textStyle: const TextStyle(color: MyColors.navbarItemColor)),
                  text: "Settings"),
            ],
          ),
          ),
        ),
    );
  }
}
