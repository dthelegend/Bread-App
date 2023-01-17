import 'package:bread/components/bread_main_view_tab.dart';
import 'package:bread/services/bread/bread_controller.dart';
import 'package:bread/services/bread/bread_service.dart';
import 'package:bread/services/settings/settings_controller.dart';
import 'package:bread/services/tasks/tasks_service.dart';
import 'package:flutter/material.dart';

class TodaysTasks extends StatelessWidget implements BreadMainViewTab {
  final BreadController breadController;
  final SettingsController settingsController;

  TodaysTasks({
    super.key,
    required this.settingsController,
    TaskService? taskService,
    BreadService? breadService,
  }) : breadController = BreadController(
            taskService: taskService ?? SQLiteTaskService(),
            breadService: breadService ?? SharedPreferencesBreadService()) {
    breadController.filter.breaded = true;
    breadController.orderby = TaskOrderBy.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    breadController.reloadNextBread();
    breadController.keepClean();

    return AnimatedBuilder(
        animation: breadController,
        builder: (context, child) {
          if (breadController.allTasksLoaded && breadController.tasks.isEmpty) {
            return Center(
                child: Icon(
              Icons.breakfast_dining,
              color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).highlightColor : Theme.of(context).primaryColor,
              size: 200,
            ));
          }

          return Stack(
            children: [
              ListView.builder(
                  itemBuilder: ((context, index) {
                    if (index < breadController.tasks.length) {
                      return ListTile(
                        title: Text(breadController.tasks[index].description),
                        trailing: Checkbox(
                          value: breadController.tasks[index].isCompleted,
                          onChanged: (value) {
                            breadController.tasks[index].isCompleted = value!;
                            breadController
                                .updateTask(breadController.tasks[index]);
                          },
                        ),
                      );
                    }
                    breadController.loadMoreTasks();
                    return const Center(child: CircularProgressIndicator());
                  }),
                  itemCount: breadController.tasks.length +
                      (!breadController.allTasksLoaded ? 1 : 0)),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: breadController.tasks.isNotEmpty
                      ? Row(children: [
                          const Spacer(),
                          Card(
                              child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Icon(Icons.timelapse),
                              ),
                              Text(
                                  "Clearing at ${breadController.nextBread.format(context)}"),
                              TextButton(
                                onPressed: () {
                                  showTimePicker(
                                          context: context,
                                          initialTime:
                                              breadController.nextBread)
                                      .then((value) {
                                    breadController.setNextBread(value!);
                                  });
                                },
                                child: const Text("Edit"),
                              )
                            ],
                          )),
                          const Spacer(),
                        ])
                      : null)
            ],
          );
        });
  }

  @override
  Widget? get floatingActionButton => null;

  @override
  Icon get icon => const Icon(Icons.breakfast_dining);

  @override
  String get label => "Today's Bread";
}
