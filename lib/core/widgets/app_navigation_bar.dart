import 'package:flutter/material.dart';

class NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  const NavItem(this.icon, this.selectedIcon, this.label);
}

/// AppNavigationBar — NavigationBar (M3). Truyền currentIndex + onTap.
/// Ví dụ:
/// AppNavigationBar(
///   items: const [NavItem(Icons.home, 'Trang chủ'), ...],
///   currentIndex: index,
///   onTap: (i) => setState(() => index = i),
/// )
class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      indicatorColor: Colors.transparent,
      elevation: 0,
      backgroundColor: cs.surface,
      destinations: [
        for (int i = 0; i < items.length; i++)
          NavigationDestination(
            icon: Icon(items[i].icon, color: cs.outline),
            selectedIcon: Icon(items[i].selectedIcon, color: cs.primary),
            label: items[i].label,
          ),
      ],
    );
  }
}
