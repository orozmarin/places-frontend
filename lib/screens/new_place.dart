import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/models/co_visitor.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/place_review.dart';
import 'package:gastrorate/models/price_level.dart';
import 'package:gastrorate/models/rating.dart';
import 'package:gastrorate/screens/dialogs/place_review_dialog.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/add_visitors_sheet.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/default_button.dart';
import 'package:gastrorate/widgets/photo_gallery.dart';
import 'package:gastrorate/widgets/place_rating_dialog.dart';
import 'package:gastrorate/widgets/rating_summary_card.dart';
import 'package:gastrorate/widgets/review_swiper.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:gastrorate/tools/utils_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class NewPlace extends StatefulWidget {
  const NewPlace({
    super.key,
    required this.place,
    required this.onSavePlace,
    required this.onDeletePlace,
    required this.onInviteVisitor,
    required this.friends,
    required this.loggedInUserId,
    required this.onRemoveCoVisitor,
  });

  final Place? place;
  final Function(Place place) onSavePlace;
  final Function(Place place) onDeletePlace;
  final Function(String placeId, String friendId) onInviteVisitor;
  final List<User>? friends;
  final String? loggedInUserId;
  final Function(String placeId, String coVisitorUserId) onRemoveCoVisitor;

  @override
  State<StatefulWidget> createState() => _NewPlaceState();
}

class _NewPlaceState extends State<NewPlace> {
  Place currentPlace = Place();
  final DateTime _earliestDate = DateTime.now().subtract(const Duration(days: 36500));
  DateTime? _latestDate;
  DateTime? _visitedAt;

