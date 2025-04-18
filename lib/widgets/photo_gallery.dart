import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/models/photo.dart';
import 'package:gastrorate/screens/dialogs/place_photo_swiper_dialog.dart';
import 'package:gastrorate/widgets/custom_text.dart';

class PhotoGallery extends StatefulWidget {
  final List<Photo> photos;

  const PhotoGallery({Key? key, required this.photos}) : super(key: key);

  @override
  _PhotoGalleryState createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  bool showAllPhotos = false;

  @override
  Widget build(BuildContext context) {
    final photosToShow = showAllPhotos ? widget.photos : widget.photos.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 1.0,
          ),
          itemCount: photosToShow.length,
          itemBuilder: (context, index) {
            final photo = photosToShow[index];
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PlacePhotoSwiperDialog(photos: widget.photos, initialIndex: index);
                  },
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 130,
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&photo_reference=${photo.photoReference}&key=${dotenv.env['MAPS_API']}",
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  if (!showAllPhotos && index == 2)
                    Container(
                      width: 130,
                      height: 100,
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CustomText(
                          "Show More",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
