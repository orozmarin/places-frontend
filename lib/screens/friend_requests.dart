import 'package:flutter/material.dart';
import 'package:gastrorate/models/friend_request_dto.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/custom_app_bar.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';

class FriendRequests extends StatelessWidget {
  const FriendRequests({
    super.key,
    required this.allRequests,
    required this.onAccept,
    required this.onDecline,
  });

  final List<FriendRequestDto>? allRequests;
  final Function(String friendshipId) onAccept;
  final Function(String friendshipId) onDecline;

  @override
  Widget build(BuildContext context) {
    final pending = allRequests?.where((r) => r.status == 'PENDING').toList() ?? [];
    final past = allRequests?.where((r) => r.status != 'PENDING').toList() ?? [];

    return Scaffold(
      appBar: CustomAppBar(
        title: const CustomText(
          "Friend Requests",
          style: TextStyle(color: MyColors.navbarItemColor),
        ),
        backgroundColor: MyColors.appbarColor,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (pending.isNotEmpty) ...[
            CustomText(
              "Pending",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const VerticalSpacer(8),
            ...pending.map((req) => _buildRequestTile(context, req, showActions: true)),
            const VerticalSpacer(16),
          ],
          if (past.isNotEmpty) ...[
            CustomText(
              "History",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const VerticalSpacer(8),
            ...past.map((req) => _buildRequestTile(context, req, showActions: false)),
          ],
          if (pending.isEmpty && past.isEmpty)
            const Center(child: CustomText("No friend requests")),
        ],
      ),
      ),
    );
  }

  Widget _buildRequestTile(BuildContext context, FriendRequestDto req,
      {required bool showActions}) {
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
                  if (showActions) ...[
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
                ],
              ),
            ),
            if (!showActions) ...[
              const SizedBox(width: 8),
              _statusChip(req.status),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String? status) {
    Color color;
    switch (status) {
      case 'ACCEPTED':
        color = Colors.green;
        break;
      case 'DECLINED':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        status ?? '',
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
