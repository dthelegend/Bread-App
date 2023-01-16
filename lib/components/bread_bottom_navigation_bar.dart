import 'package:flutter/material.dart';

class BreadBottomNavigationBar extends BottomNavigationBar {
  BreadBottomNavigationBar({
    super.key,
    super.currentIndex,
    super.onTap,
    super.items = const [
      BottomNavigationBarItem(icon: Icon(Icons.all_inclusive), label: "All Tasks"),
      BottomNavigationBarItem(icon: Icon(Icons.breakfast_dining), label: "Today's Bread"),
      BottomNavigationBarItem(icon: Icon(Icons.timelapse), label: "Options"),
    ],
  });
}
