import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/models/co_visitor.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/place_review.dart';
import 'package:gastrorate/models/rating.dart';
import 'package:gastrorate/screens/dialogs/place_review_dialog.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/add_visitors_sheet.dart';
import 'package:gastrorate/widgets/custom_app_bar.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/date_input_with_date_picker.dart';
import 'package:gastrorate/widgets/default_button.dart';
import 'package:gastrorate/widgets/horizontal_line.dart';
import 'package:gastrorate/widgets/horizontal_spacer.dart';
import 'package:gastrorate/widgets/page_body_card.dart';
import 'package:gastrorate/widgets/photo_gallery.dart';
import 'package:gastrorate/widgets/place_rating_dialog.dart';
import 'package:gastrorate/widgets/rating_summary_card.dart';
import 'package:gastrorate/widgets/review_swiper.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';
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
    _latestDate = DateTime(
      now.year,
      now.month,
      now.day,
      23,
      59,
      59,
    );
    currentPlace.isFavorite ??= false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: CustomText(
          currentPlace.name ?? "N/A",
        ),
        actions: [
          IconButton(
            icon: Icon(currentPlace.isFavorite ?? false ? CupertinoIcons.heart_fill : CupertinoIcons.heart),
            onPressed: () {
              setState(() {
                currentPlace.isFavorite = !currentPlace.isFavorite!;
              });
            },
          ),
          if (currentPlace.url != null)
            IconButton(
              icon: const Icon(Icons.location_on),
              onPressed: () async {
                final Uri mapsUri = Uri.parse(currentPlace.url!);
                if (await canLaunchUrl(mapsUri)) {
                  await launchUrl(mapsUri);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open Google Maps.')),
                  );
                }
              },
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: PageBodyCard(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAddress(context),
                buildPlaceInformation(context),
                const VerticalSpacer(16),
                if (currentPlace.reviews != null && currentPlace.reviews!.isNotEmpty)
                  ReviewSwiper(
                    reviews: currentPlace.reviews ?? <PlaceReview>[],
                    onTap: (PlaceReview review) => showReviewDialog(review),
                  ),
                const VerticalSpacer(12),
                const HorizontalLine(),
                if (currentPlace.photos != null && currentPlace.photos!.isNotEmpty)
                  PhotoGallery(photos: currentPlace.photos ?? []),
                const VerticalSpacer(8),
                Align(
                  alignment: Alignment.center,
                  child: CustomText("My Rating", style: Theme.of(context).textTheme.headlineSmall),
                ),
                const VerticalSpacer(8),
                buildOwnerRating(),
                const VerticalSpacer(12),
                _buildCoVisitorsSection(),
                const VerticalSpacer(12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 38),
                  child: Row(
                    children: [
                      CustomText("Visited at:", style: Theme.of(context).textTheme.bodyLarge),
                      const HorizontalSpacer(8),
                      DateInputWithDatePicker(
                        title: 'Select date',
                        maximumDate: _latestDate,
                        width: 150,
                        minimumDate: _earliestDate,
                        date: _visitedAt,
                        onDateChanged: (DateTime newDate) => _onDateChanged(newDate),
                      ),
                    ],
                  ),
                ),
                if (currentPlace.id != null) ...[
                  const VerticalSpacer(16),
                  const HorizontalLine(),
                  const VerticalSpacer(12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          "Co-visitors",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const VerticalSpacer(8),
                        if (currentPlace.coVisitors != null && currentPlace.coVisitors!.isNotEmpty)
                          ...currentPlace.coVisitors!.map((visitor) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundImage: visitor.profileImageUrl != null
                                          ? NetworkImage(visitor.profileImageUrl!)
                                          : null,
                                      child: visitor.profileImageUrl == null
                                          ? Text(
                                              '${visitor.firstName?[0] ?? '?'}${visitor.lastName?[0] ?? ''}',
                                              style: const TextStyle(fontSize: 12),
                                            )
                                          : null,
                                    ),
                                    const HorizontalSpacer(8),
                                    CustomText('${visitor.firstName ?? ''} ${visitor.lastName ?? ''}'),
                                  ],
                                ),
                              )),
                        const VerticalSpacer(8),
                        ButtonComponent.outlinedButtonSmall(
                          text: "Add co-visitors",
                          onPressed: _showAddVisitorsSheet,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: currentPlace.rating == null
            ? ButtonComponent(
                text: "Save",
                isDisabled: currentPlace.rating == null,
                onPressed: () {
                  widget.onSavePlace(currentPlace);
                  Navigator.pop(context);
                },
              )
            : Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: ButtonComponent(
                      text: "Save",
                      isDisabled: currentPlace.rating == null,
                      onPressed: () {
                        widget.onSavePlace(currentPlace);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: ButtonComponent(
                      iconData: CupertinoIcons.delete_simple,
                      onPressed: () {
                        _showDeleteConfirmationDialog(context);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildOwnerRating() {
    return Center(
      child: _buildRatingCard(currentPlace.rating, () {
        setState(() {
          currentPlace.rating ??= Rating(ambientRating: 1, foodRating: 1, priceRating: 1);
          showRatingDialog(currentPlace.rating!);
        });
      }),
    );
  }

  ExpansionTile buildOpeningHours(BuildContext context) {
    return ExpansionTile(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12), bottom: Radius.circular(12)),
      ),
      title: CustomText(
        "Opening Hours",
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: MyColors.primaryColor,
            ),
      ),
      children: currentPlace.openingHours!.weekdayText?.map((day) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
              child: CustomText(
                day,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.start,
              ),
            );
          }).toList() ??
          [],
    );
  }

  Padding buildPlaceInformation(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          if (currentPlace.contactNumber != null)
            Row(
              children: [
                const Icon(Icons.phone, size: 18, color: Colors.grey),
                const HorizontalSpacer(8),
                GestureDetector(
                  onTap: () async {
                    final String phoneNumber = currentPlace.contactNumber!.replaceAll(" ", "");
                    final Uri phoneUri = Uri(path: phoneNumber, scheme: "tel");

                    if (await canLaunchUrl(phoneUri)) {
                      await launchUrl(phoneUri);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Could not launch the dialer.')),
                      );
                    }
                  },
                  child: CustomText(
                    currentPlace.contactNumber!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          const HorizontalSpacer(16),
          Row(
            children: [
              CustomText(
                currentPlace.openingHours?.openNow == true ? "Open now" : "Closed",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const HorizontalSpacer(8),
              Icon(
                Icons.circle,
                color: currentPlace.openingHours?.openNow == true ? Colors.green : Colors.red,
                size: 12,
              ),
            ],
          ),
          const HorizontalSpacer(22),
          CustomText(
            "⭐ ${currentPlace.googleRating}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget buildAddress(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0, left: 16),
      child: CustomText(
        "${currentPlace.address ?? ''}${currentPlace.city != null ? ', ${currentPlace.city}' : ''}",
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 20),
        softWrap: true,
      ),
    );
  }

  Widget _buildRatingCard(Rating? rating, VoidCallback onAdd) {
    return rating == null
        ? InkWell(
            onTap: onAdd,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 120,
              height: 80,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    spreadRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
                color: MyColors.mainBackgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: MyColors.primaryColor, width: 1),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 25, color: MyColors.primaryColor),
                  VerticalSpacer(4),
                  CustomText("Add Rating", style: TextStyle(color: MyColors.primaryColor))
                ],
              ),
            ),
          )
        : RatingSummaryCard(
            rating: rating,
            onEditRating: () => showRatingDialog(rating),
            onDeleteRating: () {
              setState(() {
                currentPlace.rating = null;
              });
            },
          );
  }

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
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
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

  Widget _buildCoVisitorsSection() {
    final coVisitors = currentPlace.coVisitors;
    if (coVisitors == null || coVisitors.isEmpty) return const SizedBox.shrink();

    final filtered = coVisitors.where((cv) => cv.userId != widget.loggedInUserId).toList();
    if (filtered.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HorizontalLine(),
        const VerticalSpacer(8),
        Align(
          alignment: Alignment.center,
          child: CustomText("Co-visitors", style: Theme.of(context).textTheme.headlineSmall),
        ),
        const VerticalSpacer(8),
        ...filtered.map(
          (cv) => ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  cv.profileImageUrl != null ? NetworkImage(cv.profileImageUrl!) : null,
              child: cv.profileImageUrl == null
                  ? Text(_getCoVisitorInitials(cv))
                  : null,
            ),
            title: CustomText('${cv.firstName ?? ''} ${cv.lastName ?? ''}'.trim()),
            trailing: const Icon(Icons.info_outline),
            onTap: () => _showCoVisitorSheet(context, cv),
          ),
        ),
      ],
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
}
