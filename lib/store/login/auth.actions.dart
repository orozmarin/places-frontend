import 'package:async_redux/async_redux.dart';
import 'package:gastrorate/http/auth_helper.dart';
import 'package:gastrorate/models/auth/auth_response.dart';
import 'package:gastrorate/models/auth/login_request.dart';
import 'package:gastrorate/models/auth/register_request.dart';
import 'package:gastrorate/service/auth_manager.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginAction extends ReduxAction<AppState>{
  LoginAction(this.payload);
  final LoginRequest payload;

  @override
  Future<AppState?> reduce() async{
    AuthResponse authResponse = await AuthManager().login(payload);
    dispatch(LoginSuccessAction(payload: authResponse));

    return null;
  }
}

class LoginSuccessAction extends ReduxAction<AppState>{
  LoginSuccessAction({required this.payload});
  AuthResponse payload;

  @override
  Future<AppState?> reduce() async{
    await AuthHelper.storeToken(payload.token!);
    return null;
  }
}

class RegisterAction extends ReduxAction<AppState>{
  RegisterAction(this.payload);
  final RegisterRequest payload;

  @override
  Future<AppState?> reduce() async{
    await AuthManager().register(payload);

    return null;
  }
}

class LogoutAction extends ReduxAction<AppState>{
  LogoutAction();

  @override
  Future<AppState?> reduce() async{
    //TODO need to implement this
    await AuthHelper.removeToken();
    return null;
  }
}