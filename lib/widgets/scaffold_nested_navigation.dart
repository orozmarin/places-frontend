import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:gastrorate/models/from_where.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/screens/place_search_page.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/places/places_actions.dart';
import 'package:gastrorate/widgets/scaffold_navbar.dart';
import 'package:gastrorate/widgets/scaffold_navrail.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNestedNavigation extends StatefulWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(key: key);

  final StatefulNavigationShell navigationShell;

  @override
  State<ScaffoldWithNestedNavigation> createState() =>
      _ScaffoldWithNestedNavigationState();
}

class _ScaffoldWithNestedNavigationState
    extends State<ScaffoldWithNestedNavigation> {
  int _lastSelectedIndex = 0;
  Key _bodyKey = UniqueKey();

  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );

    if (index != _lastSelectedIndex) {
      setState(() {
        _lastSelectedIndex = index;
        _bodyKey = UniqueKey(); // Force rebuild
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = KeyedSubtree(
      key: _bodyKey,
      child: widget.navigationShell,
    );

    return StoreConnector<AppState, _NavVm>(
      vm: () => _NavVmFactory(this),
      builder: (context, vm) {
        return LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            return ScaffoldWithNavigationBar(
              body: body,
              selectedIndex: widget.navigationShell.currentIndex,
              onDestinationSelected: _goBranch,
              onAddPlace: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlaceSearchPage(
                    existingPlaces: vm.places,
                    onPlaceSelected: vm.onInitPlaceForm,
                  ),
                ),
              ),
            );
          } else {
            return ScaffoldWithNavigationRail(
              body: body,
              selectedIndex: widget.navigationShell.currentIndex,
              onDestinationSelected: _goBranch,
            );
          }
        });
      },
    );
  }
}

class _NavVm extends Vm {
  final List<Place>? places;
  final Function(Place) onInitPlaceForm;

  _NavVm({
    required this.places,
    required this.onInitPlaceForm,
  }) : super(equals: [places]);
}

class _NavVmFactory extends VmFactory<AppState, _ScaffoldWithNestedNavigationState, _NavVm> {
  _NavVmFactory(super.connector);

  @override
  _NavVm fromStore() {
    return _NavVm(
      places: state.placesState.places,
      onInitPlaceForm: (Place place) => dispatch(
        InitNewPlaceAction(payload: place, fromWhere: FromWhere.places),
      ),
    );
  }
}
