import 'package:bread/components/bread_main_view_tab.dart';
import 'package:flutter/material.dart';

class BreadBottomNavigationBar extends StatelessWidget {
  const BreadBottomNavigationBar({
    super.key,
    this.currentIndex = 0,
    this.onTap,
    required this.tabs,
  });

  final int currentIndex;
  final void Function(int)? onTap;
  final List<BreadMainViewTab> tabs;

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: tabs
          .map((tab) =>
              BottomNavigationBarItem(icon: tab.icon, label: tab.label))
          .toList(),
    );
}
