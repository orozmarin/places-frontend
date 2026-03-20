import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:gastrorate/models/place_review.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/horizontal_spacer.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';

class ReviewSwiper extends StatefulWidget {
  final List<PlaceReview> reviews;
  final Function(PlaceReview) onTap;

  const ReviewSwiper({required this.reviews, super.key, required this.onTap});

  @override
  State<ReviewSwiper> createState() => _ReviewSwiperState();
}

class _ReviewSwiperState extends State<ReviewSwiper> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 160,
          child: Swiper(
            itemCount: widget.reviews.length,
            viewportFraction: 0.85,
            scale: 0.9,
            loop: false,
            onIndexChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (context, index) {
              return _buildReviewCard(widget.reviews[index]);
            },
          ),
        ),
        if (widget.reviews.length > 1) ...[
          const SizedBox(height: 8),
          _buildDots(),
        ],
      ],
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.reviews.length,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: i == _currentIndex ? 8 : 6,
          height: i == _currentIndex ? 8 : 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i == _currentIndex ? Colors.black87 : Colors.white,
            border: Border.all(
              color: i == _currentIndex ? Colors.black87 : Colors.grey.shade400,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(PlaceReview review) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: () => widget.onTap(review),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: review.profilePhotoUrl != null
                          ? NetworkImage(review.profilePhotoUrl!)
                          : null,
                      radius: 18,
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
                              fontSize: 14,
                            ),
                          ),
                          CustomText(
                            review.relativeTimeDescription ?? '',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: List.generate(
                        review.rating ?? 0,
                        (index) => const Icon(Icons.star, color: Colors.amber, size: 14),
                      ),
                    ),
                  ],
                ),
                const VerticalSpacer(8),
                CustomText(
                  review.text ?? 'No review text available.',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
