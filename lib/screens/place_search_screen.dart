import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/price_level.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/tools/location_helper.dart';
import 'package:gastrorate/widgets/custom_app_bar.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';

class PlaceSearchScreen extends StatefulWidget {
  const PlaceSearchScreen({
    super.key,
    required this.existingPlaces,
    required this.onPlaceSelected,
  });

  final List<Place>? existingPlaces;
  final Function(Place place) onPlaceSelected;

  @override
  State<PlaceSearchScreen> createState() => _PlaceSearchScreenState();
}

class _PlaceSearchScreenState extends State<PlaceSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Place? _selectedPlace;
  bool _isLoading = false;
  String? _error;
  LocationConfig? _locationBias;

  @override
  void initState() {
    super.initState();
    LocationHelper().getCurrentLocation().then((position) {
      if (mounted) {
        setState(() {
          _locationBias = LocationConfig.circle(
            circleCenter: Coordinates(latitude: position.latitude, longitude: position.longitude),
            circleRadiusInKilometers: 50.0,
          );
        });
      }
    }).catchError((_) {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchPlaceDetails(String placeId) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _selectedPlace = null;
    });
    try {
      final apiKey = dotenv.env['MAPS_API']!;
      final response = await Dio().get(
        'https://places.googleapis.com/v1/places/$placeId',
        options: Options(
          headers: {
            'X-Goog-Api-Key': apiKey,
            'X-Goog-FieldMask':
                'id,displayName,formattedAddress,addressComponents,location,googleMapsUri,internationalPhoneNumber,regularOpeningHours,photos,reviews,rating,priceLevel,websiteUri',
          },
        ),
      );
      final place = Place.fromGoogleJson(response.data as Map<String, dynamic>);
      setState(() {
        _selectedPlace = place;
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _isLoading = false;
        _error = 'Could not load place details. Please try again.';
      });
    }
  }

  void _onSelectPlace() {
    if (_selectedPlace == null) return;
    Place place = _selectedPlace!;
    place = widget.existingPlaces?.firstWhere(
          (p) => p.url == place.url,
          orElse: () => place,
        ) ??
        place;
    widget.onPlaceSelected(place);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const CustomText('Find a place', style: TextStyle(color: MyColors.navbarItemColor)),
        backgroundColor: MyColors.appbarColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: GooglePlacesAutoCompleteTextFormField(
              config: GoogleApiConfig(
                apiKey: dotenv.env['MAPS_API']!,
                debounceTime: 400,
                locationBias: _locationBias,
              ),
              textEditingController: _controller,
              decoration: InputDecoration(
                hintText: 'Search restaurants...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
              ),
              minInputLength: 2,
              onSuggestionClicked: (Prediction prediction) {
                _controller.text = prediction.description ?? '';
                if (prediction.placeId != null) {
                  _fetchPlaceDetails(prediction.placeId!);
                }
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          if (_selectedPlace != null && !_isLoading)
            _buildSelectionDetails(context, _selectedPlace!),
        ],
      ),
    );
  }

  Widget _buildSelectionDetails(BuildContext context, Place place) {
    final openNow = place.openingHours?.openNow;
    final priceLevelText = _priceLevelText(place.priceLevel);

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              place.name ?? '',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (place.googleRating != null) ...[
                  const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 18),
                  const SizedBox(width: 3),
                  Text(
                    place.googleRating!.toStringAsFixed(1),
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(width: 12),
                ],
                if (priceLevelText != null) ...[
                  Text(
                    priceLevelText,
                    style: TextStyle(color: Colors.green.shade700, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 12),
                ],
                if (openNow != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: openNow ? Colors.green.shade100 : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      openNow ? 'Open now' : 'Closed',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: openNow ? Colors.green.shade800 : Colors.red.shade800,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            if (place.address != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_on_outlined, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      place.address!,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _onSelectPlace,
                style: FilledButton.styleFrom(
                  backgroundColor: MyColors.primaryDarkColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'Select this place',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: MyColors.navbarItemColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _priceLevelText(PriceLevel? level) {
    switch (level) {
      case PriceLevel.INEXPENSIVE:
      case PriceLevel.PRICE_LEVEL_INEXPENSIVE:
        return '€';
      case PriceLevel.MODERATE:
      case PriceLevel.PRICE_LEVEL_MODERATE:
        return '€€';
      case PriceLevel.EXPENSIVE:
      case PriceLevel.PRICE_LEVEL_EXPENSIVE:
        return '€€€';
      case PriceLevel.VERY_EXPENSIVE:
      case PriceLevel.PRICE_LEVEL_VERY_EXPENSIVE:
        return '€€€€';
      default:
        return null;
    }
  }
}
