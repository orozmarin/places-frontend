import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/default_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

import '../widgets/custom_text.dart';

class Wishlist extends StatefulWidget {
  final GoogleMapsFlutterPlatform mapsImplementation = GoogleMapsFlutterPlatform.instance;

  Wishlist({super.key});

  @override
  State<StatefulWidget> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  LatLng kInitialPosition = LatLng(-103.8567844, 101.213108);
  PickResult? selectedPlace;

  bool _mapsInitialized = false;

  void initRenderer() {
    if (_mapsInitialized) return;
    if (widget.mapsImplementation is GoogleMapsFlutterAndroid) {
      (widget.mapsImplementation as GoogleMapsFlutterAndroid).initializeWithRenderer(AndroidMapRenderer.latest);
    }
    _getCurrentLocation().then((value) => kInitialPosition = LatLng(value.latitude, value.longitude));
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
        title: const CustomText("Wishlist", style: TextStyle(color: MyColors.navbarItemColor)),
        backgroundColor: MyColors.appbarColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonComponent.smallButton(
                  text: "Load Place Picker",
                  onPressed: () {
                    initRenderer();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PlacePicker(
                            resizeToAvoidBottomInset: false,
                            apiKey: Platform.isAndroid
                                ? dotenv.env['MAPS_API'].toString()
                                : dotenv.env['MAPS_API'].toString(),
                            hintText: "Find a place ...",
                            searchingText: "Please wait ...",
                            selectText: "Select place",
                            initialPosition: kInitialPosition,
                            useCurrentLocation: true,
                            selectInitialPosition: true,
                            usePlaceDetailSearch: true,
                            zoomControlsEnabled: true,
                            onPlacePicked: (PickResult result) {
                              setState(() {
                                selectedPlace = result;
                                Navigator.of(context).pop();
                              });
                            },
                          );
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
