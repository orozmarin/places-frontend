import 'package:async_redux/async_redux.dart';
import 'package:flutter/widgets.dart';
import 'package:gastrorate/models/auth/update_user_request.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/screens/edit_profile/edit_profile.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/auth/auth.actions.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(this),
      builder: (BuildContext context, ViewModel vm) => EditProfile(
        user: vm.user,
        updateUser: vm.updateUser,
        isLoading: vm.isLoading,
      ),
    );
  }
}

class Factory extends VmFactory<AppState, EditProfilePage, ViewModel> {
  Factory(EditProfilePage widget) : super(widget);

  @override
  ViewModel? fromStore() => ViewModel(
        user: state.authState.loggedUser ?? User(),
        updateUser: (UpdateUserRequest request) => dispatch(UpdateUserAction(request)),
        isLoading: isWaiting(UpdateUserAction),
      );
}

class ViewModel extends Vm {
  ViewModel({
    required this.user,
    required this.updateUser,
    required this.isLoading,
  });

  final User user;
  final Function(UpdateUserRequest request) updateUser;
  final bool isLoading;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          user == other.user &&
          updateUser == other.updateUser &&
          isLoading == other.isLoading;

  @override
  int get hashCode => super.hashCode ^ user.hashCode ^ updateUser.hashCode ^ isLoading.hashCode;
}
