
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:gastrorate/store/auth/auth_state.dart';
import 'package:gastrorate/store/friendships/friendships_state.dart';
import 'package:gastrorate/store/invitations/invitations_state.dart';
import 'package:gastrorate/store/places/places_state.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_state.g.dart';

@CopyWith()
@JsonSerializable()
class AppState {
  final PlacesState placesState;
  final AuthState authState;
  final InvitationsState invitationsState;
  final FriendshipsState friendshipsState;

  static Future<AppState> init() async {
    final auth = await AuthState.init();
    final places = PlacesState.init();
    final invitations = InvitationsState.init();
    final friendships = FriendshipsState.init();

    return AppState(
      authState: auth,
      placesState: places,
      invitationsState: invitations,
      friendshipsState: friendships,
    );
  }

  factory AppState.fromJson(Map<String, dynamic> json) => _$AppStateFromJson(json);

  Map<String, dynamic> toJson() => _$AppStateToJson(this);

//<editor-fold desc="Data Methods">
  const AppState({
    required this.placesState,
    required this.authState,
    required this.invitationsState,
    required this.friendshipsState,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppState &&
          runtimeType == other.runtimeType &&
          placesState == other.placesState &&
          authState == other.authState &&
          invitationsState == other.invitationsState &&
          friendshipsState == other.friendshipsState);

  @override
  int get hashCode =>
      placesState.hashCode ^
      authState.hashCode ^
      invitationsState.hashCode ^
      friendshipsState.hashCode;

  @override
  String toString() {
    return 'AppState{' +
        ' placesState: $placesState,' +
        ' authState: $authState,' +
        ' invitationsState: $invitationsState,' +
        ' friendshipsState: $friendshipsState,' +
        '}';
  }

  AppState copyWith({
    PlacesState? placesState,
    AuthState? authState,
    InvitationsState? invitationsState,
    FriendshipsState? friendshipsState,
  }) {
    return AppState(
      placesState: placesState ?? this.placesState,
      authState: authState ?? this.authState,
      invitationsState: invitationsState ?? this.invitationsState,
      friendshipsState: friendshipsState ?? this.friendshipsState,
    );
  }

  Map<String, dynamic> toMap({
    String Function(String key)? keyMapper,
  }) {
    keyMapper ??= (key) => key;

    return {
      keyMapper('placesState'): this.placesState,
      keyMapper('authState'): this.authState,
      keyMapper('invitationsState'): this.invitationsState,
      keyMapper('friendshipsState'): this.friendshipsState,
    };
  }

  factory AppState.fromMap(
    Map<String, dynamic> map, {
    String Function(String key)? keyMapper,
  }) {
    keyMapper ??= (key) => key;

    return AppState(
      placesState: map[keyMapper('placesState')] as PlacesState,
      authState: map[keyMapper('authState')] as AuthState,
      invitationsState: map[keyMapper('invitationsState')] as InvitationsState,
      friendshipsState: map[keyMapper('friendshipsState')] as FriendshipsState,
    );
  }

//</editor-fold>
}
