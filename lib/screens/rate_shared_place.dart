import 'package:flutter/material.dart';
import 'package:gastrorate/models/rating.dart';
import 'package:gastrorate/models/user_visit.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/custom_app_bar.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/default_button.dart';
import 'package:gastrorate/widgets/place_rating_dialog.dart';
import 'package:gastrorate/widgets/rating_summary_card.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';

class RateSharedPlace extends StatefulWidget {
  const RateSharedPlace({
    super.key,
    required this.activeVisit,
    required this.onRate,
  });

  final UserVisit? activeVisit;
  final Function(String visitId, Rating rating) onRate;

  @override
  State<RateSharedPlace> createState() => _RateSharedPlaceState();
}

class _RateSharedPlaceState extends State<RateSharedPlace> {
  Rating? _rating;

  Widget _buildRatingCard() {
    return _rating == null
        ? InkWell(
            onTap: _openRatingDialog,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 140,
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
                  CustomText("Add Rating", style: TextStyle(color: MyColors.primaryColor)),
                ],
              ),
            ),
          )
        : RatingSummaryCard(
            rating: _rating!,
            onEditRating: _openRatingDialog,
            onDeleteRating: () => setState(() => _rating = null),
          );
  }

  void _openRatingDialog() {
    final ratingToEdit = _rating ?? Rating(ambientRating: 1, foodRating: 1, priceRating: 1);
    setState(() => _rating = ratingToEdit);
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
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
              PlaceRatingDialog(rating: ratingToEdit),
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

  @override
  Widget build(BuildContext context) {
    final visit = widget.activeVisit;
    if (visit == null) {
      return const Scaffold(
        body: Center(child: CustomText("No active visit.")),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: const CustomText(
          "Rate your visit",
          style: TextStyle(color: MyColors.navbarItemColor),
        ),
        backgroundColor: MyColors.appbarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(
              "How was your visit?",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const VerticalSpacer(24),
            Center(child: _buildRatingCard()),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
        padding: const EdgeInsets.all(12),
        child: ButtonComponent(
          text: "Confirm rating",
          isDisabled: _rating == null,
          onPressed: () {
            if (_rating != null) {
              widget.onRate(visit.id!, _rating!);
            }
          },
        ),
      ),
      ),
    );
  }
}
