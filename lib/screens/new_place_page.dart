import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/visit/place_visit.dart';
import 'package:gastrorate/models/visit/update_place_visit_request.dart';
import 'package:gastrorate/screens/new_place.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/invitations/invitations_actions.dart';
import 'package:gastrorate/store/places/places_actions.dart';

class NewPlacePage extends StatelessWidget {
  const NewPlacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(this),
      onInit: (store) {
        final placeId = store.state.placesState.place?.id;
        if (placeId != null) {
          store.dispatch(FetchPlaceVisitsAction(placeId));
        }
      },
      builder: (BuildContext context, ViewModel vm) => NewPlace(
        place: vm.foundPlace,
        onSavePlace: vm.onSavePlace,
        onDeletePlace: vm.onDeletePlace,
        onInviteVisitor: vm.onInviteVisitor,
        friends: vm.friends,
        loggedInUserId: vm.loggedInUserId,
        onRemoveCoVisitor: vm.onRemoveCoVisitor,
        selectedVisit: vm.selectedVisit,
        onAddVisit: vm.onAddVisit,
        onUpdateVisit: vm.onUpdateVisit,
        onDeleteVisit: vm.onDeleteVisit,
      ),
    );
  }
}

class Factory extends VmFactory<AppState, NewPlacePage, ViewModel> {
  Factory(NewPlacePage widget) : super(widget);

  @override
  ViewModel? fromStore() => ViewModel(
        foundPlace: state.placesState.place,
        friends: state.friendshipsState.friends,
        selectedVisit: state.placesState.selectedVisit,
        onSavePlace: (Place place) {
          final isOwner = place.userId == state.authState.loggedUser?.id;
          if (isOwner || place.visitId == null) {
            dispatch(SaveOrUpdatePlaceAction(place));
          } else {
            dispatch(UpdateCoVisitorRatingAction(place.visitId!, place.rating!));
          }
        },
        onDeletePlace: (place) => dispatch(DeletePlaceAction(place)),
        onInviteVisitor: (String placeId, String friendId) =>
            dispatch(SendVisitInvitationAction(placeId, friendId)),
        loggedInUserId: state.authState.loggedUser?.id,
        onRemoveCoVisitor: (placeId, coVisitorUserId) =>
            dispatch(RemoveCoVisitorAction(placeId, coVisitorUserId)),
        onAddVisit: (visit) => dispatch(AddPlaceVisitAction(visit)),
        onUpdateVisit: (visitId, placeId, req) => dispatch(UpdatePlaceVisitAction(visitId, placeId, req)),
        onDeleteVisit: (visitId, placeId) => dispatch(DeletePlaceVisitAction(visitId, placeId)),
      );
}

class ViewModel extends Vm {
  final Place? foundPlace;
  final List<User>? friends;
  final PlaceVisit? selectedVisit;
  final Function(Place place) onSavePlace;
  final Function(Place place) onDeletePlace;
  final Function(String placeId, String friendId) onInviteVisitor;
  final String? loggedInUserId;
  final Function(String placeId, String coVisitorUserId) onRemoveCoVisitor;
  final Function(PlaceVisit visit) onAddVisit;
  final Function(String visitId, String placeId, UpdatePlaceVisitRequest req) onUpdateVisit;
  final Function(String visitId, String placeId) onDeleteVisit;

  ViewModel({
    required this.foundPlace,
    required this.friends,
    required this.selectedVisit,
    required this.onSavePlace,
    required this.onDeletePlace,
    required this.onInviteVisitor,
    required this.loggedInUserId,
    required this.onRemoveCoVisitor,
    required this.onAddVisit,
    required this.onUpdateVisit,
    required this.onDeleteVisit,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          foundPlace == other.foundPlace &&
          friends == other.friends &&
          selectedVisit == other.selectedVisit &&
          onSavePlace == other.onSavePlace &&
          onDeletePlace == other.onDeletePlace &&
          onInviteVisitor == other.onInviteVisitor &&
          loggedInUserId == other.loggedInUserId &&
          onRemoveCoVisitor == other.onRemoveCoVisitor &&
          onAddVisit == other.onAddVisit &&
          onUpdateVisit == other.onUpdateVisit &&
          onDeleteVisit == other.onDeleteVisit;

  @override
  int get hashCode =>
      super.hashCode ^
      foundPlace.hashCode ^
      friends.hashCode ^
      selectedVisit.hashCode ^
      onSavePlace.hashCode ^
      onDeletePlace.hashCode ^
      onInviteVisitor.hashCode ^
      loggedInUserId.hashCode ^
      onRemoveCoVisitor.hashCode ^
      onAddVisit.hashCode ^
      onUpdateVisit.hashCode ^
      onDeleteVisit.hashCode;
}
