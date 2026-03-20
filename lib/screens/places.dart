import 'package:flutter/material.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/place_search_form.dart';
import 'package:gastrorate/screens/place_search_screen.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/tools/place_helper.dart';
import 'package:gastrorate/widgets/custom_app_bar.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/place_card.dart';
import 'package:gastrorate/widgets/place_search_bar.dart';
import 'package:lottie/lottie.dart';

class Places extends StatefulWidget {
  Places(
      {super.key,
      required this.places,
      required this.sharedPlaces,
      required this.onFindAllPlaces,
      required this.onDeletePlace,
      required this.onInitPlaceForm,
      this.friends,
      this.onInviteCoVisitor,
      this.onLeavePlace,
      this.onAcknowledgeTransfer});

  final Function(PlaceSearchForm) onFindAllPlaces;
  final List<Place>? places;
  final List<Place>? sharedPlaces;
  final Function(Place place) onDeletePlace;
  final Function(Place place) onInitPlaceForm;
  final List<User>? friends;
  final Function(String placeId, String friendId)? onInviteCoVisitor;
  final Function(Place place)? onLeavePlace;
  final Function(String placeId)? onAcknowledgeTransfer;

  @override
  State<StatefulWidget> createState() => _PlacesState();
}

class _PlacesState extends State<Places> with SingleTickerProviderStateMixin {
  PlaceSorting _selectedSorting = PlaceSorting.DATE_DESC;
  List<Place> _places = <Place>[];

  late TabController _tabController;
  int _currentTabIndex = 0;

  final ScrollController _scrollController = ScrollController();
  bool _isVisible = true;
  double _previousScrollOffset = 0;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Place> get _displayedMyPlaces {
    if (_searchQuery.isEmpty) return _places;
    final q = _searchQuery.toLowerCase();
    return _places.where((p) =>
        (p.name?.toLowerCase().contains(q) ?? false) ||
        (p.city?.toLowerCase().contains(q) ?? false) ||
        (p.address?.toLowerCase().contains(q) ?? false)).toList();
  }

  List<Place> get _displayedSharedPlaces {
    final shared = widget.sharedPlaces ?? [];
    if (_searchQuery.isEmpty) return shared;
    final q = _searchQuery.toLowerCase();
    return shared.where((p) =>
        (p.name?.toLowerCase().contains(q) ?? false) ||
        (p.city?.toLowerCase().contains(q) ?? false) ||
        (p.address?.toLowerCase().contains(q) ?? false)).toList();
  }

  // Detect scroll direction and show or hide the button
  void _onScroll() {
    if (_scrollController.offset > _previousScrollOffset && _isVisible) {
      // Scrolling down, hide the button
      setState(() {
        _isVisible = false;
      });
    } else if (_scrollController.offset < _previousScrollOffset && !_isVisible) {
      // Scrolling up, show the button
      setState(() {
        _isVisible = true;
      });
    }
    _previousScrollOffset = _scrollController.offset;
  }

