import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:gastrorate/models/auth/update_user_request.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/screens/onboarding/onboarding.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/auth/auth.actions.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(this),
      builder: (context, vm) => OnboardingScreen(
        user: vm.user,
        isWaitingFirstLogin: vm.isWaitingFirstLogin,
        onComplete: vm.onComplete,
        isLoading: vm.isLoading,
      ),
    );
  }
}

class Factory extends VmFactory<AppState, OnboardingPage, ViewModel> {
  Factory(super.widget);

  @override
  ViewModel fromStore() => ViewModel(
        user: state.authState.loggedUser ?? User(),
        isWaitingFirstLogin: state.authState.loggedUser?.status == UserStatus.WAITING_FIRST_LOGIN,
        onComplete: (UpdateUserRequest request) => dispatch(UpdateUserAction(request)),
        isLoading: isWaiting(UpdateUserAction),
      );
}

class ViewModel extends Vm {
  final User user;
  final bool isWaitingFirstLogin;
  final Function(UpdateUserRequest) onComplete;
  final bool isLoading;

  ViewModel({
    required this.user,
    required this.isWaitingFirstLogin,
    required this.onComplete,
    required this.isLoading,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          user == other.user &&
          isWaitingFirstLogin == other.isWaitingFirstLogin &&
          onComplete == other.onComplete &&
          isLoading == other.isLoading;

  @override
  int get hashCode =>
      super.hashCode ^
      user.hashCode ^
      isWaitingFirstLogin.hashCode ^
      onComplete.hashCode ^
      isLoading.hashCode;
}
