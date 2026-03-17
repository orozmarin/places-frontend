import 'package:flutter/material.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/place_search_form.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/tools/place_helper.dart';
import 'package:gastrorate/widgets/custom_app_bar.dart';
import 'package:gastrorate/widgets/place_card.dart';
import 'package:gastrorate/widgets/place_search_bar.dart';
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

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Place> get _displayedPlaces {
    if (_searchQuery.isEmpty) return _places;
    final q = _searchQuery.toLowerCase();
    return _places.where((p) =>
        (p.name?.toLowerCase().contains(q) ?? false) ||
        (p.city?.toLowerCase().contains(q) ?? false) ||
        (p.address?.toLowerCase().contains(q) ?? false)).toList();
  }

  @override
  void didUpdateWidget(covariant Favorites oldWidget) {
    if (widget.favoritePlaces != null) {
      _places = widget.favoritePlaces!;
      _places = PlaceHelper.sortPlaces(_places, _selectedSorting);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: const CustomText("Your Favorites", style: TextStyle(color: MyColors.navbarItemColor)),
        backgroundColor: MyColors.appbarColor,
        actions: [
          buildSortingButton(),
        ],
      ),
      body: Column(
        children: [
          PlaceSearchBar(
            controller: _searchController,
            query: _searchQuery,
            onChanged: (q) => setState(() => _searchQuery = q),
          ),
          Expanded(
            child: _displayedPlaces.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20, top: 10),
                    itemBuilder: (context, index) {
                      Place place = _displayedPlaces[index];
                      return PlaceCard(
                        place: place,
                        onDeletePlace: widget.onDeletePlace,
                        onInitPlaceForm: widget.onInitPlaceForm,
                      );
                    },
                    itemCount: _displayedPlaces.length,
                  )
                : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: buildEmptyState(),
                    ),
                  ),
          ),
        ],
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
