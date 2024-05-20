import 'package:flutter/material.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/rating.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/tools/toast_helper_web.dart';
import 'package:gastrorate/widgets/default_button.dart';
import 'package:gastrorate/widgets/horizontal_spacer.dart';
import 'package:gastrorate/widgets/input_field.dart';
import 'package:gastrorate/widgets/page_body_card.dart';
import 'package:gastrorate/widgets/place_rating_dialog.dart';
import 'package:gastrorate/widgets/rating_summary_card.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';

class NewPlace extends StatefulWidget {
  NewPlace({super.key, required this.place, required this.onSavePlace});

  Place place;
  final Function(Place place) onSavePlace;

  @override
  State<StatefulWidget> createState() => _NewPlaceState();
}

class _NewPlaceState extends State<NewPlace> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("New place"),
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
                      initialValue: widget.place.name,
                      onChanged: (value) {
                        widget.place.name = value;
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
                      initialValue: widget.place.address,
                      onChanged: (value) {
                        widget.place.address = value;
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
                          initialValue: widget.place.city,
                          onChanged: (value) {
                            widget.place.city = value;
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
                          initialValue: widget.place.postalCode != null ? widget.place.postalCode.toString() : '',
                          onChanged: (value) {
                            widget.place.postalCode = int.parse(value ?? '');
                          },
                          isSmallInputField: true,
                        ),
                      ],
                    ),
                    const VerticalSpacer(8),
                    InputField(
                      labelText: "Country",
                      hintText: "Country",
                      initialValue: widget.place.country,
                      validatorFunction: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a country';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        widget.place.country = value;
                      },
                      isSmallInputField: true,
                    ),
                    const VerticalSpacer(8),
                    Text("Ratings", style: Theme.of(context).textTheme.headlineSmall),
                    const VerticalSpacer(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        widget.place.firstRating == null
                            ? IconButton(
                                icon: const Icon(
                                  size: 50,
                                  semanticLabel: "Add",
                                  Icons.add_circle,
                                  color: MyColors.primaryColor,
                                ),
                                onPressed: () {
                                  widget.place.firstRating ??= Rating(ambientRating: 1, foodRating: 1, priceRating: 1);
                                  showRatingDialog(widget.place.firstRating!);
                                },
                              )
                            : RatingSummaryCard(
                                rating: widget.place.firstRating!,
                                onEditRating: () {
                                  showRatingDialog(widget.place.firstRating!);
                                },
                                onDeleteRating: () {
                                  widget.place.firstRating = null;
                                  setState(() {});
                                },
                              ),
                        const HorizontalSpacer(8),
                        widget.place.secondRating == null
                            ? IconButton(
                                icon: const Icon(
                                  size: 50,
                                  semanticLabel: "Add",
                                  Icons.add_circle,
                                  color: MyColors.primaryColor,
                                ),
                                onPressed: () {
                                  widget.place.secondRating ??= Rating(ambientRating: 1, foodRating: 1, priceRating: 1);
                                  showRatingDialog(widget.place.secondRating!);
                                },
                              )
                            : RatingSummaryCard(
                                rating: widget.place.secondRating!,
                                onEditRating: () {
                                  showRatingDialog(widget.place.secondRating!);
                                },
                                onDeleteRating: () {
                                  widget.place.secondRating = null;
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
          onPressed: () {
            if (widget.place.firstRating == null || widget.place.secondRating == null)
              toastHelperWeb.showToastError(context, "Please add ratings of your place");
            else if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              widget.onSavePlace(widget.place);
              toastHelperWeb.showToastSuccess(context, "Place saved!");
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
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Ensures space for the keyboard
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const VerticalSpacer(18),
                PlaceRatingDialog(
                  rating: rating,
                ),
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
          ),
        );
      },
    );
  }
}
