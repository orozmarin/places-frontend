import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/widgets/place_swiper_item.dart';

class PlaceCardSwiper extends StatelessWidget {
  final List<Place> places;
  final Function(Place) onDeletePlace;
  final Function(Place) onInitPlaceForm;

  const PlaceCardSwiper({
    required this.places,
    required this.onDeletePlace,
    required this.onInitPlaceForm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Swiper(
        itemCount: places.length,
        viewportFraction: 0.9,
        scale: 0.9,
        loop: true,
        itemBuilder: (context, index) {
          return PlaceSwiperItem(
            place: places[index],
            onInitPlaceForm: onInitPlaceForm,
          );
        },
        pagination: const SwiperPagination(
          builder: SwiperPagination.dots,
        ),
      ),
    );
  }
}
