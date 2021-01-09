import 'package:flutter/foundation.dart';

class Task {
  String id;
  String title;
  String descrition;
  String date;
  TaskStatus taskStatus;
  List<String> category;

  Task({
    this.id,
    this.title,
    this.descrition,
    this.date,
    this.taskStatus,
    this.category,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = this.id;
    map["title"] = this.title;
    map["descrition"] = this.descrition;
    map["date"] = this.date;
    map["taskStatus"] = this.taskStatus;
    map["category"] = this.category;
    return map;
  }

  Task.getMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.title = map["title"];
    this.descrition = map["descrition"];
    this.date = map["date"];
    this.taskStatus = map["taskStatus"];
    this.category = map["category"];
  }
}

enum TaskStatus { ioDo, inProgress, done }
