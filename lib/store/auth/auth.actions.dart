import 'package:async_redux/async_redux.dart';
import 'package:gastrorate/http/auth_helper.dart';
import 'package:gastrorate/models/auth/auth_response.dart';
import 'package:gastrorate/models/auth/login_request.dart';
import 'package:gastrorate/models/auth/register_request.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/router.dart';
import 'package:gastrorate/service/auth_manager.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/tools/toast_helper.dart';
import 'package:go_router/go_router.dart';

class LoginAction extends ReduxAction<AppState>{
  LoginAction(this.payload);
  final LoginRequest payload;

  @override
  Future<AppState?> reduce() async{
    AuthResponse? authResponse = await AuthManager().login(payload);
    if (authResponse != null) {
      dispatch(LoginSuccessAction(payload: authResponse));
      GoRouter.of(rootNavigatorKey.currentContext!).go('/home');
    } else {
      toastHelperMobile.showToastError("Login failed. Please check your credentials.");
    }

    return null;
  }
}

class LoginSuccessAction extends ReduxAction<AppState>{
  LoginSuccessAction({required this.payload});
  AuthResponse payload;

  @override
  Future<AppState?> reduce() async{
    await AuthHelper.storeToken(payload.token!);
    await AuthHelper.storeUser(payload.user!);
    return state.copyWith(authState: state.authState.copyWith(loggedUser: payload.user));
  }
}

class RegisterAction extends ReduxAction<AppState>{
  RegisterAction(this.payload);
  final RegisterRequest payload;

  @override
  Future<AppState?> reduce() async{
    bool success = await AuthManager().register(payload);
    if (success) {
      toastHelperMobile.showToastSuccess("Registration successful!");
    } else {
      toastHelperMobile.showToastError("Registration unsuccessful... Please try again!");
    }
    return null;
  }
}

class LogoutAction extends ReduxAction<AppState>{
  LogoutAction();

  @override
  Future<AppState?> reduce() async{
    dispatch(LogoutSuccessAction());
    GoRouter.of(rootNavigatorKey.currentContext!).go('/login');

    return null;
  }
}

class LogoutSuccessAction extends ReduxAction<AppState> {
  LogoutSuccessAction();

  @override
  Future<AppState?> reduce() async {
    await AuthHelper.removeToken();
    await AuthHelper.removeUser();
    return state.copyWith(authState: state.authState.copyWith(loggedUser: User()));
  }
}