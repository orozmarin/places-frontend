import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/place_search_form.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/theme/theme_helper.dart';
import 'package:gastrorate/tools/place_helper.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/place_card.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:lottie/lottie.dart';

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
  PlaceSorting _selectedSorting = PlaceSorting.DATE_DESC;
  List<Place> _places = <Place>[];

  bool _mapsInitialized = false;

  final ScrollController _scrollController = ScrollController();
  bool _isVisible = true;
  double _previousScrollOffset = 0;

  // Detect scroll direction and show or hide the button
  void _onScroll() {
    if (_scrollController.offset > _previousScrollOffset && _isVisible) {
      // Scrolling down, hide the button
      setState(() {
        _isVisible = false;
      });
    } else if (_scrollController.offset < _previousScrollOffset && !_isVisible) {
      // Scrolling up, show the button
      setState(() {
        _isVisible = true;
      });
    }
    _previousScrollOffset = _scrollController.offset;
  }

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
  void didUpdateWidget(covariant Places oldWidget) {
    if (widget.places != null){
      _places = widget.places!;
      _places = PlaceHelper.sortPlaces(_places, _selectedSorting);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    if (widget.places != null){
      _places = widget.places!;
      _places = PlaceHelper.sortPlaces(_places, _selectedSorting);
    }
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText("Places", style: TextStyle(color: MyColors.navbarItemColor)),
        backgroundColor: MyColors.appbarColor,
        actions: [
          buildSortingButton(),
        ],
      ),
      body: Center(
        child:
            _places.isNotEmpty
                ? Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 20, top: 10),
                          controller: _scrollController,
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
      floatingActionButton: showAddPlaceButton()
          ? AnimatedOpacity(
              opacity: 1.0, duration: const Duration(milliseconds: 300), child: buildAddPlaceButton(context))
          : const AnimatedOpacity(
              opacity: 0.0,
              duration: Duration(milliseconds: 200),
              child: SizedBox.shrink(),
            ),
    );
  }

  bool showAddPlaceButton() => _isVisible || (_places.length < 3);

  List<Widget> buildEmptyState() {
    return <Widget>[
      Lottie.asset("assets/empty_state_places.json"),
      CustomText(
        "Start rating Places!",
        style: Theme.of(context).textTheme.titleMedium,
      ),
    ];
  }

  FloatingActionButton buildAddPlaceButton(BuildContext context) {
    return FloatingActionButton.extended(
      icon: const Icon(Icons.add, color: MyColors.navbarItemColor),
      label: const CustomText(
        "Add Place",
        style: TextStyle(color: MyColors.navbarItemColor),
      ),
      backgroundColor: MyColors.primaryDarkColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: const BorderSide(
          color: Colors.black12,
          width: 1,
        ),
      ),
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
                    // check if place is rated already
                    selectedPlace = _places.firstWhere(
                      (place) => place.url == selectedPlace?.url,
                      orElse: () => selectedPlace ?? Place(),
                    );
                    widget.onInitPlaceForm(selectedPlace ?? Place());
                    Navigator.of(context).pop();
                  });
                },
              );
            },
          ),
        );
      },
      elevation: 6.0,
      focusElevation: 10.0,
      highlightElevation: 8.0,
      splashColor: Colors.white.withOpacity(0.3),
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
}
