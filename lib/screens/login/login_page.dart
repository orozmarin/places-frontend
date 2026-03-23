import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:gastrorate/models/auth/login_request.dart';
import 'package:gastrorate/models/auth/register_request.dart';
import 'package:gastrorate/screens/login/login.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/auth/auth.actions.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(this),
      builder: (BuildContext context, ViewModel vm) => Login(
        loginUser: vm.loginUser,
        registerUser: vm.registerUser,
        googleLogin: vm.googleLogin,
        appleLogin: vm.appleLogin,
        isLoading: vm.isLoading,
      ),
    );
  }
}

class Factory extends VmFactory<AppState, LoginPage, ViewModel> {
  Factory(LoginPage widget) : super(widget);

  @override
  ViewModel? fromStore() => ViewModel(
        registerUser: (RegisterRequest registerRequest) => dispatch(RegisterAction(registerRequest)),
        loginUser: (LoginRequest loginRequest) => dispatch(LoginAction(loginRequest)),
        googleLogin: () => dispatch(GoogleLoginAction()),
        appleLogin: () => dispatch(AppleLoginAction()),
        isLoading: isWaiting(LoginAction) || isWaiting(GoogleLoginAction) || isWaiting(AppleLoginAction),
      );
}

class ViewModel extends Vm {
  ViewModel({
    required this.registerUser,
    required this.loginUser,
    required this.googleLogin,
    required this.appleLogin,
    required this.isLoading,
  });

  final Function(RegisterRequest registerRequest) registerUser;
  final Function(LoginRequest loginRequest) loginUser;
  final VoidCallback googleLogin;
  final VoidCallback appleLogin;
  final bool isLoading;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          registerUser == other.registerUser &&
          loginUser == other.loginUser &&
          googleLogin == other.googleLogin &&
          appleLogin == other.appleLogin &&
          isLoading == other.isLoading;

  @override
  int get hashCode =>
      super.hashCode ^
      registerUser.hashCode ^
      loginUser.hashCode ^
      googleLogin.hashCode ^
      appleLogin.hashCode ^
      isLoading.hashCode;
}
