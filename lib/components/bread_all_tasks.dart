import 'package:bread/components/bread_main_view_tab.dart';
import 'package:bread/services/settings/settings_controller.dart';
import 'package:bread/services/tasks/task_controller.dart';
import 'package:bread/services/tasks/tasks_service.dart';
import 'package:flutter/material.dart';

class AllTasks extends StatelessWidget implements BreadMainViewTab {
  final TaskController taskController;
  final SettingsController settingsController;

  AllTasks({
    super.key,
    required this.settingsController,
    TaskService? taskService,
  }) : taskController =
            TaskController(taskService: taskService ?? SQLiteTaskService());

  void onRemove(TaskItem task) {
    taskController.removeTask(task);
  }

  void onUpdate(TaskItem task) {
    taskController.updateTask(task);
  }

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
                final task = taskController.tasks[index];
                return AllTaskItem(
                  key: Key("TaskItem_${task.id}"),
                  task: task,
                  onRemove: (task) {
                    onRemove(task);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Removed ${task.description}")));
                  },
                  onUpdate: onUpdate,
                  onBread: onUpdate,
                );
              }
              taskController.loadMoreTasks();
              return const Center(child: CircularProgressIndicator());
            }),
            itemCount: taskController.tasks.length +
                (!taskController.allTasksLoaded ? 1 : 0),
          );
        });
  }

  void addTask() {
    final propTask = TaskItem(
        dateCreated: DateTime.now(),
        dateLastModified: DateTime.now(),
        dueDate: DateTime.now(),
        description: "",
        isCompleted: false,
        breaded: false);
    taskController.addTask(propTask);
  }

  @override
  Widget? get floatingActionButton => FloatingActionButton(
        onPressed: addTask,
        child: const Icon(Icons.add),
      );

  @override
  Icon get icon => const Icon(Icons.all_inclusive);

  @override
  String get label => "All Tasks";
}

class AllTaskItem extends StatefulWidget {
  const AllTaskItem({
    super.key,
    required this.task,
    this.onRemove,
    this.onBread,
    this.onUpdate,
  });

  final TaskItem task;
  final void Function(TaskItem)? onRemove;
  final void Function(TaskItem)? onBread;
  final void Function(TaskItem)? onUpdate;

  @override
  State<AllTaskItem> createState() => AllTaskItemState();
}

class AllTaskItemState extends State<AllTaskItem> {
  DismissDirection currentDirection = DismissDirection.none;

  void onUpdate(DismissUpdateDetails details) {
    if (currentDirection != details.direction) {
      setState(() {
        currentDirection = details.direction;
      });
    }
  }

  Future<bool> confirmDismiss(DismissDirection direction) async {
    switch (direction) {
      case DismissDirection.startToEnd:
        return true;
      case DismissDirection.endToStart:
        if (widget.onBread != null) {
          widget.task.breaded = !widget.task.breaded;
          widget.onBread!(widget.task);
        }
        return false;
      default:
        return false;
    }
  }

  void onDismiss(DismissDirection direction) {
    widget.onRemove!(widget.task);
  }

  void onUpdateText(String text) {
    widget.task.description = text;
    if (widget.onUpdate != null) widget.onUpdate!(widget.task);
  }

  Widget currentBackground() {
    switch (currentDirection) {
      case DismissDirection.startToEnd:
        return Container(
          color: Colors.red,
          padding: const EdgeInsets.only(left: 8.0),
          alignment: Alignment.centerLeft,
          child: const Icon(Icons.remove),
        );
      case DismissDirection.endToStart:
        return Container(
          color: Colors.green,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 8.0),
          child: const Icon(Icons.breakfast_dining),
        );
      default:
        return Container();
    }
  }

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.task.description);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key("TaskItem_Dismiss_${widget.task.id}"),
      background: currentBackground(),
      onUpdate: onUpdate,
      confirmDismiss: confirmDismiss,
      onDismissed: onDismiss,
      child: ListTile(
        title: TextField(
          controller: _controller,
          decoration: const InputDecoration(
              border: InputBorder.none, hintText: "Let's get that bread"),
          onChanged: onUpdateText,
        ),
        trailing:
            widget.task.breaded ? const Icon(Icons.breakfast_dining) : null,
      ),
    );
  }
}
