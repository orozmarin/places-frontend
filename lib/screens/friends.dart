import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/custom_app_bar.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';

class Friends extends StatefulWidget {
  const Friends({
    super.key,
    required this.friends,
    required this.searchResults,
    required this.sentRequestIds,
    required this.onSendRequest,
    required this.onSearch,
    required this.onRemove,
  });

  final List<User>? friends;
  final List<User>? searchResults;
  final List<String> sentRequestIds;
  final Function(String userId) onSendRequest;
  final Function(String query) onSearch;
  final Function(String userId) onRemove;

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _normalizeQuery(String value) {
    // Strip leading # for tag search
    return value.startsWith('#') ? value.substring(1) : value;
  }

  void _showFriendInfoSheet(BuildContext context, User friend) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.of(ctx).padding.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: friend.profileImageUrl != null
                  ? NetworkImage(friend.profileImageUrl!)
                  : null,
              child: friend.profileImageUrl == null
                  ? Text(
                      friend.getUserInitials(),
                      style: const TextStyle(fontSize: 22),
                    )
                  : null,
            ),
            const VerticalSpacer(12),
            CustomText(
              friend.getFullName(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (friend.username != null || friend.tag != null)
              CustomText(
                '${friend.username ?? ''}#${friend.tag ?? ''}',
                style: const TextStyle(color: Colors.grey),
              ),
            const VerticalSpacer(24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onRemove(friend.id!);
                },
                child: const Text("Remove Friend"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const CustomText(
          "Friends",
          style: TextStyle(color: MyColors.navbarItemColor),
        ),
        backgroundColor: MyColors.appbarColor,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search by name, username or #tag...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        widget.onSearch('');
                        setState(() {});
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              widget.onSearch(_normalizeQuery(value));
              setState(() {});
            },
          ),
          const VerticalSpacer(12),

          // Friend Requests button
          OutlinedButton.icon(
            icon: const Icon(Icons.person_add_outlined),
            label: const Text("Friend Requests"),
            onPressed: () => context.push('/friend-requests'),
          ),
          const VerticalSpacer(16),

          // Search results
          if (widget.searchResults != null && widget.searchResults!.isNotEmpty) ...[
            CustomText(
              "Search Results",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const VerticalSpacer(8),
            ...widget.searchResults!.map((user) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.profileImageUrl != null
                        ? NetworkImage(user.profileImageUrl!)
                        : null,
                    child: user.profileImageUrl == null
                        ? Text(user.getUserInitials())
                        : null,
                  ),
                  title: CustomText(user.getFullName()),
                  subtitle: user.username != null || user.tag != null
                      ? CustomText(
                          '${user.username ?? ''}#${user.tag ?? ''}',
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      : CustomText(
                          user.email ?? '',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                  trailing: (widget.friends?.any((f) => f.id == user.id) ?? false)
                      ? OutlinedButton(
                          onPressed: null,
                          child: const Text("Friends"),
                        )
                      : widget.sentRequestIds.contains(user.id)
                          ? OutlinedButton(
                              onPressed: null,
                              child: const Text("Sent"),
                            )
                          : OutlinedButton(
                              onPressed: () => widget.onSendRequest(user.id!),
                              child: const Text("Add"),
                            ),
                )),
            const VerticalSpacer(16),
          ],

          // Friends list
          CustomText(
            "Friends (${widget.friends?.length ?? 0})",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const VerticalSpacer(8),
          if (widget.friends == null || widget.friends!.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CustomText("No friends yet.")),
            )
          else
            ...widget.friends!.map((user) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.profileImageUrl != null
                        ? NetworkImage(user.profileImageUrl!)
                        : null,
                    child: user.profileImageUrl == null
                        ? Text(user.getUserInitials())
                        : null,
                  ),
                  title: CustomText(user.getFullName()),
                  subtitle: user.username != null || user.tag != null
                      ? CustomText(
                          '${user.username ?? ''}#${user.tag ?? ''}',
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () => _showFriendInfoSheet(context, user),
                  ),
                )),
        ],
      ),
      ),
    );
  }
}
