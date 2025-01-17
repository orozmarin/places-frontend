import 'package:flutter/material.dart';
import 'package:gastrorate/models/from_where.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/screens/new_place.dart';
import 'package:gastrorate/screens/new_place_page.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/theme/my_icons.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/place_card.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

class Places extends StatefulWidget {
  const Places(
      {super.key,
      required this.places,
      required this.onFindAllPlaces,
      required this.onDeletePlace,
      required this.onInitPlaceForm});

  final Function() onFindAllPlaces;
  final List<Place>? places;
  final Function(Place place) onDeletePlace;
  final Function(Place place) onInitPlaceForm;

  @override
  State<StatefulWidget> createState() => _PlacesState();
}

class _PlacesState extends State<Places> {
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
            widget.onInitPlaceForm(Place());
          }),
    );
  }
}
