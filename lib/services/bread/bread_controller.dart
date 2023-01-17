import 'dart:async';

import 'package:bread/services/bread/bread_service.dart';
import 'package:bread/services/tasks/task_controller.dart';
import 'package:flutter/material.dart';

class BreadController extends TaskController {
  BreadController({
    required this.breadService,
    required super.taskService,
  });

  final BreadService breadService;
  Timer? _timer;

  void keepClean({Function()? onClean}) {
    _timer = Timer.periodic(const Duration(minutes: 1), _cleanHouse(onClean));
  }

  void stopCleaning() {
    _timer?.cancel();
  }

  DateTime _nextBreadDateTime = DateTime.fromMillisecondsSinceEpoch(0);
  TimeOfDay _nextBread = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay get nextBread => _nextBread;

  Future<void> reloadNextBread() async {
    _setNextBread(await breadService.getNextBread());

    notifyListeners();
  }

  void _setNextBread(DateTime next) {
    _nextBread = TimeOfDay.fromDateTime(next);
    _nextBreadDateTime = next;
  }

  void Function(Timer) _cleanHouse(Function()? onClean) {
    return (timer) {
      if (!_nextBreadDateTime.isAfter(DateTime.now())) {
        stopCleaning();
        (() async {
          await Future.wait([
            setNextBread(_nextBread),
            (() async {
              await taskService.unbreadTasks();
              reset();
            })()
          ]);
          if (onClean != null) onClean();
          keepClean(onClean: onClean);
        })();
      }
    };
  }

  Future<void> setNextBread(TimeOfDay next) async {
    final now = DateTime.now();
    var nextDay =
        DateTime(now.year, now.month, now.day, next.hour, next.minute);

    while (!nextDay.isAfter(now)) {
      nextDay = nextDay.add(const Duration(days: 1));
    }

    await breadService.setNextBread(nextDay);

    _setNextBread(nextDay);

    notifyListeners();
  }
}
