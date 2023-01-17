import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskItem {
  TaskItem({
    required this.dateCreated,
    required this.dateLastModified,
    required this.dueDate,
    required this.description,
    required this.isCompleted,
    required this.breaded,
    this.id,
  });

  DateTime dateCreated;
  DateTime dateLastModified;
  DateTime dueDate;
  String description;
  bool isCompleted;
  bool breaded;
  int? id;
}

enum TaskOrderBy {
  dateCreated,
  dateLastModified,
  dueDate,
  description,
  isCompleted,
  breaded,
  id,
}

enum TaskOrder {
  ascending,
  descending,
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
    this.breaded,
    this.description,
  });

  DateTime? startDateCreated;
  DateTime? endDateCreated;
  DateTime? startDateLastModified;
  DateTime? endDateLastModified;
  DateTime? startDueDate;
  DateTime? endDueDate;
  String? description;
  bool? isCompleted;
  bool? breaded;
}

abstract class TaskService {
  Future<TaskItem> addTask(TaskItem item);
  Future<Iterable<TaskItem>> getTasks(
      {TaskFilter? filter,
      TaskOrderBy orderby,
      TaskOrder order,
      int page,
      int limit});
  Future<TaskItem> updateTask(TaskItem item);
  Future<void> removeTask(int id);
  Future<void> unbreadTasks();
}

class SQLiteTaskService extends TaskService {
  final Future<Database> database = (() async => openDatabase(
        // Set the path to the database. Note: Using the `join` function from the
        // `path` package is best practice to ensure the path is correctly
        // constructed for each platform.
        join(await getDatabasesPath(), 'task_database.db'),
        // When the database is first created, create a table to store dogs.
        onCreate: (db, version) {
          // Run the CREATE TABLE statement on the database.
          return db.execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY, breaded BOOLEAN, is_completed BOOLEAN, description TEXT, due_date DATE, date_last_modified DATETIME, date_created DATETIME)',
          );
        },
        // Set the version. This executes the onCreate function and provides a
        // path to perform database upgrades and downgrades.
        version: 1,
      ))();

  @override
  Future<TaskItem> addTask(TaskItem item) async {
    final db = await database;

    assert(item.id == null);

    item.id = await db.insert("tasks", {
      "breaded": item.breaded ? 1 : 0,
      "is_completed": item.isCompleted ? 1 : 0,
      "description": item.description,
      "due_date": item.dueDate.millisecondsSinceEpoch,
      "date_last_modified": item.dateLastModified.millisecondsSinceEpoch,
      "date_created": item.dateCreated.millisecondsSinceEpoch,
    });

    return item;
  }

  @override
  Future<Iterable<TaskItem>> getTasks({
    TaskFilter? filter,
    TaskOrderBy orderby = TaskOrderBy.id,
    TaskOrder order = TaskOrder.ascending,
    int page = 0,
    int limit = 20,
  }) async {
    final db = await database;

    final String orderbyColumn;

    final whereStatement = [];
    final whereArgs = [];

    switch (orderby) {
      case TaskOrderBy.dateCreated:
        orderbyColumn = "date_created";
        break;
      case TaskOrderBy.dateLastModified:
        orderbyColumn = "date_last_modified";
        break;
      case TaskOrderBy.dueDate:
        orderbyColumn = "due_date";
        break;
      case TaskOrderBy.isCompleted:
        orderbyColumn = "is_completed";
        break;
      case TaskOrderBy.breaded:
        orderbyColumn = "is_completed";
        break;
      case TaskOrderBy.description:
        orderbyColumn = "description";
        break;
      case TaskOrderBy.id:
      default:
        orderbyColumn = "id";
        break;
    }

    if (filter?.endDateCreated != null) {
      whereStatement.add("date_created <= ?");
      whereArgs.add(filter!.endDateCreated);
    }
    if (filter?.startDateCreated != null) {
      whereStatement.add("date_created >= ?");
      whereArgs.add(filter!.startDateCreated);
    }
    if (filter?.endDueDate != null) {
      whereStatement.add("due_date <= ?");
      whereArgs.add(filter!.endDueDate);
    }
    if (filter?.startDueDate != null) {
      whereStatement.add("due_date >= ?");
      whereArgs.add(filter!.startDueDate);
    }
    if (filter?.endDateLastModified != null) {
      whereStatement.add("date_last_modified <= ?");
      whereArgs.add(filter!.endDateLastModified);
    }
    if (filter?.startDateLastModified != null) {
      whereStatement.add("date_last_modified >= ?");
      whereArgs.add(filter!.startDateLastModified);
    }
    if (filter?.isCompleted != null) {
      whereStatement.add("is_completed = ?");
      whereArgs.add(filter!.isCompleted);
    }
    if (filter?.breaded != null) {
      whereStatement.add("breaded = ?");
      whereArgs.add(filter!.breaded);
    }
    if (filter?.description != null) {
      whereStatement.add("description LIKE %?%");
      whereArgs.add(filter!.description);
    }

    final result = await db.query(
      "tasks",
      where: whereStatement.isNotEmpty ? whereStatement.join(" AND ") : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy:
          "$orderbyColumn ${order == TaskOrder.ascending ? "ASC" : "DESC"}",
      limit: limit,
      offset: page * limit,
    );

    return result.map((taskMap) => TaskItem(
          dateCreated: DateTime.fromMillisecondsSinceEpoch(
              taskMap["date_created"] as int),
          dateLastModified: DateTime.fromMillisecondsSinceEpoch(
              taskMap["date_last_modified"] as int),
          dueDate:
              DateTime.fromMillisecondsSinceEpoch(taskMap["due_date"] as int),
          description: taskMap["description"] as String,
          isCompleted: (taskMap["is_completed"] as int) != 0,
          breaded: (taskMap["breaded"] as int) != 0,
          id: taskMap["id"] as int,
        ));
  }

  @override
  Future<void> removeTask(int id) async {
    final db = await database;

    db.delete("tasks", where: "id = ?", whereArgs: [id]);
  }

  @override
  Future<TaskItem> updateTask(TaskItem item) async {
    final db = await database;

    assert(item.id != null);

    await db.update(
        "tasks",
        {
          "is_completed": item.isCompleted ? 1 : 0,
          "description": item.description,
          "due_date": item.dueDate.millisecondsSinceEpoch,
          "date_last_modified": item.dateLastModified.millisecondsSinceEpoch,
          "date_created": item.dateCreated.millisecondsSinceEpoch,
          "breaded": item.breaded ? 1 : 0,
        },
        where: "id = ?",
        whereArgs: [item.id]);

    return item;
  }

  @override
  Future<void> unbreadTasks() async {
    final db = await database;

    await db.delete("tasks",
        where: "breaded = ? AND is_completed = ?", whereArgs: [1, 1]);

    await db.update("tasks", {
      "breaded": 0,
      "is_completed": 0,
    });
  }
}
