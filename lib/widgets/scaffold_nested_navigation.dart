import 'package:flutter/material.dart';
import 'package:gastrorate/widgets/scaffold_navbar.dart';
import 'package:gastrorate/widgets/scaffold_navrail.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNestedNavigation extends StatefulWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(key: key);

  final StatefulNavigationShell navigationShell;

  @override
  State<ScaffoldWithNestedNavigation> createState() =>
      _ScaffoldWithNestedNavigationState();
}

class _ScaffoldWithNestedNavigationState
    extends State<ScaffoldWithNestedNavigation> {
  int _lastSelectedIndex = 0;
  Key _bodyKey = UniqueKey();

  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );

    if (index != _lastSelectedIndex) {
      setState(() {
        _lastSelectedIndex = index;
        _bodyKey = UniqueKey(); // Force rebuild
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = KeyedSubtree(
      key: _bodyKey,
      child: widget.navigationShell,
    );

    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 450) {
        return ScaffoldWithNavigationBar(
          body: body,
          selectedIndex: widget.navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
        );
      } else {
        return ScaffoldWithNavigationRail(
          body: body,
          selectedIndex: widget.navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
        );
      }
    });
  }
}
