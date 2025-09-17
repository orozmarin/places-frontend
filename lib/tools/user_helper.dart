import 'package:flutter/material.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/widgets/avatar.dart';

class UserHelper {
  static Widget buildUserAvatar({required User user, double? size, VoidCallback? onEdit}) {
    return AvatarWidget(
      onEdit: onEdit,
      borderColor: Colors.white,
      backgroundColor: MyColors.avatarBackgroundColor,
      imageUrl: user.profileImageUrl,
      size: size ?? 36,
      initials: UserHelper.constructUserInitials(user),
      textStyle: const TextStyle(fontSize: 12, color: Colors.white),
    );
  }

  static String constructUserInitials(User user) {
    final first = user.firstName?.isNotEmpty == true ? user.firstName![0] : "";
    final last = user.lastName?.isNotEmpty == true ? user.lastName![0] : "";
    return (first + last).toUpperCase();
  }
}
