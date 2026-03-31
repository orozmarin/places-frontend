import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/custom_text.dart';

class ScaffoldWithNavigationRail extends StatelessWidget {
  const ScaffoldWithNavigationRail({
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
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            indicatorColor: MyColors.activeItemColor,
            backgroundColor: MyColors.backgroundNavBarColor,
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                label: CustomText('Home', style: TextStyle(color: MyColors.navbarItemColor)),
                icon: Icon(CupertinoIcons.house, color: MyColors.navbarItemColor),
                selectedIcon: Icon(CupertinoIcons.house_fill, color: MyColors.navbarItemColor),
              ),
              NavigationRailDestination(
                label: CustomText('Places', style: TextStyle(color: MyColors.navbarItemColor)),
                icon: Icon(CupertinoIcons.map, color: MyColors.navbarItemColor),
                selectedIcon: Icon(CupertinoIcons.map_fill, color: MyColors.navbarItemColor),
              ),
              NavigationRailDestination(
                label: CustomText('Add', style: TextStyle(color: MyColors.navbarItemColor)),
                icon: Icon(Icons.add_circle_outline_rounded, color: MyColors.navbarItemColor),
                selectedIcon: Icon(Icons.add_circle_rounded, color: MyColors.navbarItemColor),
              ),
              NavigationRailDestination(
                label: CustomText('Favorites', style: TextStyle(color: MyColors.navbarItemColor)),
                icon: Icon(CupertinoIcons.heart, color: MyColors.navbarItemColor),
                selectedIcon: Icon(CupertinoIcons.heart_fill, color: MyColors.navbarItemColor),
              ),
              NavigationRailDestination(
                label: CustomText('Settings', style: TextStyle(color: MyColors.navbarItemColor)),
                icon: Icon(Icons.settings_outlined, color: MyColors.navbarItemColor),
                selectedIcon: Icon(Icons.settings, color: MyColors.navbarItemColor),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: body,
          ),
        ],
      ),
    );
  }
}
