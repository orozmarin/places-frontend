import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/price_level.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/tools/location_helper.dart';
import 'package:gastrorate/widgets/custom_app_bar.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:geolocator/geolocator.dart';

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

class _Suggestion {
  final String placeId;
  final String name;
  final String? secondary;
  _Suggestion({required this.placeId, required this.name, this.secondary});
}

class _PlaceSearchScreenState extends State<PlaceSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Place? _selectedPlace;
  bool _isLoading = false;
  String? _error;
  List<_Suggestion> _suggestions = [];
  Timer? _debounce;

  double? _currentLat;
  double? _currentLng;
  final Map<String, String?> _photoUrls = {};
  final Map<String, double?> _distances = {};

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
    LocationHelper().getCurrentLocation().then((position) {
      if (mounted) {
        setState(() {
          _currentLat = position.latitude;
          _currentLng = position.longitude;
        });
      }
    }).catchError((_) {});
  }

  void _onControllerChanged() => setState(() {});

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    _debounce?.cancel();
    if (value.length < 2) {
      setState(() => _suggestions = []);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () => _getSuggestions(value));
  }

  Future<void> _getSuggestions(String input) async {
    try {
      final apiKey = dotenv.env['MAPS_API']!;
      final body = <String, dynamic>{
        'input': input,
        'includedPrimaryTypes': ['restaurant'],
        'rankPreference': 'DISTANCE',
        if (_currentLat != null && _currentLng != null)
          'locationBias': {
            'circle': {
              'center': {'latitude': _currentLat, 'longitude': _currentLng},
              'radius': 50000.0,
            },
          },
      };
      final response = await Dio().post(
        'https://places.googleapis.com/v1/places:autocomplete',
        data: body,
        options: Options(headers: {'X-Goog-Api-Key': apiKey}),
      );
      final suggestions = ((response.data['suggestions'] as List?) ?? [])
          .where((s) => s['placePrediction'] != null)
          .map((s) {
            final p = s['placePrediction'] as Map<String, dynamic>;
            return _Suggestion(
              placeId: p['placeId'] as String,
              name: (p['structuredFormat']?['mainText']?['text'] ?? p['text']?['text'] ?? '') as String,
              secondary: p['structuredFormat']?['secondaryText']?['text'] as String?,
            );
          })
          .toList();
      if (!mounted) return;
      setState(() => _suggestions = suggestions);
      for (final s in suggestions) {
        _fetchSuggestionMeta(s.placeId);
      }
    } catch (_) {
      if (mounted) setState(() => _suggestions = []);
    }
  }

  Future<void> _fetchSuggestionMeta(String placeId) async {
    if (_photoUrls.containsKey(placeId)) return;
    try {
      final apiKey = dotenv.env['MAPS_API']!;
      final response = await Dio().get(
        'https://places.googleapis.com/v1/places/$placeId',
        options: Options(headers: {
          'X-Goog-Api-Key': apiKey,
          'X-Goog-FieldMask': 'photos,location',
        }),
      );
      final data = response.data as Map<String, dynamic>;

      String? photoUrl;
      final photos = data['photos'] as List?;
      if (photos != null && photos.isNotEmpty) {
        final photoName = photos[0]['name'] as String;
        photoUrl = 'https://places.googleapis.com/v1/$photoName/media?maxWidthPx=80&key=$apiKey';
      }

      double? distance;
      final location = data['location'] as Map<String, dynamic>?;
      if (location != null && _currentLat != null && _currentLng != null) {
        final distMeters = Geolocator.distanceBetween(
          _currentLat!,
          _currentLng!,
          (location['latitude'] as num).toDouble(),
          (location['longitude'] as num).toDouble(),
        );
        distance = distMeters;
      }

      if (mounted) {
        setState(() {
          _photoUrls[placeId] = photoUrl;
          _distances[placeId] = distance;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _photoUrls[placeId] = null);
    }
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
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                onChanged: _onTextChanged,
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Search restaurants...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade400, size: 22),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.cancel_rounded, color: Colors.grey.shade400, size: 20),
                          onPressed: () => setState(() {
                            _controller.clear();
                            _suggestions = [];
                            _selectedPlace = null;
                            _error = null;
                          }),
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          if (_suggestions.isNotEmpty) _buildSuggestionsList(),
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
          if (_selectedPlace != null && !_isLoading && _suggestions.isEmpty)
            _buildSelectionDetails(context, _selectedPlace!),
        ],
      ),
    );
  }

  Widget _buildSuggestionsList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 4),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _suggestions.length,
        separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade100),
        itemBuilder: (context, index) {
          final s = _suggestions[index];
          final photoUrl = _photoUrls[s.placeId];
          final distance = _distances[s.placeId];

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 44,
                height: 44,
                child: photoUrl != null
                    ? Image.network(photoUrl, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _photoPlaceholder())
                    : _photoPlaceholder(),
              ),
            ),
            title: Text(s.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (s.secondary != null)
                  Text(s.secondary!, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                if (distance != null)
                  Text(
                    _formatDistance(distance),
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.w500),
                  ),
              ],
            ),
            isThreeLine: s.secondary != null && distance != null,
            onTap: () {
              _controller.text = s.name;
              setState(() => _suggestions = []);
              _fetchPlaceDetails(s.placeId);
            },
          );
        },
      ),
    );
  }

  Widget _photoPlaceholder() {
    return Container(
      color: Colors.grey.shade100,
      child: Icon(Icons.restaurant, color: Colors.grey.shade300, size: 22),
    );
  }

  String _formatDistance(double meters) {
    if (meters < 1000) return '${meters.round()} m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  Widget _buildSelectionDetails(BuildContext context, Place place) {
    final openNow = place.openingHours?.openNow;
    final priceLevelText = _priceLevelText(place.priceLevel);

    double? distanceToPlace;
    if (_currentLat != null && _currentLng != null &&
        place.coordinates?.latitude != null && place.coordinates?.longitude != null) {
      distanceToPlace = Geolocator.distanceBetween(
        _currentLat!, _currentLng!,
        place.coordinates!.latitude!, place.coordinates!.longitude!,
      );
    }

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
                  if (distanceToPlace != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      _formatDistance(distanceToPlace),
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                    ),
                  ],
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
