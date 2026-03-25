import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:gastrorate/models/auth/update_user_request.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/screens/complete_profile.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/auth/auth.actions.dart';

class CompleteProfilePage extends StatelessWidget {
  const CompleteProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(this),
      builder: (BuildContext context, ViewModel vm) => CompleteProfile(
        user: vm.user,
        onComplete: vm.onComplete,
        isLoading: vm.isLoading,
      ),
    );
  }
}

class Factory extends VmFactory<AppState, CompleteProfilePage, ViewModel> {
  Factory(CompleteProfilePage widget) : super(widget);

  @override
  ViewModel? fromStore() => ViewModel(
        user: state.authState.loggedUser ?? User(),
        onComplete: (UpdateUserRequest request) {
          dispatch(UpdateUserAction(request));
        },
        isLoading: isWaiting(UpdateUserAction),
      );
}

class ViewModel extends Vm {
  ViewModel({
    required this.user,
    required this.onComplete,
    required this.isLoading,
  });

  final User user;
  final Function(UpdateUserRequest request) onComplete;
  final bool isLoading;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          user == other.user &&
          onComplete == other.onComplete &&
          isLoading == other.isLoading;

  @override
  int get hashCode => super.hashCode ^ user.hashCode ^ onComplete.hashCode ^ isLoading.hashCode;
}
