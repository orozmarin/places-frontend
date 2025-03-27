import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/models/photo.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/place_review.dart';
import 'package:gastrorate/models/rating.dart';
import 'package:gastrorate/screens/dialogs/place_review_dialog.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/theme/theme_helper.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/default_button.dart';
import 'package:gastrorate/widgets/horizontal_spacer.dart';
import 'package:gastrorate/widgets/page_body_card.dart';
import 'package:gastrorate/widgets/photo_gallery.dart';
import 'package:gastrorate/widgets/place_rating_dialog.dart';
import 'package:gastrorate/widgets/rating_summary_card.dart';
import 'package:gastrorate/widgets/review_swiper.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

class NewPlace extends StatefulWidget {
  const NewPlace({super.key, required this.place, required this.onSavePlace});

  final Place? place;
  final Function(Place place) onSavePlace;

  @override
  State<StatefulWidget> createState() => _NewPlaceState();
}

class _NewPlaceState extends State<NewPlace> {
  final _formKey = GlobalKey<FormState>();
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
    LatLng initialPosition = LatLng(currentPlace.coordinates?.latitude ?? kInitialPosition.latitude,
        currentPlace.coordinates?.longitude ?? kInitialPosition.longitude);
    Photo photo = currentPlace.photos!.first;
    String photoUrl =
        "https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&photo_reference=${photo.photoReference}&key=${dotenv.env['MAPS_API'].toString()}";

    return Scaffold(
      appBar: AppBar(
        title: const CustomText("New place"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: PageBodyCard(
            child: Container(
              padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: CustomText(
                        currentPlace.name ?? "Unnamed Place",
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (currentPlace.address != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 12.0, left: 16),
                        child: CustomText(
                          currentPlace.address!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                      ),
                    ReviewSwiper(
                      reviews: currentPlace.reviews ?? <PlaceReview>[],
                      onTap: (PlaceReview review) => showReviewDialog(review),
                    ),
                    const VerticalSpacer(8),
                    PhotoGallery(photos: currentPlace.photos ?? []),
                    const VerticalSpacer(8),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: CustomText("Ratings", style: Theme.of(context).textTheme.headlineSmall),
                    ),
                    const VerticalSpacer(8),
                    Row(
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
                    ),
                  ],
                ),
              ),
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
            if (currentPlace.firstRating == null || currentPlace.secondRating == null) {
              //toastHelperWeb.showToastError(context, "Please add ratings of your place");
            } else if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              widget.onSavePlace(currentPlace);
              //toastHelperWeb.showToastSuccess(context, "Place saved!");
              Navigator.pop(context);
            }
          },
        ),
      ),
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
