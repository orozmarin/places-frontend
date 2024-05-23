import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:gastrorate/screens/settings.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/places/places_actions.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(this),
      onInit: (Store<AppState> store) => store.dispatch(FetchPlacesAction()),
      builder: (BuildContext context, ViewModel vm) => const Settings(),
    );
  }
}

class Factory extends VmFactory<AppState, SettingsPage, ViewModel> {
  Factory(SettingsPage widget) : super(widget);

  @override
  ViewModel? fromStore() => ViewModel();
}

class ViewModel extends Vm {
  ViewModel();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || super == other && other is ViewModel && runtimeType == other.runtimeType;

  @override
  int get hashCode => super.hashCode;
}
