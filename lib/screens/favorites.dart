import 'package:flutter/material.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/place_card.dart';
import 'package:lottie/lottie.dart';

import '../widgets/custom_text.dart';

class Favorites extends StatefulWidget {
  final List<Place>? favoritePlaces;
  final Function(Place place) onDeletePlace;
  final Function(Place place) onInitPlaceForm;

  Favorites({super.key, required this.favoritePlaces, required this.onDeletePlace, required this.onInitPlaceForm});

  @override
  State<StatefulWidget> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText("Your Favorites", style: TextStyle(color: MyColors.navbarItemColor)),
        backgroundColor: MyColors.appbarColor,
      ),
      body: Center(
        child: //
            widget.favoritePlaces != null && widget.favoritePlaces!.isNotEmpty
                ? Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 20, top: 10),
                          itemBuilder: (context, index) {
                            Place place = widget.favoritePlaces![index];
                            return PlaceCard(
                              place: place,
                              onDeletePlace: widget.onDeletePlace,
                              onInitPlaceForm: widget.onInitPlaceForm,
                            );
                          },
                          itemCount: widget.favoritePlaces!.length,
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: buildEmptyState(), // Pass context
                  ),
      ),
    );
  }

  List<Widget> buildEmptyState() {
    return <Widget>[
      Lottie.asset("assets/empty_state_wishlist.json"),
      CustomText(
        "No favorite Places yet!",
        style: Theme.of(context).textTheme.titleMedium,
      ),
    ];
  }
}
