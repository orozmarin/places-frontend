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
      ),
    );
  }
}

class Factory extends VmFactory<AppState, LoginPage, ViewModel> {
  Factory(LoginPage widget) : super(widget);

  @override
  ViewModel? fromStore() => ViewModel(
        (RegisterRequest registerRequest) => dispatch(RegisterAction(registerRequest)),
        (LoginRequest loginRequest) => dispatch(LoginAction(loginRequest)),
      );
}

class ViewModel extends Vm {
  ViewModel(this.registerUser, this.loginUser);

  final Function(RegisterRequest registerRequest) registerUser;
  final Function(LoginRequest loginRequest) loginUser;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          registerUser == other.registerUser &&
          loginUser == other.loginUser;

  @override
  int get hashCode => super.hashCode ^ registerUser.hashCode ^ loginUser.hashCode;
}
