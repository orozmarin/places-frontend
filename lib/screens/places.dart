import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/place_search_form.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/theme/theme_helper.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/place_card.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

class Places extends StatefulWidget {
  Places(
      {super.key,
      required this.places,
      required this.onFindAllPlaces,
      required this.onDeletePlace,
      required this.onInitPlaceForm});

  final Function(PlaceSearchForm) onFindAllPlaces;
  final List<Place>? places;
  final Function(Place place) onDeletePlace;
  final Function(Place place) onInitPlaceForm;

  final GoogleMapsFlutterPlatform mapsImplementation = GoogleMapsFlutterPlatform.instance;

  @override
  State<StatefulWidget> createState() => _PlacesState();
}

class _PlacesState extends State<Places> {
  LatLng initialPosition = kInitialPosition;
  Place? selectedPlace;
  PlaceSorting _selectedSorting = PlaceSorting.DATE_ASC;

  bool _mapsInitialized = false;

  void initRenderer() {
    if (_mapsInitialized) return;
    if (widget.mapsImplementation is GoogleMapsFlutterAndroid) {
      (widget.mapsImplementation as GoogleMapsFlutterAndroid).initializeWithRenderer(AndroidMapRenderer.latest);
    }
    _getCurrentLocation().then((value) => initialPosition = LatLng(value.latitude, value.longitude));
    setState(() {
      _mapsInitialized = true;
      (widget.mapsImplementation as GoogleMapsFlutterAndroid).useAndroidViewSurface = true;
    });
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permission.');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText("Places", style: TextStyle(color: MyColors.navbarItemColor)),
        backgroundColor: MyColors.appbarColor,
        actions: [
          PopupMenuButton<PlaceSorting>(
            surfaceTintColor: MyColors.mainBackgroundColor,
            icon: const Icon(
              Icons.filter_list,
              color: Colors.white,
            ),
            onSelected: (PlaceSorting value) {
              _selectedSorting = value;
              widget.onFindAllPlaces(PlaceSearchForm(sortingMethod: value));
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
          ),
        ],
      ),
      body: Center(
        child: //
            Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  Place place = widget.places![index];
                  return PlaceCard(
                    place: place,
                    onDeletePlace: widget.onDeletePlace,
                    onInitPlaceForm: widget.onInitPlaceForm,
                  );
                },
                itemCount: widget.places!.length,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: IconButton(
          icon: const Icon(
            Icons.add_circle,
            color: MyColors.primaryDarkColor,
          ),
          iconSize: 50,
          onPressed: () {
            initRenderer();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return PlacePicker(
                    resizeToAvoidBottomInset: false,
                    apiKey: Platform.isAndroid ? dotenv.env['MAPS_API'].toString() : dotenv.env['MAPS_API'].toString(),
                    hintText: "Find a place ...",
                    searchingText: "Please wait ...",
                    selectText: "Select place",
                    initialPosition: initialPosition,
                    useCurrentLocation: true,
                    selectInitialPosition: true,
                    usePlaceDetailSearch: true,
                    zoomControlsEnabled: true,
                    onPlacePicked: (PickResult result) {
                      setState(() {
                        selectedPlace = Place.fromPickResult(result);
                        Navigator.of(context).pop();
                        widget.onInitPlaceForm(selectedPlace ?? Place());
                      });
                    },
                  );
                },
              ),
            );
          }),
    );
  }

  PopupMenuItem<PlaceSorting> _buildPopupMenuItem(String text, PlaceSorting value) {
    return PopupMenuItem<PlaceSorting>(
      value: value,
      child: Text(text, style: TextStyle(fontWeight: _selectedSorting == value ? FontWeight.bold : FontWeight.normal)),
    );
  }
}
