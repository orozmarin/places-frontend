import 'package:flutter/material.dart';
import 'package:gastrorate/router.dart';
import 'package:go_router/go_router.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    super.key,
    this.borderColor,
    this.imageUrl,
    this.size,
    this.initials,
    this.textStyle,
    this.backgroundColor,
    this.onEdit,
  });

  final String? imageUrl;
  final Color? borderColor;
  final double? size;
  final String? initials;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final VoidCallback? onEdit;

  double get _avatarSize => size ?? 72.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () {
            GoRouter.of(rootNavigatorKey.currentContext!).go('/profile');
          },
          child: _renderAvatar(),
        ),
        if (onEdit != null)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEdit,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.edit,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _renderAvatar() {
    if (imageUrl == null) {
      return Container(
        width: _avatarSize,
        height: _avatarSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor ?? Colors.grey.shade300, width: 2),
          image: const DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/mock_profile_pic.png"),
          ),
        ),
      );
    } else if (initials != null) {
      return Container(
        width: _avatarSize,
        height: _avatarSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor ?? Colors.grey.shade300,
          border: Border.all(color: borderColor ?? Colors.grey.shade300, width: 2),
        ),
        child: Center(
          child: Text(
            initials!,
            style: textStyle ??
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      return Container(
        width: _avatarSize,
        height: _avatarSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor ?? Colors.grey.shade300, width: 2),
        ),
        child: const Icon(Icons.person, size: 40, color: Colors.grey),
      );
    }
  }
}
