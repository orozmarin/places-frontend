import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/models/place.dart';
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
  final String? photoUrl;
  final double? distance;
  _Suggestion({
    required this.placeId,
    required this.name,
    this.secondary,
    this.photoUrl,
    this.distance,
  });
}

class _PlaceSearchScreenState extends State<PlaceSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoadingDetail = false;
  String? _error;
  List<_Suggestion> _suggestions = [];
  Timer? _debounce;

  double? _currentLat;
  double? _currentLng;
  int _searchGeneration = 0;
  bool _hasSearched = false;
  String? _nextPageToken;
  String? _lastQuery;
  bool _isLoadingMore = false;
  final ScrollController _listScrollController = ScrollController();
  List<_Suggestion> _recommendations = [];
  bool _isLoadingRecs = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
    _listScrollController.addListener(_onListScroll);
    LocationHelper().getCurrentLocation().then((position) {
      if (mounted) {
        setState(() {
          _currentLat = position.latitude;
          _currentLng = position.longitude;
        });
        _fetchRecommendations();
      }
    }).catchError((_) { _fetchRecommendations(); });
  }

  void _onControllerChanged() => setState(() {});

  void _onListScroll() {
    if (_listScrollController.position.pixels >=
        _listScrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _listScrollController.removeListener(_onListScroll);
    _listScrollController.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    _debounce?.cancel();
    if (value.length < 2) {
      setState(() {
        _suggestions = [];
        _hasSearched = false;
        _nextPageToken = null;
        _lastQuery = null;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () => _getSuggestions(value));
  }

  Future<void> _fetchRecommendations() async {
    if (!mounted) return;
    setState(() => _isLoadingRecs = true);
    final (results, _) = await _doSearch('highly rated restaurant');
    if (!mounted) return;
    setState(() {
      _recommendations = results;
      _isLoadingRecs = false;
    });
  }

  Future<void> _getSuggestions(String input) async {
    final generation = ++_searchGeneration;

    // Two parallel queries for better name coverage:
    // "restaurant X" (English) + "restoran X" (Croatian) — Text Search ranks
    // differently depending on whether place names use local vs English prefix.
    final ((resultsEn, tokenEn), (resultsCro, _)) = await (
      _doSearch('restaurant $input'),
      _doSearch('restoran $input'),
    ).wait;

    if (!mounted || generation != _searchGeneration) return;

    // Merge and deduplicate, then sort by distance (closest first)
    final seen = <String>{};
    final merged = <_Suggestion>[];
    for (final s in [...resultsEn, ...resultsCro]) {
      if (seen.add(s.placeId)) merged.add(s);
    }
    merged.sort((a, b) {
      if (a.distance == null && b.distance == null) return 0;
      if (a.distance == null) return 1;
      if (b.distance == null) return -1;
      return a.distance!.compareTo(b.distance!);
    });

    setState(() {
      _suggestions = merged;
      _hasSearched = true;
      _nextPageToken = tokenEn;
      _lastQuery = 'restaurant $input';
    });
  }

  Future<void> _loadMore() async {
    if (_nextPageToken == null || _lastQuery == null || _isLoadingMore) return;
    setState(() => _isLoadingMore = true);
    final (results, token) = await _doSearch(_lastQuery!, pageToken: _nextPageToken);
    if (!mounted) return;
    setState(() {
      _suggestions = [..._suggestions, ...results];
      _nextPageToken = token;
      _isLoadingMore = false;
    });
  }

  Future<(List<_Suggestion>, String?)> _doSearch(String query, {String? pageToken}) async {
    try {
      final apiKey = dotenv.env['MAPS_API']!;
      final body = <String, dynamic>{
        'textQuery': query,
        'includedType': 'restaurant',
        'pageSize': 20,
        if (pageToken != null) 'pageToken': pageToken,
        if (_currentLat != null && _currentLng != null)
          'locationBias': {
            'circle': {
              'center': {'latitude': _currentLat, 'longitude': _currentLng},
              'radius': 50000.0,
            },
          },
      };
      final response = await Dio().post(
        'https://places.googleapis.com/v1/places:searchText',
        data: body,
        options: Options(headers: {
          'X-Goog-Api-Key': apiKey,
          'X-Goog-FieldMask':
              'places.id,places.displayName,places.formattedAddress,places.photos,places.location,nextPageToken',
        }),
      );

      final places = (response.data['places'] as List?) ?? [];
      final nextToken = response.data['nextPageToken'] as String?;

      final suggestions = places.map((p) {
        final placeId = p['id'] as String;
        final name = p['displayName']?['text'] as String? ?? '';
        final secondary = p['formattedAddress'] as String?;

        String? photoUrl;
        final photos = p['photos'] as List?;
        if (photos != null && photos.isNotEmpty) {
          final photoName = photos[0]['name'] as String;
          photoUrl = 'https://places.googleapis.com/v1/$photoName/media?maxWidthPx=400&key=$apiKey';
        }

        double? distance;
        final location = p['location'] as Map<String, dynamic>?;
        if (location != null && _currentLat != null && _currentLng != null) {
          distance = Geolocator.distanceBetween(
            _currentLat!,
            _currentLng!,
            (location['latitude'] as num).toDouble(),
            (location['longitude'] as num).toDouble(),
          );
        }

        return _Suggestion(
          placeId: placeId,
          name: name,
          secondary: secondary,
          photoUrl: photoUrl,
          distance: distance,
        );
      }).toList();

      return (suggestions, nextToken);
    } catch (_) {
      return (<_Suggestion>[], null);
    }
  }

  Future<void> _navigateToPlace(String placeId) async {
    if (_isLoadingDetail) return;
    setState(() { _isLoadingDetail = true; _error = null; });
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
      if (!mounted) return;
      final place = Place.fromGoogleJson(response.data as Map<String, dynamic>);
      Place resolved = widget.existingPlaces?.firstWhere(
            (p) => p.url == place.url,
            orElse: () => place,
          ) ??
          place;
      setState(() => _isLoadingDetail = false);
      widget.onPlaceSelected(resolved);
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingDetail = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not load place details. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: const CustomText('Find a place', style: TextStyle(color: MyColors.navbarItemColor)),
        backgroundColor: MyColors.appbarColor,
      ),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Column(
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
                Expanded(child: _buildMainContent()),
              ],
            ),
            if (_isLoadingDetail)
              const Positioned.fill(
                child: ColoredBox(
                  color: Color(0x66000000),
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    final isSearching = _controller.text.isNotEmpty;

    if (!isSearching) {
      if (_isLoadingRecs) {
        return const Center(child: CircularProgressIndicator());
      }
      if (_recommendations.isNotEmpty) {
        return _buildRecommendations();
      }
      return const SizedBox.shrink();
    }

    if (_suggestions.isNotEmpty) return _buildSuggestionsList();
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(_error!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
        ),
      );
    }
    if (_hasSearched && _suggestions.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text('No results found', style: TextStyle(fontSize: 15, color: Colors.grey.shade500)),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildRecommendations() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: _recommendations.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 4),
            child: Row(
              children: [
                Icon(Icons.local_fire_department_rounded, size: 16, color: Colors.grey.shade500),
                const SizedBox(width: 5),
                Text(
                  'Recommended near you',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                ),
              ],
            ),
          );
        }
        final s = _recommendations[index - 1];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildSuggestionTile(s),
        );
      },
    );
  }

  Widget _buildSuggestionsList() {
    return ListView.builder(
      controller: _listScrollController,
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
      itemCount: _suggestions.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _suggestions.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: 24, height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        final s = _suggestions[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildSuggestionTile(s),
        );
      },
    );
  }

  Widget _buildSuggestionTile(_Suggestion s) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: InkWell(
        onTap: () => _navigateToPlace(s.placeId),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 66,
                  height: 66,
                  child: s.photoUrl != null
                      ? Image.network(s.photoUrl!, fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) => _thumbnail())
                      : _thumbnail(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.name,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: -0.1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (s.secondary != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        s.secondary!,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (s.distance != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _formatDistance(s.distance!),
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _thumbnail() {
    return Container(
      color: Colors.grey.shade100,
      child: Icon(Icons.restaurant, color: Colors.grey.shade300, size: 28),
    );
  }

  String _formatDistance(double meters) {
    if (meters < 1000) return '${meters.round()} m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

}
