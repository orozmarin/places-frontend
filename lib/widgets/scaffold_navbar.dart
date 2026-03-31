import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastrorate/theme/my_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onAddPlace,
  });
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onAddPlace;

  // Map branch index (0–3) to visual index (0–4, skipping 2 for the "+" button)
  int _branchToVisualIndex(int branch) => branch < 2 ? branch : branch + 1;

  @override
  Widget build(BuildContext context) {
    final int visualIndex = _branchToVisualIndex(selectedIndex);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: body,
      bottomNavigationBar: Container(
        color: MyColors.backgroundNavBarColor,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              15, 15, 15, 15 + MediaQuery.of(context).padding.bottom),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                visualIndex: 0,
                currentVisualIndex: visualIndex,
                icon: CupertinoIcons.home,
                label: 'Home',
                onTap: () => onDestinationSelected(0),
              ),
              _buildNavItem(
                visualIndex: 1,
                currentVisualIndex: visualIndex,
                icon: CupertinoIcons.map_pin_ellipse,
                label: 'Places',
                onTap: () => onDestinationSelected(1),
              ),
              _buildAddButton(),
              _buildNavItem(
                visualIndex: 3,
                currentVisualIndex: visualIndex,
                icon: CupertinoIcons.heart_fill,
                label: 'Favorites',
                onTap: () => onDestinationSelected(2),
              ),
              _buildNavItem(
                visualIndex: 4,
                currentVisualIndex: visualIndex,
                icon: CupertinoIcons.settings,
                label: 'Settings',
                onTap: () => onDestinationSelected(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int visualIndex,
    required int currentVisualIndex,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final bool isActive = visualIndex == currentVisualIndex;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? MyColors.activeItemColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: MyColors.navbarItemColor,
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.outfit(
                  textStyle: const TextStyle(color: MyColors.navbarItemColor),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: onAddPlace,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: MyColors.primaryDarkColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black12),
        ),
        child: const Icon(
          CupertinoIcons.add,
          color: MyColors.navbarItemColor,
        ),
      ),
    );
  }
}
