import 'package:flutter/material.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/screens/new_place.dart';
import 'package:gastrorate/screens/new_place_page.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/theme/my_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:page_transition/page_transition.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.places, required this.onFindAllPlaces, required this.onDeletePlace});

  final Function() onFindAllPlaces;
  final List<Place>? places;
  final Function(Place place) onDeletePlace;

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
                  Place place = widget.places![index];
                  return Card(
                    elevation: 3,
                    child: ListTile(
                      title: Text(
                        place.name ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        "${place.city}, ${place.country}",
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      trailing: IconButton.filledTonal(
                          onPressed: () {
                            widget.onDeletePlace(place);
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
                                  foundPlace: place,
                                )),
                          ),
                    ),
                  );
                },
                itemCount: widget.places!.length,
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
              GButton(icon: Icons.favorite_border, text: "Wishlist"),
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
                    foundPlace: Place(),
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
