import 'package:flutter/material.dart';
import 'package:gastrorate/models/restaurant.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/place_input_form.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:page_transition/page_transition.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.restaurants, required this.onFindAllRestaurants});

  final Function() onFindAllRestaurants;
  final List<Restaurant>? restaurants;

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
                        "${restaurant.address}, ${restaurant.city}, ${restaurant.country}",
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      onTap: () {
                        // Add any onTap functionality here
                      },
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
        onPressed: () => Navigator.push(
            context,
            PageTransition<PlaceInputForm>(
                curve: Curves.easeIn,
                type: PageTransitionType.rightToLeft,
                child: PlaceInputForm(restaurant: Restaurant(),)),
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
