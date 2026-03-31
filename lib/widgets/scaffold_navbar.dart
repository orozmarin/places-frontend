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

  // Visual indices: 0=Home, 1=Places, 2=+(center), 3=Favorites, 4=Settings
  // Branch indices: 0=Home, 1=Places, 2=Favorites, 3=Settings
  int _visualToBranch(int visual) => visual < 2 ? visual : visual - 1;
  int _branchToVisual(int branch) => branch < 2 ? branch : branch + 1;

  @override
  Widget build(BuildContext context) {
    final int visualSelected = _branchToVisual(selectedIndex);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: body,
      bottomNavigationBar: Container(
        color: MyColors.backgroundNavBarColor,
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 15 + MediaQuery.of(context).padding.bottom),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(CupertinoIcons.home, "Home", 0, visualSelected),
              _buildNavItem(CupertinoIcons.map_pin_ellipse, "Places", 1, visualSelected),
              _buildAddButton(),
              _buildNavItem(CupertinoIcons.heart_fill, "Favorites", 3, visualSelected),
              _buildNavItem(CupertinoIcons.settings, "Settings", 4, visualSelected),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int visualIndex, int visualSelected) {
    final bool isActive = visualIndex == visualSelected;
    return GestureDetector(
      onTap: () => onDestinationSelected(_visualToBranch(visualIndex)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? MyColors.activeItemColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: MyColors.navbarItemColor, size: 24),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(label, style: GoogleFonts.outfit(color: MyColors.navbarItemColor)),
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
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: MyColors.primaryDarkColor,
          shape: BoxShape.circle,
          border: Border.all(color: MyColors.navbarItemColor, width: 2),
        ),
        child: const Icon(Icons.add, color: MyColors.navbarItemColor, size: 28),
      ),
    );
  }
}
