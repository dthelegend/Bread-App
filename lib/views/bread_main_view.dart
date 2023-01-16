import 'package:bread/components/bread_all_tasks.dart';
import 'package:bread/components/bread_bottom_navigation_bar.dart';
import 'package:bread/components/bread_options.dart';
import 'package:bread/components/bread_todays_tasks.dart';
import 'package:bread/services/settings/settings_controller.dart';
import 'package:bread/services/tasks/task_controller.dart';
import 'package:bread/services/tasks/tasks_service.dart';
import 'package:flutter/material.dart';

class BreadMainView extends StatefulWidget {
  const BreadMainView({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  State<BreadMainView> createState() => _BreadMainViewState();
}

class _BreadMainViewState extends State<BreadMainView> {
  int index = 1;

  final TaskService taskService = SQLiteTaskService();

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
          AllTasks(
            settingsController:widget.settingsController,
            taskService: taskService,
          ),
          TodaysTasks(
            settingsController: widget.settingsController,
            taskService: taskService,
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
