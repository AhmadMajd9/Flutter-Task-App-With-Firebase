import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/task.dart';
import 'package:flutter/material.dart';

class TasksProvider with ChangeNotifier {
  List<Task> _task = [];

  Future<void> addTask(Task task) async {
    final url =
        'https://taskflutterapp-63b6b-default-rtdb.firebaseio.com/tasks.json';
    try {
      final value = await http.post(
        url,
        body: json.encode({
          'title ': task.title,
          'description': task.descrition,
          'date': task.date,
          'taskStatus': taskStatuSwitcher(task.taskStatus),
          'category': task.category,
        }),
      );
      final newtask = Task(
          id: json.decode(value.body)["name"],
          title: task.title,
          descrition: task.descrition,
          date: task.date,
          category: task.category,
          taskStatus: task.taskStatus);
      _task.insert(0, newtask);

      print("test add");
      notifyListeners();
    } catch (onError) {
      print(onError);
      throw onError;
    }
  }

  String taskStatuSwitcher(TaskStatus value) {
    switch (value) {
      case TaskStatus.ioDo:
        return "To Do";
        break;
      case TaskStatus.inProgress:
        return "In Progress";
        break;
      case TaskStatus.done:
        return "Done";
        break;
    }
  }
}
