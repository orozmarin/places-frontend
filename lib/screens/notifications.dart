import 'package:flutter/material.dart';
import 'package:gastrorate/models/friend_request_dto.dart';
import 'package:gastrorate/models/visit_invitation.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/custom_app_bar.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';

class Notifications extends StatelessWidget {
  const Notifications({
    super.key,
    required this.pendingRequests,
    required this.pendingInvitations,
    required this.onAccept,
    required this.onDecline,
    required this.onAcceptInvitation,
    required this.onDeclineInvitation,
  });

  final List<FriendRequestDto>? pendingRequests;
  final List<VisitInvitation> pendingInvitations;
  final Function(String friendshipId) onAccept;
  final Function(String friendshipId) onDecline;
  final Function(String invitationId) onAcceptInvitation;
  final Function(String invitationId) onDeclineInvitation;

  @override
  Widget build(BuildContext context) {
    final pending = pendingRequests
            ?.where((r) => r.status == 'PENDING')
            .toList() ??
        [];
    final hasContent = pending.isNotEmpty || pendingInvitations.isNotEmpty;

    return Scaffold(
      appBar: CustomAppBar(
        title: const CustomText(
          "Notifications",
          style: TextStyle(color: MyColors.navbarItemColor),
        ),
        backgroundColor: MyColors.appbarColor,
      ),
      body: SafeArea(
        top: false,
        child: !hasContent
          ? const Center(child: CustomText("No new notifications"))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (pending.isNotEmpty) ...[
                  CustomText(
                    "Friend Requests",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const VerticalSpacer(8),
                  ...pending.map((req) => _FriendRequestCard(
                        req: req,
                        onAccept: onAccept,
                        onDecline: onDecline,
                      )),
                  const VerticalSpacer(8),
                ],
                if (pendingInvitations.isNotEmpty) ...[
                  CustomText(
                    "Visit Invitations",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const VerticalSpacer(8),
                  ...pendingInvitations.map((inv) => _VisitInvitationCard(
                        invitation: inv,
                        onAccept: onAcceptInvitation,
                        onDecline: onDeclineInvitation,
                      )),
                ],
              ],
            ),
      ),
    );
  }
}

class _FriendRequestCard extends StatelessWidget {
  const _FriendRequestCard({
    required this.req,
    required this.onAccept,
    required this.onDecline,
  });

  final FriendRequestDto req;
  final Function(String) onAccept;
  final Function(String) onDecline;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: req.requesterProfileImageUrl != null
                  ? NetworkImage(req.requesterProfileImageUrl!)
                  : null,
              child: req.requesterProfileImageUrl == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    req.requesterName ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  if (req.requesterUsername != null || req.requesterTag != null)
                    CustomText(
                      '@${req.requesterUsername ?? ''}#${req.requesterTag ?? ''}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () => onAccept(req.friendshipId!),
                          child: const Text("Accept"),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                          onPressed: () => onDecline(req.friendshipId!),
                          child: const Text("Decline"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VisitInvitationCard extends StatelessWidget {
  const _VisitInvitationCard({
    required this.invitation,
    required this.onAccept,
    required this.onDecline,
  });

  final VisitInvitation invitation;
  final Function(String) onAccept;
  final Function(String) onDecline;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: invitation.inviterProfileImageUrl != null
                  ? NetworkImage(invitation.inviterProfileImageUrl!)
                  : null,
              child: invitation.inviterProfileImageUrl == null
                  ? const Icon(Icons.restaurant)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    invitation.placeName ?? 'Unknown place',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  CustomText(
                    'Invited by ${invitation.inviterName ?? invitation.inviterId ?? ''}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () => onAccept(invitation.id!),
                          child: const Text("Accept"),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                          onPressed: () => onDecline(invitation.id!),
                          child: const Text("Decline"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
