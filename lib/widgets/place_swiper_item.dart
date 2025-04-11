import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/horizontal_spacer.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';

class PlaceSwiperItem extends StatelessWidget {
  final Place place;
  final List<Place>? ratedPlaces;
  final Function(Place) onInitPlaceForm;

  const PlaceSwiperItem({
    Key? key,
    required this.place,
    required this.ratedPlaces,
    required this.onInitPlaceForm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Place selectedPlace = place;
        // check if place is rated already
        if (ratedPlaces != null && ratedPlaces!.isNotEmpty) {
          selectedPlace = ratedPlaces!.firstWhere(
            (place) => place.url == selectedPlace.url,
            orElse: () => selectedPlace,
          );
        }
        onInitPlaceForm(selectedPlace);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
          color: MyColors.mainBackgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: place.photos?.first.photoReference != null && place.photos!.first.photoReference!.isNotEmpty
                  ? Image.network(
                      "https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&photo_reference=${place.photos?.first.photoReference}&key=${dotenv.env['MAPS_API']}",
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          height: 180,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 180,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                        ),
                      ),
                    )
                  : Container(
                      height: 180,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    place.name ?? "N/A",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const VerticalSpacer(4),
                  CustomText(
                    "${place.city}, ${place.country}",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const VerticalSpacer(8),
                  Row(
                    children: [
                      CustomText(
                        "⭐ ${place.googleRating}",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      if (place.coordinates != null) ...<Widget>[
                        const HorizontalSpacer(20),
                        CustomText(
                          place.distance == null
                              ? "N/A"
                              : place.distance! < 1000
                                  ? "${(place.distance! ~/ 10 * 10)} m"
                                  : "${(place.distance! / 1000).toStringAsFixed(1)} km",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: MyColors.greyTextColor,
                          ),
                        ),
                      ]
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
