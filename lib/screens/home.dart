import 'package:flutter/material.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/screens/place_search_screen.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/custom_app_bar.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/horizontal_line.dart';
import 'package:gastrorate/widgets/place_card.dart';
import 'package:gastrorate/widgets/place_card_swiper.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';
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
      heroTag: 'home_fab',
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlaceSearchScreen(
              existingPlaces: widget.places,
              onPlaceSelected: widget.onInitPlaceForm,
            ),
          ),
        );
      },
      elevation: 6.0,
      focusElevation: 10.0,
      highlightElevation: 8.0,
      splashColor: Colors.white.withOpacity(0.3),
    );
  }

}
