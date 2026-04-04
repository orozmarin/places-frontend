import 'package:flutter/material.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/visit/place_visit.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/custom_app_bar.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/horizontal_line.dart';
import 'package:gastrorate/widgets/place_card.dart';
import 'package:gastrorate/widgets/place_card_swiper.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';
import 'package:lottie/lottie.dart';

class Home extends StatelessWidget {
  const Home({
    super.key,
    required this.places,
    required this.nearbyPlaces,
    required this.onFindAllPlaces,
    required this.onDeletePlace,
    required this.onInitPlaceForm,
    required this.isLoading,
    required this.onRefresh,
  });

  final Function() onFindAllPlaces;
  final List<Place>? places;
  final List<Place>? nearbyPlaces;
  final Function(Place place) onDeletePlace;
  final Function(Place place, PlaceVisit? visit) onInitPlaceForm;
  final bool isLoading;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const CustomText("Home", style: TextStyle(color: MyColors.navbarItemColor)),
        backgroundColor: MyColors.appbarColor,
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(left: 18, top: 8, bottom: 8),
            child: CustomText(
              "Places near you",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          isLoading
              ? const SizedBox(
                  height: 220,
                  child: Center(child: CircularProgressIndicator()),
                )
              : PlaceCardSwiper(
                  ratedPlaces: places,
                  places: nearbyPlaces!,
                  onDeletePlace: onDeletePlace,
                  onInitPlaceForm: onInitPlaceForm,
                ),
          const VerticalSpacer(10),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 22), child: HorizontalLine()),
          if (places != null && places!.isNotEmpty) ...[
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
                Place place = places![index];
                return PlaceCard(
                  place: place,
                  onInitPlaceForm: onInitPlaceForm,
                );
              },
              itemCount: places!.length,
            ),
          ],
          if (places == null || places!.isEmpty) ...[
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
      ),
    );
  }
}
