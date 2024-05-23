import 'package:flutter/material.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/screens/new_place.dart';
import 'package:gastrorate/screens/new_place_page.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/theme/my_icons.dart';
import 'package:page_transition/page_transition.dart';

class PlaceCard extends StatelessWidget {
  final Place place;
  final Function(Place) onDeletePlace;
  final Function(Place) onInitPlaceForm;

  const PlaceCard({
    Key? key,
    required this.place,
    required this.onDeletePlace,
    required this.onInitPlaceForm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
        title: Text(
          place.name ?? "",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          "${place.city}, ${place.country}",
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
        trailing: IconButton.filledTonal(
          onPressed: () {
            onDeletePlace(place);
          },
          color: MyColors.colorRed,
          icon: MyIcons.deleteIcon,
        ),
        onTap: () {
          onInitPlaceForm(place);
          Navigator.push(
            context,
            PageTransition<NewPlace>(
              curve: Curves.easeIn,
              type: PageTransitionType.rightToLeft,
              child: const NewPlacePage(),
            ),
          );
        },
      ),
    );
  }
}