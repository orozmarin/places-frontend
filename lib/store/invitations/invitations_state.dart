import 'package:gastrorate/models/user_visit.dart';
import 'package:gastrorate/models/visit_invitation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'invitations_state.g.dart';

@JsonSerializable(explicitToJson: true)
class InvitationsState {
  List<VisitInvitation>? pendingInvitations;
  UserVisit? activeVisit;
  bool? isLoading;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? activePlaceName;

  InvitationsState.init() {
    pendingInvitations = List<VisitInvitation>.empty();
    isLoading = false;
  }

  factory InvitationsState.fromJson(Map<String, dynamic> json) =>
      _$InvitationsStateFromJson(json);
  Map<String, dynamic> toJson() => _$InvitationsStateToJson(this);

  InvitationsState({this.pendingInvitations, this.activeVisit, this.isLoading, this.activePlaceName});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvitationsState &&
          runtimeType == other.runtimeType &&
          pendingInvitations == other.pendingInvitations &&
          activeVisit == other.activeVisit &&
          isLoading == other.isLoading);

  @override
  int get hashCode =>
      pendingInvitations.hashCode ^ activeVisit.hashCode ^ isLoading.hashCode;

  @override
  String toString() =>
      'InvitationsState{ pendingInvitations: $pendingInvitations, activeVisit: $activeVisit, isLoading: $isLoading }';

  InvitationsState copyWith({
    List<VisitInvitation>? pendingInvitations,
    UserVisit? activeVisit,
    bool? isLoading,
    String? activePlaceName,
  }) {
    return InvitationsState(
      pendingInvitations: pendingInvitations ?? this.pendingInvitations,
      activeVisit: activeVisit ?? this.activeVisit,
      isLoading: isLoading ?? this.isLoading,
      activePlaceName: activePlaceName ?? this.activePlaceName,
    );
  }
}
