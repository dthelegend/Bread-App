import 'package:bread/services/tasks/tasks_service.dart';
import 'package:flutter/material.dart';

class TaskController extends ChangeNotifier {
  TaskController({required this.taskService, this.limit = 20});

  final TaskService taskService;
  final int limit;

  TaskOrder order = TaskOrder.ascending;
  TaskOrderBy orderby = TaskOrderBy.id;
  TaskFilter filter = TaskFilter();

  int _page = 0;
  bool _allTasksLoaded = false;
  List<TaskItem> _tasks = [];

  bool get allTasksLoaded => _allTasksLoaded;

  List<TaskItem> get tasks => _tasks;

  Future<void> reset() async {
    _tasks = [];
    _allTasksLoaded = false;
    _page = 0;

    notifyListeners();
  }

  Future<void> loadMoreTasks() async {
    final newTasks = await taskService.getTasks(
        filter: filter, page: _page++, order: order, orderby: orderby);
    _allTasksLoaded = newTasks.length < limit;

    _tasks.addAll(newTasks);

    notifyListeners();
  }

  Future<void> addTask(TaskItem task) async {
    final newTask = await taskService.addTask(task);

    _tasks.add(newTask);

    notifyListeners();
  }

  Future<void> updateTask(TaskItem task) async {
    await taskService.updateTask(task);

    notifyListeners();
  }

  Future<void> removeTask(TaskItem task) async {
    if (task.id == null) return;

    _tasks.remove(task);

    await taskService.removeTask(task.id!);

    notifyListeners();
  }
}
