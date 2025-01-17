import 'package:flutter/material.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/place_card.dart';

class Home extends StatefulWidget {
  const Home(
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
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
            widget.onInitPlaceForm(Place());
          }),
    );
  }
}
