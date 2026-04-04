import 'package:async_redux/async_redux.dart';
import 'package:flutter/widgets.dart';
import 'package:gastrorate/models/visit/place_visit.dart';
import 'package:gastrorate/models/visit/update_place_visit_request.dart';
import 'package:gastrorate/screens/visit/add_edit_visit.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/places/places_actions.dart';

class AddEditVisitPage extends StatelessWidget {
  const AddEditVisitPage({
    super.key,
    required this.placeId,
    this.existingVisit,
  });

  final String? placeId;
  final PlaceVisit? existingVisit;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, vm) => AddEditVisit(
        placeId: placeId,
        existingVisit: existingVisit,
        onAddVisit: vm.addVisit,
        onUpdateVisit: vm.updateVisit,
        loggedUserId: vm.loggedUserId,
      ),
    );
  }
}

class _Factory extends VmFactory<AppState, AddEditVisitPage, _ViewModel> {
  _Factory(super.connector);

  @override
  _ViewModel fromStore() => _ViewModel(
        addVisit: (visit) => dispatch(AddPlaceVisitAction(visit)),
        updateVisit: (visitId, placeId, req) => dispatch(UpdatePlaceVisitAction(visitId, placeId, req)),
        loggedUserId: state.authState.loggedUser?.id,
      );
}

class _ViewModel extends Vm {
  final Function(PlaceVisit visit) addVisit;
  final Function(String visitId, String placeId, UpdatePlaceVisitRequest req) updateVisit;
  final String? loggedUserId;

  _ViewModel({
    required this.addVisit,
    required this.updateVisit,
    required this.loggedUserId,
  }) : super(equals: [loggedUserId]);
}
