import 'package:flutter/material.dart';
import 'package:gastrorate/models/rating.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/theme/my_icons.dart';
import 'package:gastrorate/widgets/horizontal_spacer.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';

class RatingSummaryCard extends StatefulWidget {
  RatingSummaryCard({super.key, required this.rating, required this.onEditRating, required this.onDeleteRating});

  final Function() onEditRating;
  final Function() onDeleteRating;
  Rating rating;

  @override
  State<RatingSummaryCard> createState() => _RatingSummaryCardState();
}

class _RatingSummaryCardState extends State<RatingSummaryCard> {
  @override
  Widget build(BuildContext context) {
    double placeRating = widget.rating.ambientRating! + widget.rating.priceRating! + widget.rating.foodRating!;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Overall: $placeRating/30",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const VerticalSpacer(8),
            const Row(
              children: [
                Icon(Icons.people, color: Colors.blue),
                HorizontalSpacer(8),
                Text(
                  "Experience rating:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text("${widget.rating.ambientRating!}", style: TextStyle(color: Colors.grey[700])),
            const VerticalSpacer(8),
            const Row(
              children: [
                Icon(Icons.restaurant, color: Colors.green),
                HorizontalSpacer(8),
                Text(
                  "Food rating:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text("${widget.rating.foodRating!}", style: TextStyle(color: Colors.grey[700])),
            const VerticalSpacer(8),
            const Row(
              children: [
                Icon(Icons.attach_money, color: Colors.orange),
                HorizontalSpacer(8),
                Text(
                  "Price rating:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text("${widget.rating.priceRating!}", style: TextStyle(color: Colors.grey[700])),
            Row(
              children: [
                IconButton(
                  icon: MyIcons.editIcon,
                  color: MyColors.primaryDarkColor,
                  onPressed: () {
                    widget.onEditRating();
                    setState(() {});
                  },
                ),
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
          ],
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
