import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/screens/settings.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/auth/auth.actions.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(this),
      builder: (BuildContext context, ViewModel vm) => Settings(logOut: vm.logOut, user: vm.user,),
    );
  }
}

class Factory extends VmFactory<AppState, SettingsPage, ViewModel> {
  Factory(SettingsPage widget) : super(widget);

  @override
  ViewModel? fromStore() => ViewModel(logOut: () => dispatch(LogoutAction()), user: state.authState.loggedUser ?? User());
}

class ViewModel extends Vm {
  ViewModel({required this.logOut, required this.user});

  final Function() logOut;
  final User user;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          logOut == other.logOut &&
          user == other.user;

  @override
  int get hashCode => super.hashCode ^ logOut.hashCode ^ user.hashCode;
}
