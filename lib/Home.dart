import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List _tasks = [];
  final List _tasksCompleted = [];

  final TextEditingController _controller = TextEditingController();

  Future<File> _getFile() async {
    Directory directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/data.json');
  }

  _createTask() async {
    Map<String, dynamic> task = {};
    task['title'] = _controller.text;
    task['status'] = false;
    task['favorite'] = false;

    setState(() {
      _tasks.add(task);
    });

    _saveFile();
    _controller.text = '';
  }

  _changeTaskStatus(int index, int who) async {
    if (who == 0) {
      _tasks[index]['status'] = true;
      if (_tasks[index]['favorite']) {
        _tasksCompleted.insert(0, _tasks[index]);
      } else {
        _tasksCompleted.add(_tasks[index]);
      }
    } else {
      _tasksCompleted[index]['status'] = false;
      if (_tasksCompleted[index]['favorite']) {
        _tasks.insert(0, _tasksCompleted[index]);
      } else {
        _tasks.add(_tasksCompleted[index]);
      }
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
    final List allTasks = [];
    allTasks.addAll(_tasksCompleted);
    allTasks.addAll(_tasks);
    String data = json.encode(allTasks);

    file.writeAsString(data);
  }

  _loadFile() async {
    try {
      var file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  _favoriteTask(index, who) async {
    setState(() {
      if (who == 0) {
        var task = _tasks[index];
        _tasks.removeAt(index);

        if (task['favorite'] == true) {
          task['favorite'] = false;
          _tasks.add(task);
        } else {
          task['favorite'] = true;
          _tasks.insert(0, task);
        }
      } else {
        var task = _tasksCompleted[index];
        _tasksCompleted.removeAt(index);

        if (task['favorite'] == true) {
          task['favorite'] = false;
          _tasksCompleted.add(task);
        } else {
          task['favorite'] = true;
          _tasksCompleted.insert(0, task);
        }
      }
    });
    _saveFile();
  }

  @override
  void initState() {
    super.initState();
    _loadFile().then(
      (data) {
        setState(
          () {
            List task = json.decode(data);
            for (var i = 0; i < task.length; i++) {
              if (task[i]['status'] == false) {
                _tasks.add(task[i]);
              } else {
                _tasksCompleted.add(task[i]);
              }
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  "To do",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                content: TextField(
                  controller: _controller,
                  onChanged: (text) {},
                  decoration: const InputDecoration(hintText: "New tasks"),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          Navigator.pop(context);
                          _createTask();
                        }
                      },
                      child:
                          const Text("Save", style: TextStyle(fontSize: 20))),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child:
                          const Text("Cancel", style: TextStyle(fontSize: 20))),
                ],
              );
            },
          );
        },
        foregroundColor: Colors.black,
        backgroundColor: const Color(0xff4CDBF2),
        child: const Icon(Icons.add),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 30, bottom: 30, right: 10, left: 10),
        child: Column(
          children: [
            const Text(
              "To Do",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            _favoriteTask(index, 0);
                          },
                          icon: _tasks[index]['favorite']
                              ? const Icon(EvaIcons.heart)
                              : const Icon(EvaIcons.heartOutline)),
                      Expanded(
                        child: GestureDetector(
                          onLongPress: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Are you sure you want to delete '${_tasks[index]['title']}' task?",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    actionsAlignment:
                                        MainAxisAlignment.spaceAround,
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            _deleteTask(index, 0);
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "Yes",
                                            style: TextStyle(fontSize: 20),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("No",
                                              style: TextStyle(fontSize: 20))),
                                    ],
                                  );
                                });
                          },
                          child: Theme(
                            data: ThemeData(unselectedWidgetColor: const Color(0xff4CDBF2)),
                            child: CheckboxListTile(
                              title: Text(
                                _tasks[index]['title'].toString(),
                                style: const TextStyle(
                                    letterSpacing: 1, fontSize: 17),
                              ),
                              value: _tasks[index]['status'],
                              onChanged: (bool? value) {
                                _changeTaskStatus(index, 0);
                                _deleteTask(index, 0);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const Text(
              "Completed",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _tasksCompleted.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            _favoriteTask(index, 1);
                          },
                          icon: _tasksCompleted[index]['favorite']
                              ? const Icon(EvaIcons.heart)
                              : const Icon(EvaIcons.heartOutline)),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onLongPress: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Are you sure you want to delete '${_tasksCompleted[index]['title']}' task?",
                                      style: GoogleFonts.indieFlower(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    actionsAlignment:
                                        MainAxisAlignment.spaceAround,
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            _deleteTask(index, 1);
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Yes",
                                              style: TextStyle(fontSize: 20))),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("No",
                                              style: TextStyle(fontSize: 20))),
                                    ],
                                  );
                                });
                          },
                          child: CheckboxListTile(
                            activeColor: const Color(0xff4CDBF2),
                            checkColor: Colors.black,
                            title: Text(
                                _tasksCompleted[index]['title'].toString(),
                                style: const TextStyle(
                                    letterSpacing: 1, fontSize: 17)),
                            value: _tasksCompleted[index]['status'],
                            onChanged: (bool? value) {
                              _changeTaskStatus(index, 1);
                              _deleteTask(index, 1);
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xff4CDBF2),
        shape: const CircularNotchedRectangle(),
        child: Row(
          children: [
            Opacity(
              opacity: 0,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
