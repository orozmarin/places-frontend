import 'package:gastrorate/http/auth_helper.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_state.g.dart';

@JsonSerializable(explicitToJson: true)
class AuthState {
  User? loggedUser;

  static Future<AuthState> init() async {
    final user = await AuthHelper.getUser();
    return AuthState(loggedUser: user);
  }

  factory AuthState.fromJson(Map<String, dynamic> json) => _$AuthStateFromJson(json);

  Map<String, dynamic> toJson() => _$AuthStateToJson(this);

//<editor-fold desc="Data Methods">
  AuthState({
    this.loggedUser,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthState && runtimeType == other.runtimeType && loggedUser == other.loggedUser);

  @override
  int get hashCode => loggedUser.hashCode;

  @override
  String toString() {
    return 'PlacesState{' + ' loggedUser: $loggedUser,' + '}';
  }

  AuthState copyWith({
    User? loggedUser,
  }) {
    return AuthState(
      loggedUser: loggedUser ?? this.loggedUser,
    );
  }

  Map<String, dynamic> toMap({
    String Function(String key)? keyMapper,
  }) {
    keyMapper ??= (key) => key;

    return {
      keyMapper('loggedUser'): this.loggedUser,
    };
  }

  factory AuthState.fromMap(
    Map<String, dynamic> map, {
    String Function(String key)? keyMapper,
  }) {
    keyMapper ??= (key) => key;

    return AuthState(
      loggedUser: map[keyMapper('loggedUser')] as User,
    );
  }

//</editor-fold>
}
