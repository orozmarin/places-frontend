import 'package:flutter/cupertino.dart';
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
                  icon: CupertinoIcons.home,
                  textStyle: GoogleFonts.outfit(textStyle: const TextStyle(color: MyColors.navbarItemColor)),
                  text: "Home"),
              GButton(
                  icon: CupertinoIcons.map_pin_ellipse,
                  textStyle: GoogleFonts.outfit(textStyle: const TextStyle(color: MyColors.navbarItemColor)),
                  text: "Places"),
              GButton(
                  icon: CupertinoIcons.heart_fill,
                  textStyle: GoogleFonts.outfit(textStyle: const TextStyle(color: MyColors.navbarItemColor)),
                  text: "Favorites"),
              GButton(
                  icon: CupertinoIcons.settings,
                  textStyle: GoogleFonts.outfit(textStyle: const TextStyle(color: MyColors.navbarItemColor)),
                  text: "Settings"),
            ],
          ),
          ),
        ),
    );
  }
}
