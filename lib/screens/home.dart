import 'package:flutter/material.dart';
import 'package:gastrorate/models/restaurant.dart';
import 'package:gastrorate/screens/new_place.dart';
import 'package:gastrorate/screens/new_place_page.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/theme/my_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:page_transition/page_transition.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.restaurants, required this.onFindAllRestaurants, required this.onDeletePlace});

  final Function() onFindAllRestaurants;
  final List<Restaurant>? restaurants;
  final Function(Restaurant restaurant) onDeletePlace;

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: //
        Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  Restaurant restaurant = widget.restaurants![index];
                  return Card(
                    elevation: 3,
                    child: ListTile(
                      title: Text(
                        restaurant.name ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        "${restaurant.city}, ${restaurant.country}",
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      trailing: IconButton.filledTonal(
                          onPressed: () {
                            widget.onDeletePlace(restaurant);
                            setState(() {});
                          }, color: MyColors.colorRed,
                          icon: MyIcons.deleteIcon),
                      onTap: () =>
                          Navigator.push(
                            context,
                            PageTransition<NewPlace>(
                                curve: Curves.easeIn,
                                type: PageTransitionType.rightToLeft,
                                child: NewPlacePage(
                                  foundRestaurant: restaurant,
                                )),
                          ),
                    ),
                  );
                },
                itemCount: widget.restaurants!.length,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: MyColors.primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: GNav(
            selectedIndex: _selectedIndex,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: MyColors.onPrimaryColor,
            padding: const EdgeInsets.all(10),
            gap: 8,
            onTabChange: _navigateBottomBar,
            tabs: const [
              GButton(icon: Icons.home, text: "Home"),
              GButton(icon: Icons.favorite_border, text: "Favorites"),
              GButton(icon: Icons.restaurant_menu, text: "Places"),
              GButton(icon: Icons.settings, text: "Settings"),
            ],
          ),
        ),
      ),
      floatingActionButton: IconButton(
        icon: const Icon(
          Icons.add_circle,
          color: MyColors.primaryColor,
        ),
        iconSize: 50,
        onPressed: () =>
            Navigator.push(
              context,
              PageTransition<NewPlace>(
                  curve: Curves.easeIn,
                  type: PageTransitionType.rightToLeft,
                  child: NewPlacePage(
                    foundRestaurant: Restaurant(),
                  )),
            ),
      ),
    );
  }

  void _navigateBottomBar(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }
}
