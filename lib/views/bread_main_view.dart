import 'package:bread/components/bread_all_tasks.dart';
import 'package:bread/components/bread_bottom_navigation_bar.dart';
import 'package:bread/components/bread_options.dart';
import 'package:bread/components/bread_todays_tasks.dart';
import 'package:bread/services/settings/settings_controller.dart';
import 'package:flutter/material.dart';

class BreadMainView extends StatefulWidget {
  const BreadMainView({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  State<BreadMainView> createState() => _BreadMainViewState();
}

class _BreadMainViewState extends State<BreadMainView> {
  int index = 1;

  void updateIndex(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: [
          AllTasks(),
          TodaysTasks(
            settingsController: widget.settingsController,
          ),
          Options(
            settingsController: widget.settingsController,
          ),
        ],
      ),
      bottomNavigationBar: BreadBottomNavigationBar(
        currentIndex: index,
        onTap: updateIndex,
      ),
    );
  }
}
