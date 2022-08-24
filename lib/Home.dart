import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:async/async.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _tasks = [];

  Future<File> _getFile()async{
    Directory directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/data.json');
  }

  _saveTask() async {
    var file = await _getFile();

    Map<String, dynamic> task = Map();
    task['title'] = 'something';
    task['done'] = false;
    _tasks.add(task);

    String data = json.encode(_tasks);
    file.writeAsString(data);
  }

  loadTask() async {
    var file = await _getFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("ToDo List"),
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
                  onChanged: (text) {},
                  decoration: const InputDecoration(hintText: "New tasks"),
                ),
                actions: [
                  TextButton(onPressed: () {
                    Navigator.pop(context);
                    _saveTask();
                  }, child: const Text("Salvar")),
                  TextButton(onPressed: () {
                    Navigator.pop(context);
                  }, child: const Text("Cancelar")),
                ],
              );
            },
          );
        },
        foregroundColor: Colors.purple,
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_tasks[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
