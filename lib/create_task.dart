library create_task_page;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todoapp_flutter/models/task.dart';
import 'package:http/http.dart' as http;

class CreateTaskPage extends StatelessWidget {

  String taskName = '';

  createBtnClicked(BuildContext context) async {
    if (taskName == '') {
      taskName = '--';
    }

    var task = new Task()
      ..completed = false
      ..name = taskName
      ..deleted = false
      ..createdById = "5a1deac58506c209e0ba90ba"
      ..assigneeId = "5a1deac58506c209e0ba90ba";

    var json = JSON.encode(task);
    var response = await http.post(
        'http://35.224.54.61/tasks/create',
        headers: {"Content-Type": "application/json"} ,
        body: json
    );
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Create a Task")
      ),
      body: new Padding(
        padding: new EdgeInsets.all(8.0),
        child: new Column(
          children: <Widget>[
            new TextField(
              onChanged: (value){ taskName = value; },
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new RaisedButton(
                      onPressed: () { createBtnClicked(context); },
                      color: Colors.amber,
                      child: const Text('Criar'),
                    ),
                  ),
                ],
              )
            )
          ],
        )
      )
    );
  }

}