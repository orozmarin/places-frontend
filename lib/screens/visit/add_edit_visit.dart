import 'package:flutter/material.dart';
import 'package:gastrorate/models/rating.dart';
import 'package:gastrorate/models/visit/consumed_item.dart';
import 'package:gastrorate/models/visit/place_visit.dart';
import 'package:gastrorate/models/visit/update_place_visit_request.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/custom_app_bar.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/default_button.dart';
import 'package:gastrorate/widgets/place_rating_dialog.dart';
import 'package:gastrorate/widgets/rating_summary_card.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';
import 'package:gastrorate/widgets/horizontal_spacer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddEditVisit extends StatefulWidget {
  const AddEditVisit({
    super.key,
    required this.placeId,
    this.existingVisit,
    required this.onAddVisit,
    required this.onUpdateVisit,
    this.loggedUserId,
  });

  final String? placeId;
  final PlaceVisit? existingVisit;
  final Function(PlaceVisit visit) onAddVisit;
  final Function(String visitId, String placeId, UpdatePlaceVisitRequest req) onUpdateVisit;
  final String? loggedUserId;

  @override
  State<AddEditVisit> createState() => _AddEditVisitState();
}

class _AddEditVisitState extends State<AddEditVisit> {
  late DateTime _visitedAt;
  Rating? _rating;
  final List<ConsumedItem> _consumedItems = [];
  final List<String> _photoUrls = [];

  // Controllers for adding a new consumed item inline
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemNotesController = TextEditingController();
  String _selectedCategory = 'FOOD';
  bool _addingItem = false;

