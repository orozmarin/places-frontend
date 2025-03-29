import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/models/photo.dart';

class PlacePhotoSwiperDialog extends StatelessWidget {
  final List<Photo> photos;
  final int initialIndex;

  const PlacePhotoSwiperDialog({Key? key, required this.photos, required this.initialIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 500,
          color: Colors.white,
          child: Swiper(
            itemCount: photos.length,
            viewportFraction: 0.85,
            scale: 0.9,
            loop: false,
            itemBuilder: (context, index) {
              final photo = photos[index];
              final photoUrl =
                  "https://maps.googleapis.com/maps/api/place/photo?maxwidth=800&photo_reference=${photo.photoReference}&key=${dotenv.env['MAPS_API']}";
              return Image.network(photoUrl, fit: BoxFit.contain);
            },
            pagination: const SwiperPagination(
              builder: SwiperPagination.dots,
            ),
            control: const SwiperControl(),
            index: initialIndex,
          ),
        ),
      ),
    );
  }
}
