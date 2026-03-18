import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/theme/theme_helper.dart';
import 'package:gastrorate/tools/location_helper.dart';
import 'package:gastrorate/widgets/custom_app_bar.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/horizontal_line.dart';
import 'package:gastrorate/widgets/place_card.dart';
import 'package:gastrorate/widgets/place_card_swiper.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:lottie/lottie.dart';

class Home extends StatefulWidget {
  Home(
      {super.key,
      required this.places,
      required this.nearbyPlaces,
      required this.onFindAllPlaces,
      required this.onDeletePlace,
    required this.onInitPlaceForm,
    required this.isLoading,
  });

  final Function() onFindAllPlaces;
  final List<Place>? places;
  final List<Place>? nearbyPlaces;
  final Function(Place place) onDeletePlace;
  final Function(Place place) onInitPlaceForm;
  final bool isLoading;

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  LatLng initialPosition = kInitialPosition;
  Place? selectedPlace;

  final ScrollController _scrollController = ScrollController();
  bool _isVisible = true;
  double _previousScrollOffset = 0;

  // Detect scroll direction and show or hide the button
  void _onScroll() {
    if (widget.places == null || widget.places!.isEmpty) {
      setState(() {
        _isVisible = true;
      });
    } else if (_scrollController.offset > _previousScrollOffset && _isVisible) {
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

  @override
  void initState() {
    super.initState();
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
      appBar: CustomAppBar(
        title: const CustomText("Home", style: TextStyle(color: MyColors.navbarItemColor)),
        backgroundColor: MyColors.appbarColor,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(left: 18, top: 8, bottom: 8),
            child: CustomText(
              "Places near you",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
            widget.isLoading
                ? const SizedBox(
                    height: 220,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : PlaceCardSwiper(
                    ratedPlaces: widget.places,
                    places: widget.nearbyPlaces!,
                    onDeletePlace: widget.onDeletePlace,
                    onInitPlaceForm: widget.onInitPlaceForm,
                  ),
          const VerticalSpacer(10),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 22), child: HorizontalLine()),
          if (widget.places != null && widget.places!.isNotEmpty) ...[
            const VerticalSpacer(6),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: CustomText(
                "Recently added",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
          ],
          if (widget.places == null || widget.places!.isEmpty) ...[
            Lottie.asset("assets/empty_state_home.json", width: 500, height: 250),
            Align(
              alignment: Alignment.center,
              child: CustomText(
                "No rated Places found...",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ]),
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

  bool showAddPlaceButton() => _isVisible || (widget.places == null || widget.places!.length < 2);

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
        LocationHelper().getCurrentLocation().then((value) => initialPosition = LatLng(value.latitude, value.longitude));
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
                autocompleteRadius: 50000,
                autocompleteTypes: ['restaurant'],
                selectedPlaceWidgetBuilder: (context, data, state, isSearchBarFocused) =>
                    _defaultPlaceWidgetBuilder(context, data, state),
                onPlacePicked: (PickResult result) {
                  setState(() {
                    selectedPlace = Place.fromPickResult(result);
                    // check if place is rated already
                    selectedPlace = widget.places?.firstWhere(
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

  Widget _defaultPlaceWidgetBuilder(BuildContext context, PickResult? data, SearchingState state) {
    return FloatingCard(
      bottomPosition: 0,
      leftPosition: 0,
      rightPosition: 0,
      width: double.infinity,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      elevation: 10.0,
      color: Theme.of(context).cardColor,
      child: state == SearchingState.Searching ? _buildLoadingIndicator() : _buildSelectionDetails(context, data!),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: SizedBox(width: 28, height: 28, child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildSelectionDetails(BuildContext context, PickResult result) {
    selectedPlace = Place.fromPickResult(result);
    final rating = result.rating;
    final openNow = result.openingHours?.openNow;
    final priceLevelText = _priceLevelText(result.priceLevel?.index);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            selectedPlace?.name ?? "",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (rating != null) ...[
                const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 18),
                const SizedBox(width: 3),
                Text(rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(width: 12),
              ],
              if (priceLevelText != null) ...[
                Text(priceLevelText, style: TextStyle(color: Colors.green.shade700, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(width: 12),
              ],
              if (openNow != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: openNow ? Colors.green.shade100 : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    openNow ? "Open now" : "Closed",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: openNow ? Colors.green.shade800 : Colors.red.shade800,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_outlined, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  result.formattedAddress ?? "${selectedPlace?.address ?? ''}, ${selectedPlace?.city ?? ''}",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                setState(() {
                  selectedPlace = widget.places?.firstWhere(
                    (place) => place.url == selectedPlace?.url,
                    orElse: () => selectedPlace ?? Place(),
                  );
                  widget.onInitPlaceForm(selectedPlace ?? Place());
                  Navigator.of(context).pop();
                });
              },
              style: FilledButton.styleFrom(
                backgroundColor: MyColors.primaryDarkColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Select this place", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: MyColors.navbarItemColor)),
            ),
          ),
        ],
      ),
    );
  }

  String? _priceLevelText(int? index) {
    switch (index) {
      case 1: return '€';
      case 2: return '€€';
      case 3: return '€€€';
      case 4: return '€€€€';
      default: return null;
    }
  }
}
