import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:gastrorate/models/rating.dart';
import 'package:gastrorate/models/user_visit.dart';
import 'package:gastrorate/screens/rate_shared_place.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/invitations/invitations_actions.dart';

class RateSharedPlacePage extends StatelessWidget {
  const RateSharedPlacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(this),
      builder: (BuildContext context, ViewModel vm) => RateSharedPlace(
        activeVisit: vm.activeVisit,
        onRate: vm.onRate,
      ),
    );
  }
}

class Factory extends VmFactory<AppState, RateSharedPlacePage, ViewModel> {
  Factory(RateSharedPlacePage widget) : super(widget);

  @override
  ViewModel? fromStore() => ViewModel(
        activeVisit: state.invitationsState.activeVisit,
        onRate: (String visitId, Rating rating) =>
            dispatch(RateVisitAction(visitId, rating)),
      );
}

class ViewModel extends Vm {
  final UserVisit? activeVisit;
  final Function(String visitId, Rating rating) onRate;

  ViewModel({required this.activeVisit, required this.onRate});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          activeVisit == other.activeVisit &&
          onRate == other.onRate;

  @override
  int get hashCode => super.hashCode ^ activeVisit.hashCode ^ onRate.hashCode;
}
