import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gastrorate/models/auth/user.dart';
import 'package:gastrorate/store/app_state.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:gastrorate/tools/user_helper.dart';
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
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _AppBarVm>(
      converter: (Store<AppState> store) => _AppBarVm(
        user: store.state.authState.loggedUser,
        pendingCount: store.state.friendshipsState.pendingRequests?.length ?? 0,
      ),
      builder: (context, vm) {
        return AppBar(
          key: widget.appBarKey,
          leading: widget.leading,
          automaticallyImplyLeading: widget.automaticallyImplyLeading,
          title: widget.title,
          actions: [
            ...(widget.actions ?? []),
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () => context.push('/notifications'),
                ),
                if (vm.pendingCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: CircleAvatar(
                      radius: 7,
                      backgroundColor: Colors.red,
                      child: Text(
                        '${vm.pendingCount}',
                        style: const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            UserHelper.buildUserAvatar(user: vm.user!),
          ],
          actionsPadding: const EdgeInsets.only(right: 8),
          flexibleSpace: widget.flexibleSpace,
          bottom: widget.bottom,
          elevation: widget.elevation,
          shadowColor: widget.shadowColor,
          shape: widget.shape,
          backgroundColor: widget.backgroundColor ?? MyColors.backgroundNavBarColor,
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

class _AppBarVm {
  final User? user;
  final int pendingCount;

  _AppBarVm({required this.user, required this.pendingCount});
}
