import 'package:flutter/material.dart';
import 'package:gastrorate/models/rating.dart';
import 'package:gastrorate/models/restaurant.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/default_button.dart';
import 'package:gastrorate/widgets/horizontal_spacer.dart';
import 'package:gastrorate/widgets/input_field.dart';
import 'package:gastrorate/widgets/page_body_card.dart';
import 'package:gastrorate/widgets/rating_summary_card.dart';
import 'package:gastrorate/widgets/restaurant_rating_dialog.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';

class NewPlace extends StatefulWidget {
  NewPlace({super.key, required this.restaurant, required this.onSavePlace});

  Restaurant restaurant;
  final Function(Restaurant restaurant) onSavePlace;

  @override
  State<StatefulWidget> createState() => _NewPlaceState();
}

class _NewPlaceState extends State<NewPlace> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text("New restaurant"),
        ),
        body: PageBodyCard(
          child: Container(
            padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputField(
                  labelText: "Name",
                  hintText: "Enter name",
                  initialValue:  widget.restaurant.name,
                  onChanged: (value) {
                    widget.restaurant.name = value;
                  },
                  isSmallInputField: true,
                ),
                const VerticalSpacer(8),
                InputField(
                  labelText: "Street and number",
                  hintText: "Enter address",
                  initialValue:  widget.restaurant.address,
                  onChanged: (value) {
                    widget.restaurant.address = value;
                  },
                  isSmallInputField: true,
                ),
                const VerticalSpacer(8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputField(
                      width: screenWidth * 0.5,
                      labelText: "City",
                      hintText: "Enter city",
                      initialValue:  widget.restaurant.city,
                      onChanged: (value) {
                        widget.restaurant.city = value;
                      },
                      isSmallInputField: true,
                    ),
                    const HorizontalSpacer(20),
                    InputField(
                      width: screenWidth * 0.3,
                      labelText: "Postal code",
                      hintText: "Enter postal code",
                      initialValue:  widget.restaurant.postalCode.toString(),
                      onChanged: (value) {
                        widget.restaurant.postalCode = int.parse(value ?? '');
                      },
                      isSmallInputField: true,
                    ),
                  ],
                ),
                const VerticalSpacer(8),
                InputField(
                  labelText: "Country",
                  hintText: "Country",
                  initialValue:  widget.restaurant.country,
                  onChanged: (value) {
                    widget.restaurant.country = value;
                  },
                  isSmallInputField: true,
                ),
                const VerticalSpacer(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text("1st Rating", style: Theme.of(context).textTheme.bodyLarge),
                        widget.restaurant.firstRating == null
                            ? IconButton(
                                icon: const Icon(
                                  size: 50,
                                  semanticLabel: "Add",
                                  Icons.add_circle,
                                  color: MyColors.primaryColor,
                                ),
                                onPressed: () {
                                  widget.restaurant.firstRating ??=
                                      Rating(ambientRating: 1, foodRating: 1, priceRating: 1);
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) => RestaurantRatingDialog(
                                      rating: widget.restaurant.firstRating!,
                                    ),
                                  );
                                  setState(() {});
                                },
                              )
                            : RatingSummaryCard(
                                rating: widget.restaurant.firstRating!,
                                onEditRating: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) => RestaurantRatingDialog(
                                      rating: widget.restaurant.firstRating!,
                                    ),
                                  );
                                  setState(() {});
                                },
                              )
                      ],
                    ),
                    const HorizontalSpacer(12),
                    Column(
                      children: [
                        Text("2nd Rating", style: Theme.of(context).textTheme.bodyLarge),
                        widget.restaurant.secondRating == null
                            ? IconButton(
                                icon: const Icon(
                                  size: 50,
                                  semanticLabel: "Add",
                                  Icons.add_circle,
                                  color: MyColors.primaryColor,
                                ),
                                onPressed: () {
                                  widget.restaurant.secondRating ??=
                                      Rating(ambientRating: 1, foodRating: 1, priceRating: 1);
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) => RestaurantRatingDialog(
                                      rating: widget.restaurant.secondRating!,
                                    ),
                                  );
                                  setState(() {});
                                },
                              )
                            : RatingSummaryCard(
                                rating: widget.restaurant.secondRating!,
                                onEditRating: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) => RestaurantRatingDialog(
                                      rating: widget.restaurant.secondRating!,
                                    ),
                                  );
                                  setState(() {});
                                },
                              ),
                      ],
                    ),
                  ],
                ),
                //TODO add photo upload
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(12),
          child: ButtonComponent(
            text: "Save",
            onPressed: () {
              widget.onSavePlace(widget.restaurant);
              Navigator.pop(context);
            }
          ),
        ));
  }
}
