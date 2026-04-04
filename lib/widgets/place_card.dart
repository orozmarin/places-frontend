import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gastrorate/models/co_visitor.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/visit/place_visit.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/tools/utils_helper.dart';
import 'package:gastrorate/widgets/horizontal_spacer.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';
import 'package:intl/intl.dart';

class PlaceCard extends StatefulWidget {
  final Place place;
  final Function(Place, PlaceVisit?) onInitPlaceForm;

  const PlaceCard({
    super.key,
    required this.place,
    required this.onInitPlaceForm,
  });

  @override
  State<PlaceCard> createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  bool _expanded = false;

  String _photoUrl(String ref, int maxWidth) {
    if (ref.startsWith('places/')) {
      return 'https://places.googleapis.com/v1/$ref/media?maxWidthPx=$maxWidth&key=${dotenv.env['MAPS_API']}';
    }
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=$maxWidth&photo_reference=$ref&key=${dotenv.env['MAPS_API']}';
  }

  String _locationText() {
    final p = widget.place;
    if (p.city != null && p.country != null) return '${p.city}, ${p.country}';
    if (p.address != null && p.address!.isNotEmpty) return p.address!;
    return '';
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    return DateFormat('d MMM yyyy').format(dt);
  }

  String _formatRating(double? v) {
    if (v == null) return '';
    return v % 1 == 0 ? '${v.toInt()}/30' : '${v.toStringAsFixed(1)}/30';
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final visits = widget.place.visits;
    if (visits == null || visits.length <= 1) {
      return _buildSingle(visits?.firstOrNull);
    }
    return _buildStacked(visits);
  }

  // ── Single-visit card ──────────────────────────────────────────────────────

