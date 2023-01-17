import 'package:bread/components/bread_main_view_tab.dart';
import 'package:bread/services/settings/settings_controller.dart';
import 'package:bread/services/tasks/task_controller.dart';
import 'package:bread/services/tasks/tasks_service.dart';
import 'package:flutter/material.dart';

class TodaysTasks extends StatelessWidget implements BreadMainViewTab {
  final TaskController taskController;
  final SettingsController settingsController;

  TodaysTasks({
    super.key,
    required this.settingsController,
    TaskService? taskService,
  }) : taskController =
            TaskController(taskService: taskService ?? SQLiteTaskService()) {
    taskController.filter.breaded = true;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      AnimatedBuilder(
          animation: taskController,
          builder: (context, child) {
            if (taskController.allTasksLoaded && taskController.tasks.isEmpty) {
              return const Center(child: Text("No tasks!"));
            }
            return ListView.builder(
                itemBuilder: ((context, index) {
                  if (index < taskController.tasks.length) {
                    return ListTile(
                      title: Text(taskController.tasks[index].description),
                      trailing: Checkbox(
                        value: taskController.tasks[index].isCompleted,
                        onChanged: (value) {
                          taskController.tasks[index].isCompleted = value!;
                          taskController
                              .updateTask(taskController.tasks[index]);
                        },
                      ),
                    );
                  }
                  taskController.loadMoreTasks();
                  return const Center(child: CircularProgressIndicator());
                }),
                itemCount: taskController.tasks.length +
                    (!taskController.allTasksLoaded ? 1 : 0));
          }),
      Align(
          alignment: Alignment.bottomCenter,
          child: Row(children: [
            const Spacer(),
            Card(
                child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(Icons.timelapse),
                        ),
                        const Text("Clearing in 30 minutes"),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Edit"),
                        )
                      ],
                    )),
            const Spacer(),
          ])),
    ]);
  }

  @override
  Widget? get floatingActionButton => null;

  @override
  Icon get icon => const Icon(Icons.breakfast_dining);

  @override
  String get label => "Today's Bread";
}
