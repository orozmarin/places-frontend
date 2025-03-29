import 'package:flutter/material.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/place_review.dart';
import 'package:gastrorate/models/rating.dart';
import 'package:gastrorate/screens/dialogs/place_review_dialog.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/default_button.dart';
import 'package:gastrorate/widgets/horizontal_line.dart';
import 'package:gastrorate/widgets/horizontal_spacer.dart';
import 'package:gastrorate/widgets/page_body_card.dart';
import 'package:gastrorate/widgets/photo_gallery.dart';
import 'package:gastrorate/widgets/place_rating_dialog.dart';
import 'package:gastrorate/widgets/rating_summary_card.dart';
import 'package:gastrorate/widgets/review_swiper.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';
import 'package:url_launcher/url_launcher.dart';

class NewPlace extends StatefulWidget {
  const NewPlace({super.key, required this.place, required this.onSavePlace});

  final Place? place;
  final Function(Place place) onSavePlace;

  @override
  State<StatefulWidget> createState() => _NewPlaceState();
}

class _NewPlaceState extends State<NewPlace> {
  Place currentPlace = Place();

  @override
  void initState() {
    super.initState();
    if (widget.place != null) {
      currentPlace = widget.place!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          currentPlace.name ?? "Unnamed Place",
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: PageBodyCard(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAddress(context),
                buildPlaceInformation(context),
                if (currentPlace.openingHours != null) buildOpeningHours(context),
                if (currentPlace.reviews != null && currentPlace.reviews!.isNotEmpty)
                  ReviewSwiper(
                    reviews: currentPlace.reviews ?? <PlaceReview>[],
                    onTap: (PlaceReview review) => showReviewDialog(review),
                  ),
                const VerticalSpacer(8),
                const HorizontalLine(),
                const VerticalSpacer(8),
                if (currentPlace.photos != null && currentPlace.photos!.isNotEmpty)
                  PhotoGallery(photos: currentPlace.photos ?? []),
                const VerticalSpacer(8),
                Align(
                  alignment: Alignment.center,
                  child: CustomText("Ratings", style: Theme.of(context).textTheme.headlineSmall),
                ),
                const VerticalSpacer(8),
                buildRatings(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ButtonComponent(
          text: "Save",
          isDisabled: currentPlace.firstRating == null || currentPlace.secondRating == null,
          onPressed: () {
            widget.onSavePlace(currentPlace);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Row buildRatings() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildRatingCard(currentPlace.firstRating, () {
          setState(() {
            currentPlace.firstRating ??= Rating(ambientRating: 1, foodRating: 1, priceRating: 1);
            showRatingDialog(currentPlace.firstRating!);
          });
        }),
        const HorizontalSpacer(16),
        _buildRatingCard(currentPlace.secondRating, () {
          setState(() {
            currentPlace.secondRating ??= Rating(ambientRating: 1, foodRating: 1, priceRating: 1);
            showRatingDialog(currentPlace.secondRating!);
          });
        }),
      ],
    );
  }

  ExpansionTile buildOpeningHours(BuildContext context) {
    return ExpansionTile(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12), bottom: Radius.circular(12)),
      ),
      title: CustomText(
        "Opening Hours",
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: MyColors.primaryColor,
            ),
      ),
      children: currentPlace.openingHours!.weekdayText?.map((day) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
              child: CustomText(
                day,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.start,
              ),
            );
          }).toList() ??
          [],
    );
  }

  Padding buildPlaceInformation(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          if (currentPlace.contactNumber != null)
            Row(
              children: [
                const Icon(Icons.phone, size: 18, color: Colors.grey),
                const HorizontalSpacer(8),
                GestureDetector(
                  onTap: () async {
                    final String phoneNumber = currentPlace.contactNumber!.replaceAll(" ", "");
                    final Uri phoneUri = Uri(path: phoneNumber, scheme: "tel");

                    if (await canLaunchUrl(phoneUri)) {
                      await launchUrl(phoneUri);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Could not launch the dialer.')),
                      );
                    }
                  },
                  child: CustomText(
                    currentPlace.contactNumber!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          const HorizontalSpacer(16),
          Row(
            children: [
              CustomText(
                currentPlace.openingHours!.openNow == true ? "Open now" : "Closed",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const HorizontalSpacer(8),
              Icon(
                Icons.circle,
                color: currentPlace.openingHours!.openNow == true ? Colors.green : Colors.red,
                size: 12,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row buildAddress(BuildContext context) {
    return Row(
      children: [
        if (currentPlace.address != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0, left: 16),
            child: CustomText(
              "${currentPlace.address}, ${currentPlace.city}",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 20),
            ),
          ),
        if (currentPlace.url != null)
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () async {
              final Uri mapsUri = Uri.parse(currentPlace.url!);
              if (await canLaunchUrl(mapsUri)) {
                await launchUrl(mapsUri);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not open Google Maps.')),
                );
              }
            },
          ),
      ],
    );
  }

  Widget _buildRatingCard(Rating? rating, VoidCallback onAdd) {
    return rating == null
        ? InkWell(
            onTap: onAdd,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 120,
              height: 80,
              decoration: BoxDecoration(
                color: MyColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: MyColors.primaryColor, width: 2),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 30, color: MyColors.primaryColor),
                  VerticalSpacer(4),
                  CustomText("Add Rating", style: TextStyle(color: MyColors.primaryColor))
                ],
              ),
            ),
          )
        : RatingSummaryCard(
            rating: rating,
            onEditRating: () => showRatingDialog(rating),
            onDeleteRating: () {
              setState(() {
                if (rating == currentPlace.firstRating) {
                  currentPlace.firstRating = null;
                } else {
                  currentPlace.secondRating = null;
                }
              });
            },
          );
  }

  void showRatingDialog(Rating rating) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const VerticalSpacer(18),
              PlaceRatingDialog(rating: rating),
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
        );
      },
    );
  }

  void showReviewDialog(PlaceReview review) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PlaceReviewDialog(review: review);
      },
    );
  }
}
