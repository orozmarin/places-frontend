import 'package:flutter/material.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/place_search_form.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/tools/place_helper.dart';
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
  List<Place> _places = <Place>[];
  PlaceSorting _selectedSorting = PlaceSorting.DATE_DESC;

  @override
  void didUpdateWidget(covariant Favorites oldWidget) {
    if (widget.favoritePlaces != null) {
      _places = widget.favoritePlaces!;
      _places = PlaceHelper.sortPlaces(_places, _selectedSorting);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    if (widget.favoritePlaces != null) {
      _places = widget.favoritePlaces!;
      _places = PlaceHelper.sortPlaces(_places, _selectedSorting);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText("Your Favorites", style: TextStyle(color: MyColors.navbarItemColor)),
        backgroundColor: MyColors.appbarColor,
        actions: [
          buildSortingButton(),
        ],
      ),
      body: Center(
        child: //
            _places.isNotEmpty
                ? Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 20, top: 10),
                          itemBuilder: (context, index) {
                            Place place = _places[index];
                            return PlaceCard(
                              place: place,
                              onDeletePlace: widget.onDeletePlace,
                              onInitPlaceForm: widget.onInitPlaceForm,
                            );
                          },
                          itemCount: _places.length,
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

  PopupMenuButton<PlaceSorting> buildSortingButton() {
    return PopupMenuButton<PlaceSorting>(
      surfaceTintColor: MyColors.mainBackgroundColor,
      icon: const Icon(
        Icons.filter_list,
        color: Colors.white,
      ),
      onSelected: (PlaceSorting value) {
        _selectedSorting = value;
        _places = PlaceHelper.sortPlaces(_places, value);
        setState(() {});
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<PlaceSorting>>[
        _buildPopupMenuItem("Alphabetically (A-Z)", PlaceSorting.ALPHABETICALLY_ASC),
        _buildPopupMenuItem("Alphabetically (Z-A)", PlaceSorting.ALPHABETICALLY_DESC),
        _buildPopupMenuItem("Rating (Low to High)", PlaceSorting.RATING_ASC),
        _buildPopupMenuItem("Rating (High to Low)", PlaceSorting.RATING_DESC),
        _buildPopupMenuItem("Date (Oldest First)", PlaceSorting.DATE_ASC),
        _buildPopupMenuItem("Date (Newest First)", PlaceSorting.DATE_DESC),
      ],
    );
  }

  PopupMenuItem<PlaceSorting> _buildPopupMenuItem(String text, PlaceSorting value) {
    return PopupMenuItem<PlaceSorting>(
      value: value,
      child: Text(text, style: TextStyle(fontWeight: _selectedSorting == value ? FontWeight.bold : FontWeight.normal)),
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
