import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/models/photo.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/place_opening_hours.dart';
import 'package:gastrorate/models/place_opening_hours_period.dart';
import 'package:gastrorate/models/place_opening_hours_time.dart';
import 'package:gastrorate/models/place_review.dart';
import 'package:gastrorate/models/price_level.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/place_card.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:html/dom.dart';

class Places extends StatefulWidget {
  Places(
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
  State<StatefulWidget> createState() => _PlacesState();
}

class _PlacesState extends State<Places> {
  LatLng kInitialPosition = const LatLng(-103.8567844, 101.213108);
  Place? selectedPlace;

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
        title: const CustomText("Places", style: TextStyle(color: MyColors.navbarItemColor)),
        backgroundColor: MyColors.appbarColor,
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
                    initialPosition: kInitialPosition,
                    useCurrentLocation: true,
                    selectInitialPosition: true,
                    usePlaceDetailSearch: true,
                    zoomControlsEnabled: true,
                    onPlacePicked: (PickResult result) {
                      setState(() {
                        selectedPlace = mapToPlace(result);
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

  Place mapToPlace(PickResult result) {
    var document = Document.html(result.adrAddress ?? "");

    String address = document.querySelector('.street-address')?.text ?? '';
    String postalCode = document.querySelector('.postal-code')?.text ?? '';
    String city = document.querySelector('.locality')?.text ?? '';
    String country = document.querySelector('.country-name')?.text ?? '';
    return Place(
        address: address,
        city: city,
        postalCode: int.tryParse(postalCode),
        country: country,
        name: result.name,
        contactNumber: result.internationalPhoneNumber,
        googleRating: result.rating as int,
        url: result.url,
        webSiteUrl: result.website,
        photos: result.photos
            ?.map((photo) => Photo(
                  photoReference: photo.photoReference,
                  height: photo.height as int,
                  width: photo.width as int,
          htmlAttributions: photo.htmlAttributions
                ))
            .toList(),
        reviews: result.reviews
            ?.map((review) => PlaceReview(
                  text: review.text,
                  authorName: review.authorName,
                  authorUrl: review.authorUrl,
                  language: review.language,
                  profilePhotoUrl: review.profilePhotoUrl,
                  rating: review.rating as int,
                  relativeTimeDescription: review.relativeTimeDescription,
                  time: review.time as int,
                ))
            .toList(),
        openingHours: PlaceOpeningHours(
            openNow: result.openingHours?.openNow,
            weekdayText: result.openingHours?.weekdayText,
            periods: result.openingHours?.periods
                .map((e) => PlaceOpeningHoursPeriod(
                    open: PlaceOpeningHoursTime(time: e.open?.time, day: e.open?.day),
                    close: PlaceOpeningHoursTime(time: e.close?.time, day: e.close?.day)))
                .toList()),
        priceLevel: convertPriceLevelByName(result.priceLevel?.name));
  }

  PriceLevel convertPriceLevelByName(String? priceLevelName) {
    switch (priceLevelName?.toLowerCase()) {
      case 'free':
        return PriceLevel.FREE;
      case 'inexpensive':
        return PriceLevel.INEXPENSIVE;
      case 'moderate':
        return PriceLevel.MODERATE;
      case 'expensive':
        return PriceLevel.EXPENSIVE;
      case 'veryexpensive':
        return PriceLevel.VERY_EXPENSIVE;
      default:
        return PriceLevel.UNKNOWN;
    }
  }

}
