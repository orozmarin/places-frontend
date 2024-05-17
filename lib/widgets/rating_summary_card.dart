import 'package:flutter/material.dart';
import 'package:gastrorate/models/rating.dart';
import 'package:gastrorate/widgets/horizontal_spacer.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';

class RatingSummaryCard extends StatefulWidget {
  RatingSummaryCard({super.key, required this.rating, required this.onEditRating});

  final Function() onEditRating;
  Rating rating;

  @override
  State<RatingSummaryCard> createState() => _RatingSummaryCardState();
}

class _RatingSummaryCardState extends State<RatingSummaryCard> {
  @override
  Widget build(BuildContext context) {
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
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                widget.onEditRating();
                setState(() {});
              },
            ),
            const Row(
              children: [
                Icon(Icons.people, color: Colors.blue),
                HorizontalSpacer(8),
                Text(
                  "Ambient rating:",
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
          ],
        ),
      ),
    );
  }
}
