import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/theme/theme_helper.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/place_card.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

class Home extends StatefulWidget {
  Home(
      {super.key,
      required this.places,
      required this.onFindAllPlaces,
      required this.onDeletePlace,
      required this.onInitPlaceForm});

  final Function() onFindAllPlaces;
  final List<Place>? places;
  final Function(Place place) onDeletePlace;
  final Function(Place place) onInitPlaceForm;

  final GoogleMapsFlutterPlatform mapsImplementation = GoogleMapsFlutterPlatform.instance;

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  LatLng initialPosition = kInitialPosition;
  Place? selectedPlace;

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
        title: const CustomText("Home", style: TextStyle(color: MyColors.navbarItemColor)),
        backgroundColor: MyColors.appbarColor,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(6),
              child: CustomText(
                "Recently added",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
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
}
