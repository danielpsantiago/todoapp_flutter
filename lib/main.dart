import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:todoapp_flutter/create_task.dart';
import 'package:todoapp_flutter/models/task.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Home',
      theme: new ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: new MyHomePage(title: 'Todoapp'),
      routes: <String, WidgetBuilder> {
        '/createTask': (BuildContext context) => new CreateTaskPage(),
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Task> tasks;
  var httpClient = new HttpClient();  

  @override
  void initState() {
    getMyTasks();
    super.initState();
  }

  getMyTasks() async {
    var request = await httpClient.getUrl(Uri.parse("http://35.224.54.61/tasks/findTasksByAssignee?assigneeId=5a1deac58506c209e0ba90ba"));
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var responseBody= await response.transform(UTF8.decoder).join();
      List list = JSON.decode(responseBody);
      setState(() {
        tasks = list.map((it) => new Task.fromJson(it)).where((it) => !it.deleted).toList();
      });
    }
  }

  deleteTask(String taskId) async {
    var request = await httpClient.patchUrl(Uri.parse("http://35.224.54.61/tasks/delete?taskId=$taskId"));
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      setState(() {
          tasks.remove(tasks.where((it) => it.id == taskId).first);
      });
    }
  }

  changeCompleteStatus(Task task, bool value) async {
    setState(() {
      var index = tasks.indexOf(task);
      tasks[index].completed = value;
      task.completed = value;
    });

    var request = await httpClient.patchUrl(Uri.parse('http://35.224.54.61/tasks/complete?taskId=${task.id}'));
    var response = await request.close();
    if (response.statusCode != HttpStatus.OK) {
      setState(() {
        tasks[tasks.indexOf(task)].completed = !value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.add),
            onPressed: () { Navigator.of(context).pushNamed('/createTask').then((mockValue) => getMyTasks()); }
          )
        ],
      ),
      body: new Padding(
          padding: const EdgeInsets.only(top: 12.0, right: 8.0),
          child: new ListView(
              padding: new EdgeInsets.symmetric(vertical: 8.0),
              children:
                  tasks != null
                  ? tasks.map((task) {
                    return new Container(
                      margin: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
                      child: new ListTile(
                        onTap: null,
                        title: new Row(
                          children: <Widget>[
                            new Checkbox(
                              value: task.completed != null ? task.completed : false,
                              onChanged: (bool value) { changeCompleteStatus(task, value); }
                            ),
                            new Expanded(
                              child: new Container(
                                margin: const EdgeInsets.only(right: 12.0),
                                child: new Text(
                                  task.name,
                                  style: new TextStyle(
                                      decoration: task.completed != null && task.completed ? TextDecoration.lineThrough : TextDecoration.none
                                  ),
                                ),
                              )
                            ),
                            new IconButton(
                              icon: new Icon(Icons.delete),
                              onPressed: () { deleteTask(task.id); },
                            ),
                          ],
                        ),
                      )
                    );
                  }).toList()
                  : [] ,
          ),
      ),
    );
  }

}

