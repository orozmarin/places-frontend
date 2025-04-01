import 'package:flutter/material.dart';
import 'package:gastrorate/models/rating.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/default_button.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';

class RatingSummaryCard extends StatefulWidget {
  const RatingSummaryCard({super.key, required this.rating, required this.onEditRating, required this.onDeleteRating});

  final Function() onEditRating;
  final Function() onDeleteRating;
  final Rating rating;

  @override
  State<RatingSummaryCard> createState() => _RatingSummaryCardState();
}

class _RatingSummaryCardState extends State<RatingSummaryCard> {
  @override
  Widget build(BuildContext context) {
    double placeRating = widget.rating.ambientRating! + widget.rating.priceRating! + widget.rating.foodRating!;
    return InkWell(
      onTap: () {
        widget.onEditRating();
        setState(() {});
      },
      child: Card(
        child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                "Overall: $placeRating/30",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            const VerticalSpacer(8),
              Row(
                children: [
                  const CustomText(
                    "Experience: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  CustomText(
                      "${widget.rating.ambientRating! % 1 == 0 ? widget.rating.ambientRating?.toInt() : widget.rating.ambientRating?.toStringAsFixed(1)}/10",
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              const VerticalSpacer(8),
              Row(
                children: [
                  const CustomText(
                    "Food: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  CustomText(
                      "${widget.rating.foodRating! % 1 == 0 ? widget.rating.foodRating?.toInt() : widget.rating.foodRating?.toStringAsFixed(1)}/10",
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              const VerticalSpacer(8),
              Row(
                children: [
                  const CustomText(
                    "Price: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  CustomText(
                      "${widget.rating.priceRating! % 1 == 0 ? widget.rating.priceRating?.toInt() : widget.rating.priceRating?.toStringAsFixed(1)}/10",
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              const VerticalSpacer(8),
              ButtonComponent.outlinedButtonSmall(
                text: "Reset",
                buttonColor: Colors.red,
                width: 80,
                onPressed: () {
                  widget.onDeleteRating();
                  setState(() {});
                },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
