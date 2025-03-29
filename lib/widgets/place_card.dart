import 'package:flutter/material.dart';
import 'package:gastrorate/models/from_where.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/theme/my_icons.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:go_router/go_router.dart';

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
        title: CustomText(
          place.name ?? "",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: CustomText(
          "${place.city}, ${place.country}",
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
        trailing: IconButton(
          onPressed: () {
            onDeletePlace(place);
          },
          color: MyColors.colorRed,
          icon: MyIcons.deleteIcon,
        ),
        onTap: () {
          onInitPlaceForm(place);
        },
      ),
    );
  }
}