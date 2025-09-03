import 'package:flutter/material.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/custom_app_bar.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.logOut, required this.user});

  final Function() logOut;
  final User user;

  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _getInitials(User user) {
    final first = user.firstName?.isNotEmpty == true ? user.firstName![0] : "";
    final last = user.lastName?.isNotEmpty == true ? user.lastName![0] : "";
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const CustomText("My Profile", style: TextStyle(color: MyColors.navbarItemColor)),
        backgroundColor: MyColors.appbarColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage: (widget.user.profileImageUrl != null)
                    ? NetworkImage(widget.user.profileImageUrl!)
                    : null,
                child: (widget.user.profileImageUrl == null)
                    ? CustomText(
                  _getInitials(widget.user),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )
                    : null,
              ),
            ),
            const VerticalSpacer(16),
            CustomText(
              widget.user.getFullName(),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const VerticalSpacer(4),
            CustomText(
              widget.user.email ?? "",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const VerticalSpacer(30),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Column(
                children: [
                  _buildProfileOption(
                    icon: Icons.person,
                    title: "Edit Profile",
                    onTap: () {
                      // TODO: otvori edit profile screen
                    },
                  ),
                  _buildProfileOption(
                    icon: Icons.lock,
                    title: "Change Password",
                    onTap: () {
                      // TODO: change password
                    },
                  ),
                  _buildProfileOption(
                    icon: Icons.settings,
                    title: "Settings",
                    onTap: () {
                      // TODO: settings
                    },
                  ),
                  _buildProfileOption(
                    icon: Icons.logout,
                    title: "Log out",
                    textColor: Colors.red,
                    iconColor: Colors.red,
                    onTap: widget.logOut,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white, // pozadina koja se uklapa s UI-jem, možeš promijeniti
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1), // lagani obrub
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // sjenka
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3), // pomak sjenke
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? MyColors.navbarItemColor),
        title: CustomText(title, style: TextStyle(color: textColor ?? Colors.black)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

}
