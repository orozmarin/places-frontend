import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/screens/profile.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/auth/auth.actions.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(this),
      builder: (BuildContext context, ViewModel vm) =>
          Profile(logOut: vm.logOut, user: vm.user, onEditUser: vm.onEditUser),
    );
  }
}

class Factory extends VmFactory<AppState, ProfilePage, ViewModel> {
  Factory(ProfilePage widget) : super(widget);

  @override
  ViewModel? fromStore() => ViewModel(
        logOut: () => dispatch(LogoutAction()),
        user: state.authState.loggedUser ?? User(),
        onEditUser: (user) {},
      );
}

class ViewModel extends Vm {
  ViewModel({required this.logOut, required this.user, required this.onEditUser});

  final Function() logOut;
  final User user;
  final Function(User user) onEditUser;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          logOut == other.logOut &&
          user == other.user &&
          onEditUser == other.onEditUser;

  @override
  int get hashCode => super.hashCode ^ logOut.hashCode ^ user.hashCode ^ onEditUser.hashCode;
}