  @override
  void didUpdateWidget(covariant Places oldWidget) {
    if (widget.places != null){
      _places = widget.places!;
      _places = PlaceHelper.sortPlaces(_places, _selectedSorting);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() => _currentTabIndex = _tabController.index);
    });
    if (widget.places != null){
      _places = widget.places!;
      _places = PlaceHelper.sortPlaces(_places, _selectedSorting);
    }
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: const CustomText("Places", style: TextStyle(color: MyColors.navbarItemColor)),
        backgroundColor: MyColors.appbarColor,
        actions: [
          if (_currentTabIndex == 0) buildSortingButton(),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: MyColors.navbarItemColor,
          unselectedLabelColor: MyColors.navbarItemColor.withOpacity(0.6),
          indicatorColor: MyColors.navbarItemColor,
          tabs: const [
            Tab(text: "My Places"),
            Tab(text: "Shared with Me"),
          ],
        ),
      ),
      body: Column(
        children: [
          PlaceSearchBar(
            controller: _searchController,
            query: _searchQuery,
            onChanged: (q) => setState(() => _searchQuery = q),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMyPlacesTab(),
                _buildSharedPlacesTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: showAddPlaceButton()
          ? AnimatedOpacity(
              opacity: 1.0, duration: const Duration(milliseconds: 300), child: buildAddPlaceButton(context))
          : const AnimatedOpacity(
              opacity: 0.0,
              duration: Duration(milliseconds: 200),
              child: SizedBox.shrink(),
            ),
    );
  }

  Widget _buildTransferBanner(BuildContext context, Place place) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 13, color: Colors.blue.shade900),
                children: [
                  TextSpan(
                    text: place.ownershipTransferredFromName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: " deleted "),
                  TextSpan(
                    text: place.name ?? 'a place',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                  ),
                  const TextSpan(text: ". You are now the host of this place."),
                ],
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () => widget.onAcknowledgeTransfer?.call(place.id!),
            child: Text("OK", style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildMyPlacesTab() {
    final displayed = _displayedMyPlaces;
    final transferredPlaces = displayed.where((p) => p.ownershipTransferredFromName != null).toList();
    return Center(
      child: displayed.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20, top: 10),
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      final place = displayed[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (transferredPlaces.contains(place))
                            _buildTransferBanner(context, place),
                          PlaceCard(
                            place: place,
                            onDeletePlace: widget.onDeletePlace,
                            onInitPlaceForm: widget.onInitPlaceForm,
                            friends: widget.friends,
                            onInviteCoVisitor: widget.onInviteCoVisitor,
                          ),
                        ],
                      );
                    },
                    itemCount: displayed.length,
                  ),
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: buildEmptyState(),
            ),
    );
  }

  Widget _buildSharedPlacesTab() {
    final shared = widget.sharedPlaces ?? [];
    if (shared.isEmpty) {
      return const Center(
        child: CustomText("No places shared with you yet."),
      );
    }
    final displayed = _displayedSharedPlaces;
    if (displayed.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: buildEmptyState(),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20, top: 10),
      itemCount: displayed.length,
      itemBuilder: (context, index) {
        final place = displayed[index];
        return Dismissible(
          key: ValueKey(place.id),
          direction: DismissDirection.endToStart,
          background: const SizedBox.shrink(),
          secondaryBackground: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.amber.shade700,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Leave", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                SizedBox(width: 8),
                Icon(Icons.exit_to_app, color: Colors.white),
              ],
            ),
          ),
          confirmDismiss: (direction) async {
            bool confirmed = false;
            await showModalBottomSheet(
              context: context,
              useSafeArea: true,
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
                      "Leave ${place.name ?? 'this place'}?",
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
                              confirmed = true;
                              Navigator.of(sheetContext).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
            return confirmed;
          },
          onDismissed: (direction) => widget.onLeavePlace?.call(place),
          child: PlaceCard(
            place: place,
            onInitPlaceForm: widget.onInitPlaceForm,
            onLeavePlace: widget.onLeavePlace,
          ),
        );
      },
    );
  }

  bool showAddPlaceButton() => _currentTabIndex == 0 && (_isVisible || (_places.length < 3));

  List<Widget> buildEmptyState() {
    return <Widget>[
      Lottie.asset("assets/empty_state_places.json"),
      CustomText(
        "Start rating Places!",
        style: Theme.of(context).textTheme.titleMedium,
      ),
    ];
  }

  FloatingActionButton buildAddPlaceButton(BuildContext context) {
    return FloatingActionButton.extended(
      icon: const Icon(Icons.add, color: MyColors.navbarItemColor),
      label: const CustomText(
        "Add Place",
        style: TextStyle(color: MyColors.navbarItemColor),
      ),
      backgroundColor: MyColors.primaryDarkColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: const BorderSide(
          color: Colors.black12,
          width: 1,
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlaceSearchScreen(
              existingPlaces: widget.places,
              onPlaceSelected: widget.onInitPlaceForm,
            ),
          ),
        );
      },
      elevation: 6.0,
      focusElevation: 10.0,
      highlightElevation: 8.0,
      splashColor: Colors.white.withOpacity(0.3),
    );
  }

  PopupMenuButton<PlaceSorting> buildSortingButton() {
    return PopupMenuButton<PlaceSorting>(
      surfaceTintColor: MyColors.mainBackgroundColor,
      icon: const Icon(
        Icons.filter_list,
        color: Colors.white,
      ),
      onSelected: (PlaceSorting value) {
        _selectedSorting = value;
        _places = PlaceHelper.sortPlaces(_places, value);
        setState(() {});
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<PlaceSorting>>[
        _buildPopupMenuItem("Alphabetically (A-Z)", PlaceSorting.ALPHABETICALLY_ASC),
        _buildPopupMenuItem("Alphabetically (Z-A)", PlaceSorting.ALPHABETICALLY_DESC),
        _buildPopupMenuItem("Rating (Low to High)", PlaceSorting.RATING_ASC),
        _buildPopupMenuItem("Rating (High to Low)", PlaceSorting.RATING_DESC),
        _buildPopupMenuItem("Date (Oldest First)", PlaceSorting.DATE_ASC),
        _buildPopupMenuItem("Date (Newest First)", PlaceSorting.DATE_DESC),
      ],
    );
  }

  PopupMenuItem<PlaceSorting> _buildPopupMenuItem(String text, PlaceSorting value) {
    return PopupMenuItem<PlaceSorting>(
      value: value,
      child: Text(text, style: TextStyle(fontWeight: _selectedSorting == value ? FontWeight.bold : FontWeight.normal)),
    );
  }
}
