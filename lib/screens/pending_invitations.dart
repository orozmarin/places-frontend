import 'package:flutter/material.dart';
import 'package:gastrorate/models/visit_invitation.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/custom_app_bar.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/default_button.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';

class PendingInvitations extends StatelessWidget {
  const PendingInvitations({
    super.key,
    required this.invitations,
    required this.onAccept,
    required this.onDecline,
  });

  final List<VisitInvitation>? invitations;
  final Function(String invitationId) onAccept;
  final Function(String invitationId) onDecline;

  @override
  Widget build(BuildContext context) {
    final items = invitations ?? [];
    return Scaffold(
      appBar: CustomAppBar(
        title: const CustomText(
          "Pending Invitations",
          style: TextStyle(color: MyColors.navbarItemColor),
        ),
        backgroundColor: MyColors.appbarColor,
      ),
      body: items.isEmpty
          ? const Center(child: CustomText("No pending invitations."))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final invitation = items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          invitation.placeName ?? "Unknown place",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const VerticalSpacer(4),
                        CustomText(
                          "Invited by: ${invitation.inviterId ?? ''}",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const VerticalSpacer(12),
                        Row(
                          children: [
                            Expanded(
                              child: ButtonComponent.smallButton(
                                text: "Accept",
                                onPressed: () => onAccept(invitation.id!),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ButtonComponent.outlinedButtonSmall(
                                text: "Decline",
                                buttonColor: Colors.red,
                                onPressed: () => onDecline(invitation.id!),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
