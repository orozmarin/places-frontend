import 'package:flutter/material.dart';
import 'package:gastrorate/tools/utils_helper.dart';
import 'package:gastrorate/models/rating.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/dialog_wrapper.dart';

class PlaceRatingDialog extends StatefulWidget {
  final Rating rating;

  const PlaceRatingDialog({Key? key, required this.rating}) : super(key: key);

  @override
  _PlaceRatingDialogState createState() => _PlaceRatingDialogState();
}

class _PlaceRatingDialogState extends State<PlaceRatingDialog> {
  @override
  Widget build(BuildContext context) {
    return DialogWrapperWidget(
      children: [
        CustomText("Experience: ${UtilsHelper.formatRating(widget.rating.ambientRating)}"),
        Slider(
          label: UtilsHelper.formatRating(widget.rating.ambientRating),
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
        CustomText("Food: ${UtilsHelper.formatRating(widget.rating.foodRating)}"),
        Slider(
          label: UtilsHelper.formatRating(widget.rating.foodRating),
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
        CustomText("Price: ${UtilsHelper.formatRating(widget.rating.priceRating)}"),
        Slider(
          label: UtilsHelper.formatRating(widget.rating.priceRating),
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
      ],
    );
  }
}
