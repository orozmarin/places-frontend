import 'package:flutter/material.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/tools/utils_helper.dart';
import 'package:gastrorate/models/co_visitor.dart';
import 'package:gastrorate/models/rating.dart';
import 'package:gastrorate/models/visit/consumed_item.dart';
import 'package:gastrorate/models/visit/place_visit.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/horizontal_spacer.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class VisitCard extends StatefulWidget {
  const VisitCard({
    super.key,
    required this.visit,
    required this.isOwner,
    required this.friends,
    this.onEdit,
    this.onDelete,
    this.onInvite,
    this.placeVisitId,
  });

  final PlaceVisit visit;
  final bool isOwner;
  final List<User> friends;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Function(String friendId)? onInvite;
  final String? placeVisitId;

  @override
  State<VisitCard> createState() => _VisitCardState();
}

class _VisitCardState extends State<VisitCard> {
  bool _expanded = false;

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    return DateFormat('d MMM yyyy').format(dt);
  }

  String _categoryLabel(String? category) {
    switch (category) {
      case 'FOOD': return 'Hrana';
      case 'DRINK': return 'Pice';
      case 'DESSERT': return 'Desert';
      case 'OTHER': return 'Ostalo';
      default: return category ?? '';
    }
  }

  void _showInviteSheet() {
    final existingIds = {
      ...?widget.visit.coVisitors?.map((cv) => cv.userId).whereType<String>(),
      if (widget.visit.userId != null) widget.visit.userId!,
    };
    final available = widget.friends.where((f) => !existingIds.contains(f.id)).toList();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          top: 16,
          bottom: 16 + MediaQuery.of(ctx).padding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              'Pozovi na ovaj posjet',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const VerticalSpacer(8),
            if (available.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: CustomText('Nema prijatelja za pozvati.'),
              )
            else
              ...available.map((friend) => ListTile(
                    leading: CircleAvatar(
                      backgroundImage: friend.profileImageUrl != null
                          ? NetworkImage(UtilsHelper.resolveImageUrl(friend.profileImageUrl!))
                          : null,
                      child: friend.profileImageUrl == null
                          ? Text(friend.getUserInitials())
                          : null,
                    ),
                    title: CustomText(friend.getFullName()),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      widget.onInvite?.call(friend.id!);
                    },
                  )),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        surfaceTintColor: MyColors.mainBackgroundColor,
        title: const Text('Obrisi posjet?'),
        content: const CustomText('Ovaj posjet ce biti trajno obrisan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Odustani'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.onDelete?.call();
            },
            child: const Text('Obrisi', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visit = widget.visit;
    final rating = visit.ownerRating;
    final coVisitors = visit.coVisitors ?? [];
    final consumedItems = visit.consumedItems ?? [];

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatDate(visit.visitedAt),
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (rating != null) ...[
                          const VerticalSpacer(4),
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              _ratingChip('Amb', rating.ambientRating),
                              _ratingChip('Hra', rating.foodRating),
                              _ratingChip('Cij', rating.priceRating),
                              Text(
                                '${_sum(rating)}/30',
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Co-visitor avatars
                  if (coVisitors.isNotEmpty)
                    SizedBox(
                      width: 48.0,
                      height: 28,
                      child: Stack(
                        children: coVisitors.take(3).toList().asMap().entries.map((e) {
                          final idx = e.key;
                          final cv = e.value;
                          return Positioned(
                            left: idx * 14.0,
                            child: CircleAvatar(
                              radius: 14,
                              backgroundImage: cv.profileImageUrl != null
                                  ? NetworkImage(UtilsHelper.resolveImageUrl(cv.profileImageUrl!))
                                  : null,
                              backgroundColor: MyColors.avatarBackgroundColor,
                              child: cv.profileImageUrl == null
                                  ? Text(
                                      _cvInitials(cv),
                                      style: const TextStyle(fontSize: 9),
                                    )
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  // Action icons (owner only)
                  if (widget.isOwner) ...[
                    if (widget.onInvite != null)
                      IconButton(
                        onPressed: _showInviteSheet,
                        icon: const Icon(Icons.person_add_outlined, size: 20),
                        color: MyColors.primaryDarkColor,
                        tooltip: 'Pozovi',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                      ),
                    if (widget.onEdit != null)
                      IconButton(
                        onPressed: widget.onEdit,
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        color: Colors.grey.shade600,
                        tooltip: 'Uredi',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                      ),
                    if (widget.onDelete != null)
                      IconButton(
                        onPressed: _showDeleteConfirmation,
                        icon: const Icon(Icons.delete_outline, size: 20),
                        color: Colors.red.shade400,
                        tooltip: 'Obrisi',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                      ),
                  ],
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),

            // ─── Expanded content ────────────────────────────────────────
            if (_expanded) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Consumed items
                    if (consumedItems.isNotEmpty) ...[
                      Text(
                        'Konzumirano',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const VerticalSpacer(6),
                      ...consumedItems.map((item) => _buildConsumedItemRow(item)),
                      const VerticalSpacer(8),
                    ],
                    // Co-visitor list
                    if (coVisitors.isNotEmpty) ...[
                      Text(
                        'Sudionici',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const VerticalSpacer(6),
                      ...coVisitors.map((cv) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundImage: cv.profileImageUrl != null
                                      ? NetworkImage(UtilsHelper.resolveImageUrl(cv.profileImageUrl!))
                                      : null,
                                  backgroundColor: MyColors.avatarBackgroundColor,
                                  child: cv.profileImageUrl == null
                                      ? Text(
                                          _cvInitials(cv),
                                          style: const TextStyle(fontSize: 9),
                                        )
                                      : null,
                                ),
                                const HorizontalSpacer(8),
                                Text(
                                  '${cv.firstName ?? ''} ${cv.lastName ?? ''}'.trim(),
                                  style: GoogleFonts.outfit(fontSize: 13),
                                ),
                              ],
                            ),
                          )),
                    ],
                    // Visit photos
                    if (visit.photoUrls != null && visit.photoUrls!.isNotEmpty) ...[
                      const VerticalSpacer(8),
                      Text(
                        'Fotografije',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const VerticalSpacer(6),
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: visit.photoUrls!.length,
                          itemBuilder: (ctx, i) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                visit.photoUrls![i],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey.shade200,
                                  child: const Icon(Icons.broken_image, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _ratingChip(String label, double? value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$label: ${value?.toStringAsFixed(1) ?? '-'}',
        style: const TextStyle(fontSize: 10),
      ),
    );
  }

  Widget _buildConsumedItemRow(ConsumedItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: MyColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _categoryLabel(item.category),
              style: TextStyle(fontSize: 10, color: MyColors.primaryDarkColor),
            ),
          ),
          const HorizontalSpacer(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name ?? '',
                  style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                if (item.notes != null && item.notes!.isNotEmpty)
                  Text(
                    item.notes!,
                    style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey.shade600),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _sum(Rating rating) {
    return (rating.ambientRating ?? 0) + (rating.foodRating ?? 0) + (rating.priceRating ?? 0);
  }

  String _cvInitials(CoVisitor cv) {
    final first = cv.firstName?.isNotEmpty == true ? cv.firstName![0] : '';
    final last = cv.lastName?.isNotEmpty == true ? cv.lastName![0] : '';
    return '$first$last';
  }
}
