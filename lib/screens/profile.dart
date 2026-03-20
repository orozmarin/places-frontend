import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/tools/user_helper.dart';
import 'package:gastrorate/widgets/custom_app_bar.dart';
import 'package:gastrorate/widgets/custom_text.dart';
import 'package:gastrorate/widgets/vertical_spacer.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.logOut, required this.user, required this.onEditUser});

  final Function() logOut;
  final User user;
  final Function(User user) onEditUser;

  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const CustomText("My Profile", style: TextStyle(color: MyColors.navbarItemColor)),
        backgroundColor: MyColors.appbarColor,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
        child: Column(
          children: [
            Center(
              child: UserHelper.buildUserAvatar(
                  user: widget.user,
                  size: 200,
                  onEdit: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

                    if (pickedFile != null) {
                      // TODO: upload profile image
                    }
                  }),
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
            if (widget.user.tag != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '#${widget.user.tag}',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 16),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                        text: '${widget.user.username ?? ''}#${widget.user.tag}',
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tag copied!')),
                      );
                    },
                  ),
                ],
              ),
            const VerticalSpacer(30),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Column(
                children: [
                  _buildProfileOption(
                    icon: Icons.people,
                    title: "Friends",
                    onTap: () => context.push('/friends'),
                  ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
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
