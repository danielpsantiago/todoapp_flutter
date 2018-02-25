library task;

import 'dart:core';
import 'package:intl/intl.dart';


class Task  {

  Task();

  Task.fromJson(Map json) {
    this.id = json['_id'];
    this.name = json['name'];
    this.createdAt = json['createdAt'] != null ? new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").parse(json['createdAt']) : null;//DateTime.parse(json['createdAt']);
    this.dueTo = json['dueTo'] != null ?  new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").parse(json['dueTo']) : null;
    this.completed = json['completed'];
    this.assigneeId = json['assigneeId'];
    this.createdById = json['createdById'];
    this.deleted = json['deleted'];
  }

  String id;
  String name;
  DateTime createdAt;
  DateTime dueTo;
  bool completed;
  String assigneeId;
  String createdById;
  bool deleted;

  toJson() => {
    "id": id,
    "name": name,
    "createdAt": createdAt != null ? createdAt.toString() : null,
    "dueTo": dueTo != null ? dueTo.toString(): null,
    "completed": completed,
    "assigneeId": assigneeId,
    "createdById": createdById,
    "deleted": deleted
  };



}