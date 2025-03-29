import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:gastrorate/models/place_review.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/horizontal_spacer.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';

class ReviewSwiper extends StatelessWidget {
  final List<PlaceReview> reviews;
  final Function(PlaceReview) onTap;

  const ReviewSwiper({required this.reviews, Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Swiper(
        itemCount: reviews.length,
        viewportFraction: 0.85,
        scale: 0.9,
        loop: false,
        itemBuilder: (context, index) {
          return _buildReviewCard(reviews[index]);
        },
        pagination: const SwiperPagination(
          builder: SwiperPagination.dots,
        ),
      ),
    );
  }

  Widget _buildReviewCard(PlaceReview review) {
    return InkWell(
      onTap: () => onTap(review),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          review.authorName ?? 'Anonymous',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        CustomText(
                          review.relativeTimeDescription ?? '',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
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
                review.text ?? 'No review text available.',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
