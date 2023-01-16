class TaskItem {
  TaskItem({
    required this.dateCreated,
    required this.dateLastModified,
    required this.dueDate,
    required this.description,
    required this.isCompleted,
    this.id,
  });

  DateTime dateCreated;
  DateTime dateLastModified;
  DateTime dueDate;
  String description;
  bool isCompleted;
  int? id;
}

enum TaskSort {
  dateCreated,
  dateLastModified,
  dueDate,
  description,
  isCompleted,
  id,
}

class TaskFilter {
  TaskFilter({
    this.startDateCreated,
    this.endDateCreated,
    this.startDateLastModified,
    this.endDateLastModified,
    this.startDueDate,
    this.endDueDate,
    this.isCompleted,
  });

  DateTime? startDateCreated;
  DateTime? endDateCreated;
  DateTime? startDateLastModified;
  DateTime? endDateLastModified;
  DateTime? startDueDate;
  DateTime? endDueDate;
  bool? isCompleted;
}

abstract class TaskService {
  Future<void> addTask(TaskItem item);
  Future<TaskItem> getTasks(TaskFilter filter, TaskSort sort);
  Future<TaskItem> updateTask(TaskItem item);
  Future<TaskItem> removeTask(int id);
}
