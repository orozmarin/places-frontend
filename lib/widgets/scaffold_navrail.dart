import 'package:flutter/material.dart';
import 'package:gastrorate/theme/my_colors.dart';

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
                label: Text('Home', style: TextStyle(color: MyColors.navbarItemColor),),
                icon: Icon(Icons.home, color: MyColors.navbarItemColor,),
              ),
              NavigationRailDestination(
                label: Text('Places', style: TextStyle(color: MyColors.navbarItemColor),),
                icon: Icon(Icons.restaurant_menu, color: MyColors.navbarItemColor,),
              ),
              NavigationRailDestination(
                label: Text('Wishlist', style: TextStyle(color: MyColors.navbarItemColor),),
                icon: Icon(Icons.favorite_border, color: MyColors.navbarItemColor,),
              ),
              NavigationRailDestination(
                label: Text('Settings', style: TextStyle(color: MyColors.navbarItemColor),),
                icon: Icon(Icons.settings, color: MyColors.navbarItemColor,),
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