  @override
  void initState() {
    super.initState();
    currentPlace = widget.place!;
    _visitedAt = currentPlace.visitedAt ?? DateTime.now();
    currentPlace.visitedAt = _visitedAt;
    final now = DateTime.now();
    _latestDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    currentPlace.isFavorite ??= false;
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          _buildSliverHero(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                _buildInfoStrip(),
                const SizedBox(height: 16),
                _buildRatingSection(),
                const SizedBox(height: 16),
                if (currentPlace.userId != null) ...[
                  _buildCoVisitorsSection(),
                  const SizedBox(height: 16),
                ],
                _buildVisitDateChip(),
                const SizedBox(height: 16),
                if (currentPlace.reviews != null && currentPlace.reviews!.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Google Reviews',
                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ReviewSwiper(
                    reviews: currentPlace.reviews ?? [],
                    onTap: (PlaceReview review) => showReviewDialog(review),
                  ),
                  const SizedBox(height: 16),
                ],
                if (currentPlace.photos != null && currentPlace.photos!.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Photos',
                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: PhotoGallery(photos: currentPlace.photos ?? []),
                  ),
                  const SizedBox(height: 16),
                ],
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(child: _buildBottomBar()),
    );
  }

  // ─── Hero ────────────────────────────────────────────────────────────────

  SliverAppBar _buildSliverHero() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: _buildAppBarIconButton(
        Icons.arrow_back_ios_new,
        () => Navigator.of(context).pop(),
      ),
      actions: [
        _buildAppBarIconButton(
          currentPlace.isFavorite ?? false
              ? CupertinoIcons.heart_fill
              : CupertinoIcons.heart,
          () => setState(() {
            currentPlace.isFavorite = !(currentPlace.isFavorite ?? false);
          }),
        ),
        if (currentPlace.url != null)
          _buildAppBarIconButton(Icons.location_on, _launchMaps),
        const SizedBox(width: 4),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: _buildHeroBackground(),
      ),
    );
  }

  Widget _buildHeroBackground() {
    final firstRef = currentPlace.photos?.isNotEmpty == true
        ? currentPlace.photos!.first.photoReference
        : null;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (firstRef != null)
          Image.network(
            _photoUrl(firstRef, 800),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) => _heroPlaceholder(),
          )
        else
          _heroPlaceholder(),
        // Bottom gradient scrim
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 160,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black87],
              ),
            ),
          ),
        ),
        // Place name + status pills
        Positioned(
          bottom: 24,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (_priceLevelText(currentPlace.priceLevel) != null) ...[
                    _buildHeroPill(_priceLevelText(currentPlace.priceLevel)!),
                    const SizedBox(width: 6),
                  ],
                  if (currentPlace.openingHours != null)
                    _buildHeroPill(
                      currentPlace.openingHours!.openNow == true ? 'Open' : 'Closed',
                      color: currentPlace.openingHours!.openNow == true
                          ? const Color(0xFF4CAF50)
                          : Colors.red,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                currentPlace.name ?? 'N/A',
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _heroPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildHeroPill(String text, {Color color = Colors.white54}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAppBarIconButton(IconData icon, VoidCallback? onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.45),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  String _photoUrl(String? ref, int maxWidth) {
    if (ref == null) return '';
    if (ref.startsWith('places/')) {
      return 'https://places.googleapis.com/v1/$ref/media?maxWidthPx=$maxWidth&key=${dotenv.env['MAPS_API']}';
    }
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=$maxWidth&photo_reference=$ref&key=${dotenv.env['MAPS_API']}';
  }

  String? _priceLevelText(PriceLevel? level) {
    switch (level) {
      case PriceLevel.FREE:
      case PriceLevel.PRICE_LEVEL_FREE:
        return 'Free';
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

  // ─── Info Strip ───────────────────────────────────────────────────────────

  Widget _buildInfoStrip() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          [
                            if (currentPlace.city != null) currentPlace.city!,
                            if (currentPlace.address != null) currentPlace.address!,
                          ].join(', '),
                          style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey[700]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (currentPlace.googleRating != null || currentPlace.distance != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (currentPlace.googleRating != null) ...[
                          const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFC107)),
                          const SizedBox(width: 2),
                          Text(
                            '${currentPlace.googleRating}',
                            style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[700]),
                          ),
                        ],
                        if (currentPlace.googleRating != null && currentPlace.distance != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text('·', style: TextStyle(color: Colors.grey[400])),
                          ),
                        if (currentPlace.distance != null)
                          Text(
                            '${(currentPlace.distance! / 1000).toStringAsFixed(1)} km',
                            style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[700]),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (currentPlace.contactNumber != null)
              GestureDetector(
                onTap: _launchPhone,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.phone, size: 20, color: Colors.black87),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ─── Rating Section ───────────────────────────────────────────────────────

  Widget _buildRatingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Rating',
            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          currentPlace.rating == null
              ? _buildAddRatingCard()
              : RatingSummaryCard(
                  rating: currentPlace.rating!,
                  onEditRating: () => showRatingDialog(currentPlace.rating!),
                  onDeleteRating: () {
                    setState(() {
                      currentPlace.rating = null;
                    });
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildAddRatingCard() {
    return InkWell(
      onTap: () {
        setState(() {
          currentPlace.rating ??= Rating(ambientRating: 1, foodRating: 1, priceRating: 1);
          showRatingDialog(currentPlace.rating!);
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_border_rounded, size: 32, color: Colors.black54),
              const SizedBox(height: 8),
              Text(
                '+ Rate this place',
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Co-visitors ──────────────────────────────────────────────────────────

  Widget _buildCoVisitorsSection() {
    final allCoVisitors = currentPlace.coVisitors ?? [];
    final filtered =
        allCoVisitors.where((cv) => cv.userId != widget.loggedInUserId).toList();
    final isOwner = currentPlace.userId == widget.loggedInUserId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Co-visitors${filtered.isNotEmpty ? ' (${filtered.length})' : ''}',
                style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              TextButton.icon(
                onPressed: _showAddVisitorsSheet,
                icon: const Icon(Icons.add, size: 16),
                label: Text('Invite', style: GoogleFonts.outfit(fontSize: 14)),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          if (filtered.isNotEmpty || isOwner) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 88,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  if (filtered.isEmpty) _buildDashedInviteCircle(),
                  ...filtered.map(_buildCoVisitorAvatar),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCoVisitorAvatar(CoVisitor cv) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () => _showCoVisitorSheet(context, cv),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundImage: cv.profileImageUrl != null
                  ? NetworkImage(cv.profileImageUrl!)
                  : null,
              backgroundColor: MyColors.avatarBackgroundColor,
              child: cv.profileImageUrl == null
                  ? Text(
                      _getCoVisitorInitials(cv),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    )
                  : null,
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 64,
              child: Text(
                cv.firstName ?? '',
                style: GoogleFonts.outfit(fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashedInviteCircle() {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: _showAddVisitorsSheet,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomPaint(
              size: const Size(64, 64),
              painter: _DashedCirclePainter(),
              child: const SizedBox(
                width: 64,
                height: 64,
                child: Center(child: Icon(Icons.add, size: 24, color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 64,
              child: Text(
                'Invite',
                style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Visit Date ───────────────────────────────────────────────────────────

  Widget _buildVisitDateChip() {
    final dateLabel = _visitedAt != null
        ? DateFormat('d MMM yyyy').format(_visitedAt!)
        : 'Set visit date';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => _openDatePicker(),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                'Visited: $dateLabel',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: _visitedAt != null ? Colors.black87 : Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openDatePicker() async {
    DateTime temp = _visitedAt ?? DateTime.now();
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext popupContext) => Material(
        type: MaterialType.transparency,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: MediaQuery.of(popupContext).size.width * 0.8,
              color: CupertinoColors.systemBackground.resolveFrom(popupContext),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: MyColors.mainBackgroundColor,
                    child: const Text(
                      'Select date',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 180,
                    child: CupertinoDatePicker(
                      minimumDate: _earliestDate,
                      maximumDate: _latestDate,
                      initialDateTime: _visitedAt ?? DateTime.now(),
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (DateTime newDate) => temp = newDate,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.primaryColor),
                      onPressed: () {
                        Navigator.of(popupContext).pop();
                        _onDateChanged(temp);
                      },
                      child: const Text('Select',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Bottom Bar ───────────────────────────────────────────────────────────

  Widget _buildBottomBar() {
    final isOwner = widget.loggedInUserId != null && currentPlace.userId == widget.loggedInUserId;
    final isCoVisitor = widget.loggedInUserId != null && currentPlace.userId != widget.loggedInUserId;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          if (currentPlace.rating != null && isOwner) ...[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                minimumSize: const Size(56, 52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _showDeleteConfirmationDialog(context),
              child: const Icon(CupertinoIcons.delete_simple),
            ),
            const SizedBox(width: 12),
          ],
          if (currentPlace.rating != null && isCoVisitor) ...[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.amber.shade700,
                side: BorderSide(color: Colors.amber.shade700),
                minimumSize: const Size(56, 52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _showLeaveConfirmationSheet(context),
              child: const Icon(Icons.exit_to_app),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade600,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: currentPlace.rating == null
                    ? null
                    : () {
                        widget.onSavePlace(currentPlace);
                        Navigator.pop(context);
                      },
                child: Text(
                  'Save',
                  style: GoogleFonts.outfit(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Dialogs (unchanged logic) ────────────────────────────────────────────

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
                text: widget.place!.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
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
                        widget.onDeletePlace(widget.place!);
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

  void _showLeaveConfirmationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              "Leave ${currentPlace.name ?? 'this place'}?",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Your rating and visit will be removed. The place stays saved for the host and other visitors.",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.exit_to_app, size: 18),
                    label: const Text("Leave", style: TextStyle(fontWeight: FontWeight.w600)),
                    onPressed: () {
                      Navigator.of(sheetContext).pop();
                      Navigator.of(context).pop();
                      widget.onRemoveCoVisitor(currentPlace.id!, widget.loggedInUserId!);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddVisitorsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddVisitorsSheet(
          place: currentPlace,
          friends: widget.friends ?? [],
          onInvite: widget.onInviteVisitor,
        );
      },
    );
  }

  void _showCoVisitorSheet(BuildContext context, CoVisitor coVisitor) {
    final isOwner = currentPlace.userId == widget.loggedInUserId;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: coVisitor.profileImageUrl != null
                  ? NetworkImage(coVisitor.profileImageUrl!)
                  : null,
              child: coVisitor.profileImageUrl == null
                  ? Text(
                      _getCoVisitorInitials(coVisitor),
                      style: const TextStyle(fontSize: 22),
                    )
                  : null,
            ),
            const VerticalSpacer(12),
            CustomText(
              '${coVisitor.firstName ?? ''} ${coVisitor.lastName ?? ''}'.trim(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (coVisitor.rating != null) ...[
              const VerticalSpacer(8),
              Text(
                '${UtilsHelper.formatRating(coVisitor.rating!.placeRating)}/30',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                'Experience: ${UtilsHelper.formatRating(coVisitor.rating!.ambientRating)}/10 · Food: ${UtilsHelper.formatRating(coVisitor.rating!.foodRating)}/10 · Price: ${UtilsHelper.formatRating(coVisitor.rating!.priceRating)}/10',
                style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
            const VerticalSpacer(24),
            if (isOwner)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onRemoveCoVisitor(currentPlace.id!, coVisitor.userId!);
                  },
                  child: const Text("Remove co-visitor"),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  String _getCoVisitorInitials(CoVisitor cv) {
    final first = (cv.firstName?.isNotEmpty == true) ? cv.firstName![0] : '';
    final last = (cv.lastName?.isNotEmpty == true) ? cv.lastName![0] : '';
    return '$first$last'.toUpperCase();
  }

  void _onDateChanged(DateTime newDate) {
    _visitedAt = newDate;
    currentPlace.visitedAt = _visitedAt;
    setState(() {});
  }

  Future<void> _launchPhone() async {
    final phoneNumber = currentPlace.contactNumber;
    if (phoneNumber == null) return;
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber.replaceAll(' ', ''));
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch the dialer.')),
      );
    }
  }

  Future<void> _launchMaps() async {
    if (currentPlace.url == null) return;
    final Uri mapsUri = Uri.parse(currentPlace.url!);
    if (await canLaunchUrl(mapsUri)) {
      await launchUrl(mapsUri);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Google Maps.')),
      );
    }
  }
}

// ─── Painters ─────────────────────────────────────────────────────────────────

class _DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    const dashCount = 12;
    const sweepPerDash = (2 * pi) / dashCount;
    const dashSweep = sweepPerDash * 0.6;
    for (int i = 0; i < dashCount; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * sweepPerDash,
        dashSweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DashedCirclePainter old) => false;
}
