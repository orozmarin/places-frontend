import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/default_button.dart';

class PlaceCard extends StatelessWidget {
  final Place place;
  final Function(Place) onDeletePlace;
  final Function(Place) onInitPlaceForm;

  const PlaceCard({
    Key? key,
    required this.place,
    required this.onDeletePlace,
    required this.onInitPlaceForm,
  }) : super(key: key);

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: MyColors.mainBackgroundColor,
        title: Text.rich(
          TextSpan(
            text: "Deleting ",
            style: Theme.of(context).textTheme.headlineSmall,
            children: [
              TextSpan(
                text: place.name,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              ),
              const TextSpan(text: " ?"),
            ],
          ),
        ),
        content: const CustomText("Are you sure you want to delete this Place?"),
        actions: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: ButtonComponent.outlinedButtonSmall(
                      onPressed: () => Navigator.of(context).pop(),
                      text: "Cancel",
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ButtonComponent.smallButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onDeletePlace(place);
                      },
                      text: "Delete",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onInitPlaceForm(place),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: place.photos?.first.photoReference != null && place.photos!.first.photoReference!.isNotEmpty
                  ? Image.network(
                      "https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&photo_reference=${place.photos?.first.photoReference}&key=${dotenv.env['MAPS_API']}",
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          height: 150,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 150,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                        ),
                      ),
                    )
                  : Container(
                      height: 150,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        place.name ?? "Unknown Place",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      if (place.placeRating != null)
                        CustomText(
                          "${place.placeRating! % 1 == 0 ? place.placeRating?.toInt() : place.placeRating?.toStringAsFixed(1)}/60",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                    "${place.city}, ${place.country}",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        "⭐ ${place.googleRating}",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () => _showDeleteConfirmationDialog(context),
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
