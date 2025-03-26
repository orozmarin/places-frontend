import 'package:flutter/material.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/rating.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/default_button.dart';
import 'package:gastrorate/widgets/horizontal_spacer.dart';
import 'package:gastrorate/widgets/input_field.dart';
import 'package:gastrorate/widgets/page_body_card.dart';
import 'package:gastrorate/widgets/place_rating_dialog.dart';
import 'package:gastrorate/widgets/rating_summary_card.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';

class NewPlace extends StatefulWidget {
  const NewPlace({super.key, required this.place, required this.onSavePlace});

  final Place? place;
  final Function(Place place) onSavePlace;

  @override
  State<StatefulWidget> createState() => _NewPlaceState();
}

class _NewPlaceState extends State<NewPlace> {
  final _formKey = GlobalKey<FormState>();
  Place currentPlace = Place();

  @override
  void initState() {
    super.initState();
    if (widget.place != null){
      currentPlace = widget.place!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const CustomText("New place"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: PageBodyCard(
            child: Container(
              padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InputField(
                      labelText: "Name",
                      hintText: "Enter name",
                      validatorFunction: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                      initialValue: currentPlace.name,
                      onChanged: (value) {
                        currentPlace.name = value;
                      },
                      isSmallInputField: true,
                    ),
                    const VerticalSpacer(8),
                    InputField(
                      labelText: "Street and number",
                      hintText: "Enter address",
                      validatorFunction: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an address';
                        }
                        return null;
                      },
                      initialValue: currentPlace.address,
                      onChanged: (value) {
                        currentPlace.address = value;
                      },
                      isSmallInputField: true,
                    ),
                    const VerticalSpacer(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InputField(
                          width: screenWidth * 0.5,
                          labelText: "City",
                          hintText: "Enter city",
                          validatorFunction: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a city';
                            }
                            return null;
                          },
                          initialValue: currentPlace.city,
                          onChanged: (value) {
                            currentPlace.city = value;
                          },
                          isSmallInputField: true,
                        ),
                        const HorizontalSpacer(20),
                        InputField(
                          width: screenWidth * 0.3,
                          labelText: "Postal code",
                          hintText: "Enter postal code",
                          validatorFunction: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a postal code';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          initialValue: currentPlace.postalCode != null ? currentPlace.postalCode.toString() : '',
                          onChanged: (value) {
                            currentPlace.postalCode = int.parse(value ?? '');
                          },
                          isSmallInputField: true,
                        ),
                      ],
                    ),
                    const VerticalSpacer(8),
                    InputField(
                      labelText: "Country",
                      hintText: "Country",
                      initialValue: currentPlace.country,
                      validatorFunction: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a country';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        currentPlace.country = value;
                      },
                      isSmallInputField: true,
                    ),
                    const VerticalSpacer(8),
                    CustomText("Ratings", style: Theme.of(context).textTheme.headlineSmall),
                    const VerticalSpacer(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        currentPlace.firstRating == null
                            ? IconButton(
                                icon: const Icon(
                                  size: 50,
                                  semanticLabel: "Add",
                                  Icons.add_circle,
                                  color: MyColors.primaryColor,
                                ),
                                onPressed: () {
                                  currentPlace.firstRating ??= Rating(ambientRating: 1, foodRating: 1, priceRating: 1);
                                  showRatingDialog(currentPlace.firstRating!);
                                },
                              )
                            : RatingSummaryCard(
                                rating: currentPlace.firstRating!,
                                onEditRating: () {
                                  showRatingDialog(currentPlace.firstRating!);
                                },
                                onDeleteRating: () {
                                  currentPlace.firstRating = null;
                                  setState(() {});
                                },
                              ),
                        const HorizontalSpacer(8),
                        currentPlace.secondRating == null
                            ? IconButton(
                                icon: const Icon(
                                  size: 50,
                                  semanticLabel: "Add",
                                  Icons.add_circle,
                                  color: MyColors.primaryColor,
                                ),
                                onPressed: () {
                                  currentPlace.secondRating ??= Rating(ambientRating: 1, foodRating: 1, priceRating: 1);
                                  showRatingDialog(currentPlace.secondRating!);
                                },
                              )
                            : RatingSummaryCard(
                                rating: currentPlace.secondRating!,
                                onEditRating: () {
                                  showRatingDialog(currentPlace.secondRating!);
                                },
                                onDeleteRating: () {
                                  currentPlace.secondRating = null;
                                  setState(() {});
                                },
                              ),
                      ],
                    ),
                    //TODO add photo upload
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ButtonComponent(
          text: "Save",
          isDisabled: currentPlace.firstRating == null || currentPlace.secondRating == null,
          onPressed: () {
            if (currentPlace.firstRating == null || currentPlace.secondRating == null) {
              //toastHelperWeb.showToastError(context, "Please add ratings of your place");
            } else if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              widget.onSavePlace(currentPlace);
              //toastHelperWeb.showToastSuccess(context, "Place saved!");
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  void showRatingDialog(Rating rating) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const VerticalSpacer(18),
              PlaceRatingDialog(rating: rating),
              const VerticalSpacer(9),
              ButtonComponent(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {});
                },
                text: "Save",
              ),
              const VerticalSpacer(8),
            ],
          ),
        );
      },
    );
  }
}
