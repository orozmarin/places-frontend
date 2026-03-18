import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/models/from_where.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/models/place_search_form.dart';
import 'package:gastrorate/screens/places.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/invitations/invitations_actions.dart';
import 'package:gastrorate/store/places/places_actions.dart';

class PlacesPage extends StatelessWidget {
  const PlacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(this),
      onInit: (Store<AppState> store) {
        store.dispatch(FetchPlacesAction());
        final userId = store.state.authState.loggedUser?.id;
        if (userId != null) {
          store.dispatch(FetchSharedPlacesAction(userId));
        }
      },
      builder: (BuildContext context, ViewModel vm) => Places(
        places: vm.places,
        sharedPlaces: vm.sharedPlaces,
        onFindAllPlaces: vm.onFindAllPlaces,
        onDeletePlace: vm.onDeletePlace,
        onInitPlaceForm: vm.onInitPlaceForm,
        friends: vm.friends,
        onInviteCoVisitor: vm.onInviteCoVisitor,
        onLeavePlace: vm.onLeavePlace,
        onAcknowledgeTransfer: vm.onAcknowledgeTransfer,
      ),
    );
  }
}

class Factory extends VmFactory<AppState, PlacesPage, ViewModel> {
  Factory(PlacesPage widget) : super(widget);

  @override
  ViewModel? fromStore() => ViewModel(
    places: state.placesState.places,
    sharedPlaces: state.placesState.sharedPlaces,
    friends: state.friendshipsState.friends,
    onFindAllPlaces: (PlaceSearchForm psf) => dispatch(FetchPlacesAction(placeSearchForm: psf)),
    onDeletePlace: (place) => dispatch(DeletePlaceAction(place)),
    onInitPlaceForm: (Place place) => dispatch(InitNewPlaceAction(payload: place, fromWhere: FromWhere.places)),
    onInviteCoVisitor: (placeId, friendId) => dispatch(SendVisitInvitationAction(placeId, friendId)),
    onLeavePlace: (place) => dispatch(RemoveCoVisitorAction(place.id!, state.authState.loggedUser!.id!)),
    onAcknowledgeTransfer: (placeId) => dispatch(AcknowledgeOwnershipTransferAction(placeId)),
  );
}

class ViewModel extends Vm {
  final List<Place>? places;
  final List<Place>? sharedPlaces;
  final List<User>? friends;
  final Function(PlaceSearchForm) onFindAllPlaces;
  final Function(Place place) onDeletePlace;
  final Function(Place place) onInitPlaceForm;
  final Function(String placeId, String friendId) onInviteCoVisitor;
  final Function(Place place) onLeavePlace;
  final Function(String placeId) onAcknowledgeTransfer;

  ViewModel({
    required this.places,
    required this.sharedPlaces,
    required this.friends,
    required this.onFindAllPlaces,
    required this.onDeletePlace,
    required this.onInitPlaceForm,
    required this.onInviteCoVisitor,
    required this.onLeavePlace,
    required this.onAcknowledgeTransfer,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          super == other &&
              other is ViewModel &&
              runtimeType == other.runtimeType &&
              places == other.places &&
              sharedPlaces == other.sharedPlaces &&
              friends == other.friends &&
              onFindAllPlaces == other.onFindAllPlaces &&
              onDeletePlace == other.onDeletePlace &&
              onInitPlaceForm == other.onInitPlaceForm &&
              onInviteCoVisitor == other.onInviteCoVisitor &&
              onLeavePlace == other.onLeavePlace &&
              onAcknowledgeTransfer == other.onAcknowledgeTransfer;

  @override
  int get hashCode =>
      super.hashCode ^
      places.hashCode ^
      sharedPlaces.hashCode ^
      friends.hashCode ^
      onFindAllPlaces.hashCode ^
      onDeletePlace.hashCode ^
      onInitPlaceForm.hashCode ^
      onInviteCoVisitor.hashCode ^
      onLeavePlace.hashCode ^
      onAcknowledgeTransfer.hashCode;
}