  bool get _isEdit => widget.existingVisit != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingVisit;
    _visitedAt = existing?.visitedAt ?? DateTime.now();
    _rating = existing?.ownerRating?.copyWith();
    if (existing?.consumedItems != null) {
      _consumedItems.addAll(existing!.consumedItems!.map((i) => i.copyWith()));
    }
    if (existing?.photoUrls != null) {
      _photoUrls.addAll(existing!.photoUrls!);
    }
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemNotesController.dispose();
    super.dispose();
  }

  void _openRatingDialog() {
    final ratingToEdit = _rating ?? Rating(ambientRating: 1, foodRating: 1, priceRating: 1);
    setState(() => _rating = ratingToEdit);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const VerticalSpacer(18),
            PlaceRatingDialog(rating: ratingToEdit),
            const VerticalSpacer(9),
            ButtonComponent(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {});
              },
              text: 'Spremi ocjenu',
            ),
            SizedBox(height: 8 + MediaQuery.of(ctx).padding.bottom),
          ],
        ),
      ),
    );
  }

  Future<void> _openDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _visitedAt,
      firstDate: DateTime.now().subtract(const Duration(days: 36500)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _visitedAt = picked);
    }
  }

  void _addConsumedItem() {
    final name = _itemNameController.text.trim();
    if (name.isEmpty) return;

    setState(() {
      _consumedItems.add(ConsumedItem(
        name: name,
        category: _selectedCategory,
        notes: _itemNotesController.text.trim().isEmpty ? null : _itemNotesController.text.trim(),
        photoUrls: [],
      ));
      _itemNameController.clear();
      _itemNotesController.clear();
      _selectedCategory = 'FOOD';
      _addingItem = false;
    });
  }

  void _removeConsumedItem(int index) {
    setState(() => _consumedItems.removeAt(index));
  }

  void _save() {
    final placeId = widget.placeId;
    if (placeId == null) return;

    if (_isEdit) {
      final req = UpdatePlaceVisitRequest(
        visitedAt: _visitedAt,
        ownerRating: _rating,
        consumedItems: _consumedItems,
        photoUrls: _photoUrls,
      );
      widget.onUpdateVisit(widget.existingVisit!.id!, placeId, req);
    } else {
      final visit = PlaceVisit(
        placeId: placeId,
        userId: widget.loggedUserId,
        visitedAt: _visitedAt,
        ownerRating: _rating,
        consumedItems: _consumedItems,
        photoUrls: _photoUrls,
      );
      widget.onAddVisit(visit);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(
        title: CustomText(
          _isEdit ? 'Uredi posjet' : 'Novi posjet',
          style: const TextStyle(color: MyColors.navbarItemColor),
        ),
        backgroundColor: MyColors.appbarColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Date ────────────────────────────────────────────────────
            _sectionTitle('Datum posjeta'),
            const VerticalSpacer(8),
            GestureDetector(
              onTap: _openDatePicker,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey.shade600),
                    const HorizontalSpacer(10),
                    Text(
                      DateFormat('d MMM yyyy').format(_visitedAt),
                      style: GoogleFonts.outfit(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),

            const VerticalSpacer(20),

            // ─── Rating ──────────────────────────────────────────────────
            _sectionTitle('Ocjena'),
            const VerticalSpacer(8),
            _rating == null
                ? GestureDetector(
                    onTap: _openRatingDialog,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: MyColors.primaryColor),
                      ),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_border_rounded, size: 28, color: MyColors.primaryColor),
                          VerticalSpacer(6),
                          CustomText(
                            '+ Dodaj ocjenu',
                            style: TextStyle(color: MyColors.primaryColor, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  )
                : RatingSummaryCard(
                    rating: _rating!,
                    onEditRating: _openRatingDialog,
                    onDeleteRating: () => setState(() => _rating = null),
                  ),

            const VerticalSpacer(20),

            // ─── Consumed items ───────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _sectionTitle('Konzumirane stavke'),
                TextButton.icon(
                  onPressed: () => setState(() => _addingItem = true),
                  icon: const Icon(Icons.add, size: 16),
                  label: Text('Dodaj', style: GoogleFonts.outfit(fontSize: 13)),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            const VerticalSpacer(8),

            if (_addingItem) _buildAddItemForm(),

            if (_consumedItems.isEmpty && !_addingItem)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Nema stavki.',
                  style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey.shade600),
                ),
              ),

            ..._consumedItems.asMap().entries.map((entry) {
              final idx = entry.key;
              final item = entry.value;
              return Card(
                elevation: 0,
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  dense: true,
                  title: Text(
                    item.name ?? '',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w500),
                  ),
                  subtitle: item.notes != null
                      ? Text(item.notes!, style: GoogleFonts.outfit(fontSize: 12))
                      : null,
                  leading: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: MyColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _categoryShort(item.category),
                      style: const TextStyle(fontSize: 10, color: MyColors.primaryDarkColor),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                    onPressed: () => _removeConsumedItem(idx),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ),
              );
            }),

            const VerticalSpacer(32),

            // ─── Save button ─────────────────────────────────────────────
            ButtonComponent(
              onPressed: _save,
              text: _isEdit ? 'Spremi izmjene' : 'Dodaj posjet',
            ),

            const VerticalSpacer(40),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w600),
    );
  }

  String _categoryShort(String? category) {
    switch (category) {
      case 'FOOD': return 'Hrana';
      case 'DRINK': return 'Pice';
      case 'DESSERT': return 'Desert';
      default: return 'Ostalo';
    }
  }

  Widget _buildAddItemForm() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _itemNameController,
            decoration: InputDecoration(
              labelText: 'Naziv stavke',
              labelStyle: GoogleFonts.outfit(fontSize: 13),
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            style: GoogleFonts.outfit(fontSize: 14),
          ),
          const VerticalSpacer(8),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: InputDecoration(
              labelText: 'Kategorija',
              labelStyle: GoogleFonts.outfit(fontSize: 13),
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            items: const [
              DropdownMenuItem(value: 'FOOD', child: Text('Hrana')),
              DropdownMenuItem(value: 'DRINK', child: Text('Pice')),
              DropdownMenuItem(value: 'DESSERT', child: Text('Desert')),
              DropdownMenuItem(value: 'OTHER', child: Text('Ostalo')),
            ],
            onChanged: (v) => setState(() => _selectedCategory = v ?? 'FOOD'),
            style: GoogleFonts.outfit(fontSize: 14, color: Colors.black),
          ),
          const VerticalSpacer(8),
          TextField(
            controller: _itemNotesController,
            decoration: InputDecoration(
              labelText: 'Biljeske (opcionalno)',
              labelStyle: GoogleFonts.outfit(fontSize: 13),
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            style: GoogleFonts.outfit(fontSize: 14),
            maxLines: 2,
          ),
          const VerticalSpacer(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => setState(() => _addingItem = false),
                child: const Text('Odustani'),
              ),
              const HorizontalSpacer(8),
              ElevatedButton(
                onPressed: _addConsumedItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Dodaj', style: GoogleFonts.outfit()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
