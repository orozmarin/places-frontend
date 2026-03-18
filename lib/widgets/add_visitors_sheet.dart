import 'package:flutter/material.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/models/place.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/default_button.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';

class AddVisitorsSheet extends StatefulWidget {
  final Place place;
  final List<User> friends;
  final Function(String placeId, String friendId) onInvite;

  const AddVisitorsSheet({
    super.key,
    required this.place,
    required this.friends,
    required this.onInvite,
  });

  @override
  State<AddVisitorsSheet> createState() => _AddVisitorsSheetState();
}

class _AddVisitorsSheetState extends State<AddVisitorsSheet> {
  final Set<String> _selectedIds = {};

  @override
  Widget build(BuildContext context) {
    final existingUserIds = {
      if (widget.place.userId != null) widget.place.userId!,
      ...?widget.place.coVisitors?.map((cv) => cv.userId).whereType<String>(),
    };
    final availableFriends = widget.friends.where((f) => !existingUserIds.contains(f.id)).toList();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const VerticalSpacer(16),
          CustomText(
            "Add co-visitors",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const VerticalSpacer(8),
          if (availableFriends.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CustomText("No friends available to invite."),
            )
          else
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: availableFriends.length,
                itemBuilder: (context, index) {
                  final friend = availableFriends[index];
                  final isSelected = _selectedIds.contains(friend.id);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: friend.profileImageUrl != null
                          ? NetworkImage(friend.profileImageUrl!)
                          : null,
                      child: friend.profileImageUrl == null
                          ? Text(friend.getUserInitials())
                          : null,
                    ),
                    title: CustomText(friend.getFullName()),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: MyColors.primaryColor)
                        : const Icon(Icons.circle_outlined),
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedIds.remove(friend.id);
                        } else {
                          _selectedIds.add(friend.id!);
                        }
                      });
                    },
                  );
                },
              ),
            ),
          const VerticalSpacer(8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ButtonComponent(
              text: "Invite",
              isDisabled: _selectedIds.isEmpty,
              onPressed: () {
                for (final friendId in _selectedIds) {
                  widget.onInvite(widget.place.id!, friendId);
                }
                Navigator.pop(context);
              },
            ),
          ),
          const VerticalSpacer(12),
        ],
      ),
    );
  }
}
