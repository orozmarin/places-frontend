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
    required this.onAddPlace,
  });
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onAddPlace;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: FloatingActionButton.small(
                heroTag: 'nav_rail_add',
                backgroundColor: MyColors.primaryDarkColor,
                foregroundColor: MyColors.navbarItemColor,
                elevation: 0,
                shape: const CircleBorder(side: BorderSide(color: MyColors.navbarItemColor, width: 2)),
                onPressed: onAddPlace,
                child: const Icon(Icons.add),
              ),
            ),
            indicatorColor: MyColors.activeItemColor,
            backgroundColor: MyColors.backgroundNavBarColor,
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                label: CustomText('Home', style: TextStyle(color: MyColors.navbarItemColor),),
                icon: Icon(CupertinoIcons.home, color: MyColors.navbarItemColor,),
              ),
              NavigationRailDestination(
                label: CustomText('Places', style: TextStyle(color: MyColors.navbarItemColor),),
                icon: Icon(CupertinoIcons.map_pin_ellipse, color: MyColors.navbarItemColor,),
              ),
              NavigationRailDestination(
                label: CustomText('Favorites', style: TextStyle(color: MyColors.navbarItemColor),),
                icon: Icon(CupertinoIcons.heart_fill, color: MyColors.navbarItemColor,),
              ),
              NavigationRailDestination(
                label: CustomText('Settings', style: TextStyle(color: MyColors.navbarItemColor),),
                icon: Icon(CupertinoIcons.settings, color: MyColors.navbarItemColor,),
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