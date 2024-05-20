import 'package:flutter/material.dart';
import 'package:gastrorate/models/rating.dart';
import 'package:gastrorate/widgets/default_button.dart';
import 'package:gastrorate/widgets/dialog_wrapper.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';

class RestaurantRatingDialog extends StatefulWidget {
  final Rating rating;

  const RestaurantRatingDialog({Key? key, required this.rating}) : super(key: key);

  @override
  _RestaurantRatingDialogState createState() => _RestaurantRatingDialogState();
}

class _RestaurantRatingDialogState extends State<RestaurantRatingDialog> {
  @override
  Widget build(BuildContext context) {
    return DialogWrapperWidget(
      children: [
        Text("Experience rating: ${widget.rating.ambientRating}"),
        Slider(
          label: "${widget.rating.ambientRating}",
          divisions: 18,
          min: 1,
          max: 10,
          value: widget.rating.ambientRating!,
          onChanged: (value) {
            setState(() {
              widget.rating.ambientRating = value;
            });
          },
        ),
        Text("Food rating: ${widget.rating.foodRating}"),
        Slider(
          label: "${widget.rating.foodRating}",
          divisions: 18,
          min: 1,
          max: 10,
          value: widget.rating.foodRating!,
          onChanged: (value) {
            setState(() {
              widget.rating.foodRating = value;
            });
          },
        ),
        Text("Price rating: ${widget.rating.priceRating}"),
        Slider(
          label: "${widget.rating.priceRating}",
          divisions: 18,
          min: 1,
          max: 10,
          value: widget.rating.priceRating!,
          onChanged: (value) {
            setState(() {
              widget.rating.priceRating = value;
            });
          },
        ),
        const VerticalSpacer(24),
        ButtonComponent.smallButton(
          text: "Save",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
