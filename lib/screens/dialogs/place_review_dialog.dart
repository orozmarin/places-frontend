import 'package:flutter/material.dart';
import 'package:gastrorate/models/place_review.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/horizontal_spacer.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';

class PlaceReviewDialog extends StatelessWidget {
  final PlaceReview review;

  const PlaceReviewDialog({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: MyColors.mainBackgroundColor,
      title: CustomText(review.authorName ?? 'Anonymous'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: review.profilePhotoUrl != null ? NetworkImage(review.profilePhotoUrl!) : null,
                  radius: 20,
                ),
                const HorizontalSpacer(10),
                Row(
                  children: List.generate(
                    review.rating ?? 0,
                    (index) => const Icon(Icons.star, color: Colors.amber, size: 16),
                  ),
                ),
              ],
            ),
            const VerticalSpacer(10),
            CustomText(
              review.relativeTimeDescription ?? 'No time description',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const VerticalSpacer(10),
            CustomText(review.text ?? 'No review text available.'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const CustomText('Close'),
        ),
      ],
    );
  }
}
