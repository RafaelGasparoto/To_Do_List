import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _tasks = [];
  List _tasksCompleted = [];

  final TextEditingController _controller = TextEditingController();

  Future<File> _getFile() async {
    Directory directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/data.json');
  }

  _saveTask() async {
    Map<String, dynamic> task = Map();
    task['title'] = _controller.text;
    task['status'] = false;

    setState(() {
      _tasks.add(task);
    });

    _saveFile();
    _controller.text = '';
  }

  _change(int index, int who) async {
    if (who == 0) {
      _tasks[index]['status'] = true;
      _tasksCompleted.add(_tasks[index]);
    } else {
      _tasksCompleted[index]['status'] = false;
      _tasks.add(_tasksCompleted[index]);
    }
    _saveFile();
  }

  _deleteTask(int index, int who) async {
    setState(() {
      if (who == 0) {
        _tasks.removeAt(index);
      } else {
        _tasksCompleted.removeAt(index);
      }
    });
    _saveFile();
  }

  _saveFile() async {
    var file = await _getFile();

    if (_tasksCompleted.isNotEmpty) {
      String dataTasksCompleted = json.encode(_tasksCompleted);
      file.writeAsString(dataTasksCompleted);
    }
    if (_tasks.isNotEmpty) {
      String dataTasks = json.encode(_tasks);
      file.writeAsString(dataTasks);
    }
  }

  _loadFile() async {
    try {
      var file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadFile().then((data) {
      setState(() {
        Map<String, dynamic> task = Map();
        task['title'] = jsonDecode(data['title']);
        task['status'] = jsonDecode(data['status']);

        if (task['status'] == false) {
          _tasks.add(task);
        } else {
          _tasksCompleted.add(task);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("To do List"),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 8,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("To do"),
                content: TextField(
                  controller: _controller,
                  onChanged: (text) {},
                  decoration: const InputDecoration(hintText: "New tasks"),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _saveTask();
                      },
                      child: const Text("Save")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                ],
              );
            },
          );
        },
        foregroundColor: Colors.purple,
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        child: Column(
          children: [
            const Text(
              "To Do",
              style: TextStyle(fontSize: 20),
            ),
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onDoubleTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                "Are you sure you want to delete this task?",
                                style: TextStyle(),
                                textAlign: TextAlign.center,
                              ),
                              actionsAlignment: MainAxisAlignment.spaceAround,
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      _deleteTask(index, 0);
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Yes")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("No")),
                              ],
                            );
                          });
                    },
                    child: CheckboxListTile(
                      title: Text(_tasks[index]['title'].toString()),
                      value: _tasks[index]['status'],
                      onChanged: (bool? value) {
                        _change(index, 0);
                        _deleteTask(index, 0);
                      },
                    ),
                  );
                },
              ),
            ),
            const Text(
              "Complete",
              style: TextStyle(fontSize: 20),
            ),
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: _tasksCompleted.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onDoubleTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                "Are you sure you want to delete this task?",
                                style: TextStyle(),
                                textAlign: TextAlign.center,
                              ),
                              actionsAlignment: MainAxisAlignment.spaceAround,
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      _deleteTask(index, 1);
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Yes")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("No")),
                              ],
                            );
                          });
                    },
                    child: CheckboxListTile(
                      title: Text(_tasksCompleted[index]['title'].toString()),
                      value: _tasksCompleted[index]['status'],
                      onChanged: (bool? value) {
                        _change(index, 1);
                        _deleteTask(index, 1);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
