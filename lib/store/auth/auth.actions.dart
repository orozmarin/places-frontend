import 'package:async_redux/async_redux.dart';
import 'package:gastrorate/http/auth_helper.dart';
import 'package:gastrorate/models/auth/auth_response.dart';
import 'package:gastrorate/models/auth/login_request.dart';
import 'package:gastrorate/models/auth/register_request.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/router.dart';
import 'package:gastrorate/service/auth_manager.dart';
import 'package:gastrorate/store/app_action.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/store/friendships/friendships_actions.dart';
import 'package:gastrorate/store/invitations/invitations_actions.dart';
import 'package:gastrorate/store/places/places_actions.dart';
import 'package:gastrorate/tools/toast_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginAction extends AppAction {
  LoginAction(this.payload);
  final LoginRequest payload;

  @override
  Future<AppState?> reduce() async{
    AuthResponse? authResponse = await AuthManager().login(payload);
    if (authResponse != null) {
      await dispatchAndWait(LoginSuccessAction(payload: authResponse));
      final userId = authResponse.user!.id!;
      dispatch(FetchPendingFriendRequestsAction());
      dispatch(FetchFriendsAction(userId));
      dispatch(FetchPendingInvitationsAction(userId));
      await dispatchAndWait(FetchPlacesAction());
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

class RegisterAction extends AppAction {
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

class GoogleLoginAction extends AppAction {
  GoogleLoginAction();

  @override
  Future<AppState?> reduce() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account == null) return null;

      final GoogleSignInAuthentication auth = await account.authentication;
      final String? idToken = auth.idToken;
      if (idToken == null) {
        toastHelperMobile.showToastError("Google sign-in failed. Please try again.");
        return null;
      }

      AuthResponse? authResponse = await AuthManager().googleLogin(idToken);
      if (authResponse != null) {
        await dispatchAndWait(LoginSuccessAction(payload: authResponse));
        final userId = authResponse.user!.id!;
        dispatch(FetchPendingFriendRequestsAction());
        dispatch(FetchFriendsAction(userId));
        dispatch(FetchPendingInvitationsAction(userId));
        await dispatchAndWait(FetchPlacesAction());
        GoRouter.of(rootNavigatorKey.currentContext!).go('/home');
      } else {
        toastHelperMobile.showToastError("Google login failed. Please try again.");
      }
    } catch (e) {
      toastHelperMobile.showToastError("Google login failed: $e");
    }
    return null;
  }
}

class AppleLoginAction extends AppAction {
  AppleLoginAction();

  @override
  Future<AppState?> reduce() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final String? idToken = credential.identityToken;
      if (idToken == null) {
        toastHelperMobile.showToastError("Apple sign-in failed. Please try again.");
        return null;
      }

      AuthResponse? authResponse = await AuthManager().appleLogin(idToken);
      if (authResponse != null) {
        await dispatchAndWait(LoginSuccessAction(payload: authResponse));
        final userId = authResponse.user!.id!;
        dispatch(FetchPendingFriendRequestsAction());
        dispatch(FetchFriendsAction(userId));
        dispatch(FetchPendingInvitationsAction(userId));
        await dispatchAndWait(FetchPlacesAction());
        GoRouter.of(rootNavigatorKey.currentContext!).go('/home');
      } else {
        toastHelperMobile.showToastError("Apple login failed. Please try again.");
      }
    } catch (e) {
      toastHelperMobile.showToastError("Apple login failed: $e");
    }
    return null;
  }
}

class LogoutAction extends AppAction {
  LogoutAction();

  @override
  Future<AppState?> reduce() async{
    dispatch(LogoutSuccessAction());
    GoRouter.of(rootNavigatorKey.currentContext!).go('/login');

    toastHelperMobile.showToastInfo("Looks like you’ve been away for a while. Please sign in again.", timeDisplayed: 20);
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