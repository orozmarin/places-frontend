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

  Widget _icon(IconData inactive, IconData active, int tabIndex) {
    return Icon(
      selectedIndex == tabIndex ? active : inactive,
      color: MyColors.navbarItemColor,
      size: 24,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: body,
      bottomNavigationBar: Container(
        color: MyColors.backgroundNavBarColor,
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 15 + MediaQuery.of(context).padding.bottom),
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
                icon: CupertinoIcons.house,
                leading: _icon(CupertinoIcons.house, CupertinoIcons.house_fill, 0),
                textStyle: GoogleFonts.outfit(textStyle: const TextStyle(color: MyColors.navbarItemColor)),
                text: "Home",
              ),
              GButton(
                icon: CupertinoIcons.map,
                leading: _icon(CupertinoIcons.map, CupertinoIcons.map_fill, 1),
                textStyle: GoogleFonts.outfit(textStyle: const TextStyle(color: MyColors.navbarItemColor)),
                text: "Places",
              ),
              GButton(
                icon: Icons.add_circle_outline_rounded,
                leading: _icon(Icons.add_circle_outline_rounded, Icons.add_circle_rounded, 2),
                textStyle: GoogleFonts.outfit(textStyle: const TextStyle(color: MyColors.navbarItemColor)),
                text: "Add",
              ),
              GButton(
                icon: CupertinoIcons.heart,
                leading: _icon(CupertinoIcons.heart, CupertinoIcons.heart_fill, 3),
                textStyle: GoogleFonts.outfit(textStyle: const TextStyle(color: MyColors.navbarItemColor)),
                text: "Favorites",
              ),
              GButton(
                icon: Icons.settings_outlined,
                leading: _icon(Icons.settings_outlined, Icons.settings, 4),
                textStyle: GoogleFonts.outfit(textStyle: const TextStyle(color: MyColors.navbarItemColor)),
                text: "Settings",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
