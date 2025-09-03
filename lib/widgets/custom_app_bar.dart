import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/router.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Key? appBarKey;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Widget? title;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final Color? shadowColor;
  final ShapeBorder? shape;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Brightness? brightness;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final bool primary;
  final bool? centerTitle;
  final bool excludeHeaderSemantics;
  final double? titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  final double? toolbarHeight;
  final double? leadingWidth;
  final TextStyle? titleTextStyle;
  final TextStyle? toolbarTextStyle;
  final SystemUiOverlayStyle? systemOverlayStyle;

  CustomAppBar({
    super.key,
    this.appBarKey,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.shadowColor,
    this.shape,
    this.backgroundColor,
    this.foregroundColor,
    this.brightness,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.toolbarHeight,
    this.leadingWidth,
    this.titleTextStyle,
    this.toolbarTextStyle,
    this.systemOverlayStyle,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize =>
      Size.fromHeight(toolbarHeight ?? kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}

class _CustomAppBarState extends State<CustomAppBar> {
  String _getInitials(User user) {
    final first = user.firstName?.isNotEmpty == true ? user.firstName![0] : "";
    final last = user.lastName?.isNotEmpty == true ? user.lastName![0] : "";
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, User?>(
      converter: (Store<AppState> store) => store.state.authState.loggedUser,
      builder: (context, user) {
        return AppBar(
          key: widget.appBarKey,
          leading: widget.leading,
          automaticallyImplyLeading: widget.automaticallyImplyLeading,
          title: widget.title,
          actions: [
            ...(widget.actions ?? []),
            GestureDetector(
              onTap: () {
                GoRouter.of(rootNavigatorKey.currentContext!).go('/profile');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  backgroundImage: (user?.profileImageUrl != null)
                      ? NetworkImage(user!.profileImageUrl!)
                      : null,
                  child: (user?.profileImageUrl == null)
                      ? Text(
                    _getInitials(user ?? User()),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                      : null,
                ),
              ),
            ),
          ],
          flexibleSpace: widget.flexibleSpace,
          bottom: widget.bottom,
          elevation: widget.elevation,
          shadowColor: widget.shadowColor,
          shape: widget.shape,
          backgroundColor: MyColors.backgroundNavBarColor,
          foregroundColor: widget.foregroundColor,
          iconTheme: widget.iconTheme,
          actionsIconTheme: widget.actionsIconTheme,
          primary: widget.primary,
          centerTitle: widget.centerTitle,
          excludeHeaderSemantics: widget.excludeHeaderSemantics,
          titleSpacing: widget.titleSpacing,
          toolbarOpacity: widget.toolbarOpacity,
          bottomOpacity: widget.bottomOpacity,
          toolbarHeight: widget.toolbarHeight,
          leadingWidth: widget.leadingWidth,
          titleTextStyle: widget.titleTextStyle,
          toolbarTextStyle: widget.toolbarTextStyle,
          systemOverlayStyle: widget.systemOverlayStyle,
        );
      },
    );
  }
}
