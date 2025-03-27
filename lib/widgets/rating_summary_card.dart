import 'package:flutter/material.dart';
import 'package:gastrorate/models/rating.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/theme/my_icons.dart';
import 'package:gastrorate/widgets/custom_text.dart';
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(
              "Overall: $placeRating/30",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const VerticalSpacer(8),
              const Text(
                "Experience rating:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("${widget.rating.ambientRating!}", style: TextStyle(color: Colors.grey[700])),
            const VerticalSpacer(8),
              const CustomText(
                "Food rating:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CustomText("${widget.rating.foodRating!}", style: TextStyle(color: Colors.grey[700])),
            const VerticalSpacer(8),
              const CustomText(
                "Price rating:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CustomText("${widget.rating.priceRating!}", style: TextStyle(color: Colors.grey[700])),
                IconButton(
                  icon: MyIcons.deleteIcon,
                  color: MyColors.colorRed,
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

  Divider buildVerticalDivider() {
    return const Divider(
      color: MyColors.primaryDarkColor,
      thickness: 1,
    );
  }
}
