import 'package:bread/services/settings/settings_controller.dart';
import 'package:bread/services/tasks/task_controller.dart';
import 'package:bread/services/tasks/tasks_service.dart';
import 'package:flutter/material.dart';

class AllTasks extends StatelessWidget {
  final TaskController taskController;
  final SettingsController settingsController;

  AllTasks({
    super.key,
    required this.settingsController,
    TaskService? taskService,
  }) : taskController =
            TaskController(taskService: taskService ?? SQLiteTaskService());

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: taskController,
        builder: (context, child) {
          if (taskController.allTasksLoaded && taskController.tasks.isEmpty) {
            return const Center(child: Text("No tasks!"));
          }
          return ListView.builder(
            itemBuilder: ((context, index) {
              if (index < taskController.tasks.length) {
                return Text(taskController.tasks[index].description);
              }
              taskController.loadMoreTasks();
              return const Center(child: CircularProgressIndicator());
            }),
            itemCount: taskController.tasks.length +
                (!taskController.allTasksLoaded ? 1 : 0),
          );
        });
  }
}