  Widget _buildSingle(PlaceVisit? visit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: GestureDetector(
        onTap: () => widget.onInitPlaceForm(widget.place, visit),
        child: _shell(_rowContent(visit, isMulti: false)),
      ),
    );
  }

  // ── Multi-visit stacked card ───────────────────────────────────────────────

  Widget _buildStacked(List<PlaceVisit> visits) {
    final latest = visits.first;
    final hasThird = visits.length >= 3;
    final topInset = hasThird ? 20.0 : 12.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, topInset, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              if (hasThird)
                Positioned(
                  top: -16, left: 14, right: 14,
                  child: _backCard(Colors.grey.shade300, 14),
                ),
              Positioned(
                top: -8, left: 7, right: 7,
                child: _backCard(Colors.grey.shade200, 15),
              ),
              _shell(_rowContent(latest, isMulti: true)),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut,
            child: _expanded
                ? Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      children: visits.skip(1).map(_buildOlderRow).toList(),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // ── Card shell ─────────────────────────────────────────────────────────────

  Widget _shell(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 1, offset: Offset(0, 3)),
        ],
      ),
      child: child,
    );
  }

  Widget _backCard(Color color, double radius) {
    return Container(
      height: 28,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 3, offset: const Offset(0, 1)),
        ],
      ),
    );
  }

  // ── Compact horizontal row ─────────────────────────────────────────────────
  //
  // Layout split:
  //  • Photo + info area — tap = expand/collapse (multi) or nothing (single, outer handles)
  //  • Right column (rating + chevron) — tap = navigate to this visit
  //
  // Using spatially separated GestureDetectors avoids gesture arena conflicts.

  Widget _rowContent(PlaceVisit? visit, {required bool isMulti}) {
    final place = widget.place;
    final visitCount = place.visitCount ?? 1;
    final rating = (isMulti && place.averageRating != null)
        ? place.averageRating!.placeRating
        : (visit?.ownerRating?.placeRating ?? place.rating?.placeRating);
    final location = _locationText();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Photo ──
          GestureDetector(
            onTap: isMulti ? () => setState(() => _expanded = !_expanded) : null,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _photo(),
            ),
          ),
          const HorizontalSpacer(12),

          // ── Info (tap to expand for multi) ──
          Expanded(
            child: GestureDetector(
              onTap: isMulti ? () => setState(() => _expanded = !_expanded) : null,
              behavior: HitTestBehavior.translucent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    place.name ?? 'Unknown',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black87),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const VerticalSpacer(3),
                  if (isMulti && visitCount > 1)
                    _visitBadge(visitCount)
                  else if (visit?.visitedAt != null)
                    Text(
                      _formatDate(visit!.visitedAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  if (location.isNotEmpty) ...[
                    const VerticalSpacer(2),
                    Text(
                      location,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (visit?.coVisitors != null && visit!.coVisitors!.isNotEmpty) ...[
                    const VerticalSpacer(5),
                    _mainCardCoVisitors(visit.coVisitors!),
                  ],
                ],
              ),
            ),
          ),
          const HorizontalSpacer(8),

          // ── Right column: rating + chevron (always navigates) ──
          GestureDetector(
            onTap: () => widget.onInitPlaceForm(place, visit),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (rating != null)
                  Text(
                    _formatRating(rating),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                if (isMulti && place.averageRating != null)
                  Text(
                    'prosjek',
                    style: TextStyle(fontSize: 9, color: Colors.grey.shade400),
                  ),
                const VerticalSpacer(6),
                Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Photo widget ───────────────────────────────────────────────────────────

  Widget _photo() {
    final ref = widget.place.photos?.firstOrNull?.photoReference;
    if (ref != null && ref.isNotEmpty) {
      return Image.network(
        _photoUrl(ref, 200),
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) => _photoFallback(),
      );
    }
    return _photoFallback();
  }

  Widget _photoFallback() {
    return Container(
      width: 72,
      height: 72,
      color: Colors.grey.shade200,
      child: const Icon(Icons.restaurant, color: Colors.grey, size: 32),
    );
  }

  // ── Co-visitors on main card ───────────────────────────────────────────────

  Widget _mainCardCoVisitors(List<CoVisitor> coVisitors) {
    final first = coVisitors.first;
    final extra = coVisitors.length - 1;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _singleCoVisitorAvatar(first),
        if (extra > 0) ...[
          const HorizontalSpacer(4),
          CircleAvatar(
            radius: 12,
            backgroundColor: Colors.grey.shade300,
            child: Text(
              '+$extra',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black54),
            ),
          ),
        ],
      ],
    );
  }

  Widget _singleCoVisitorAvatar(CoVisitor cv) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: MyColors.avatarBackgroundColor,
      backgroundImage: cv.profileImageUrl != null ? NetworkImage(UtilsHelper.resolveImageUrl(cv.profileImageUrl!)) : null,
      child: cv.profileImageUrl == null
          ? Text(
              cv.firstName?.isNotEmpty == true ? cv.firstName![0].toUpperCase() : '?',
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
            )
          : null,
    );
  }

  // ── Older visit row (shown when expanded) ──────────────────────────────────

  Widget _buildOlderRow(PlaceVisit visit) {
    final rating = visit.ownerRating?.placeRating;
    final coVisitors = visit.coVisitors ?? [];

    return GestureDetector(
      onTap: () => widget.onInitPlaceForm(widget.place, visit),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            // Date
            const Icon(Icons.calendar_today_outlined, size: 13, color: Colors.grey),
            const HorizontalSpacer(5),
            Text(
              _formatDate(visit.visitedAt),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
            // Rating
            if (rating != null) ...[
              const HorizontalSpacer(10),
              Text(
                _formatRating(rating),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
            const Spacer(),
            // Co-visitor avatars
            if (coVisitors.isNotEmpty) _coVisitorAvatars(coVisitors),
            const HorizontalSpacer(6),
            Icon(Icons.chevron_right, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _coVisitorAvatars(List<CoVisitor> coVisitors) {
    final visible = coVisitors.take(3).toList();
    return SizedBox(
      width: visible.length * 18.0 + 8,
      height: 26,
      child: Stack(
        children: [
          for (int i = 0; i < visible.length; i++)
            Positioned(
              left: i * 18.0,
              child: CircleAvatar(
                radius: 13,
                backgroundColor: MyColors.avatarBackgroundColor,
                backgroundImage: visible[i].profileImageUrl != null
                    ? NetworkImage(UtilsHelper.resolveImageUrl(visible[i].profileImageUrl!))
                    : null,
                child: visible[i].profileImageUrl == null
                    ? Text(
                        visible[i].firstName?.isNotEmpty == true
                            ? visible[i].firstName![0].toUpperCase()
                            : '?',
                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
                      )
                    : null,
              ),
            ),
        ],
      ),
    );
  }

  // ── Visit count badge ──────────────────────────────────────────────────────

  Widget _visitBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.restaurant, size: 10, color: Colors.white),
          const HorizontalSpacer(4),
          Text(
            '$count posjeta',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
