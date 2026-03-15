import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/place_search_form.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/theme/theme_helper.dart';
import 'package:gastrorate/tools/place_helper.dart';
import 'package:gastrorate/widgets/custom_app_bar.dart';
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
      required this.sharedPlaces,
      required this.onFindAllPlaces,
      required this.onDeletePlace,
      required this.onInitPlaceForm,
      this.friends,
      this.onInviteCoVisitor});

  final Function(PlaceSearchForm) onFindAllPlaces;
  final List<Place>? places;
  final List<Place>? sharedPlaces;
  final Function(Place place) onDeletePlace;
  final Function(Place place) onInitPlaceForm;
  final List<User>? friends;
  final Function(String placeId, String friendId)? onInviteCoVisitor;

  final GoogleMapsFlutterPlatform mapsImplementation = GoogleMapsFlutterPlatform.instance;

  @override
  State<StatefulWidget> createState() => _PlacesState();
}

class _PlacesState extends State<Places> with SingleTickerProviderStateMixin {
  LatLng initialPosition = kInitialPosition;
  Place? selectedPlace;
  PlaceSorting _selectedSorting = PlaceSorting.DATE_DESC;
  List<Place> _places = <Place>[];

  bool _mapsInitialized = false;
  late TabController _tabController;
  int _currentTabIndex = 0;

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
      (widget.mapsImplementation as GoogleMapsFlutterAndroid).useAndroidViewSurface = false;
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
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() => _currentTabIndex = _tabController.index);
    });
    if (widget.places != null){
      _places = widget.places!;
      _places = PlaceHelper.sortPlaces(_places, _selectedSorting);
    }
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const CustomText("Places", style: TextStyle(color: MyColors.navbarItemColor)),
        backgroundColor: MyColors.appbarColor,
        actions: [
          if (_currentTabIndex == 0) buildSortingButton(),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: MyColors.navbarItemColor,
          unselectedLabelColor: MyColors.navbarItemColor.withOpacity(0.6),
          indicatorColor: MyColors.navbarItemColor,
          tabs: const [
            Tab(text: "My Places"),
            Tab(text: "Shared with Me"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMyPlacesTab(),
          _buildSharedPlacesTab(),
        ],
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

  Widget _buildMyPlacesTab() {
    return Center(
      child: _places.isNotEmpty
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
                        friends: widget.friends,
                        onInviteCoVisitor: widget.onInviteCoVisitor,
                      );
                    },
                    itemCount: _places.length,
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: buildEmptyState(),
            ),
    );
  }

  Widget _buildSharedPlacesTab() {
    final shared = widget.sharedPlaces;
    if (shared == null || shared.isEmpty) {
      return const Center(
        child: CustomText("No places shared with you yet."),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20, top: 10),
      itemCount: shared.length,
      itemBuilder: (context, index) {
        return PlaceCard(
          place: shared[index],
          onDeletePlace: widget.onDeletePlace,
          onInitPlaceForm: widget.onInitPlaceForm,
        );
      },
    );
  }

  bool showAddPlaceButton() => _currentTabIndex == 0 && (_isVisible || (_places.length < 3));

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
                selectedPlaceWidgetBuilder: (context, selectedPlace, state, isSearchBarFocused) =>
                    _defaultPlaceWidgetBuilder(context, selectedPlace, state),
                zoomControlsEnabled: true,
                autocompleteRadius: 50000,
                autocompleteTypes: ['restaurant'],
                onPlacePicked: (PickResult result) {
                  setState(() {
                    selectedPlace = Place.fromPickResult(result);
                    selectedPlace = _places.firstWhere(
                      (place) => place.url == selectedPlace?.url,
                      orElse: () => selectedPlace ?? Place(),
                    );
                    widget.onInitPlaceForm(selectedPlace ?? Place());
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
                  selectedPlace = _places.firstWhere(
                    (place) => place.url == selectedPlace?.url,
                    orElse: () => selectedPlace ?? Place(),
                  );
                  widget.onInitPlaceForm(selectedPlace ?? Place());
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
