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
  final TextEditingController _controller = TextEditingController();

  Future<File> _getFile() async {
    Directory directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/data.json');
  }

  _saveTask() async {
    Map<String, dynamic> task = Map();
    task['title'] = _controller.text;
    task['done'] = false;

    setState(() {
      _tasks.add(task);
    });

    _saveFile();
    _controller.text = '';
  }

  _saveFile() async {
    var file = await _getFile();
    String data = json.encode(_tasks);

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

  @override
  void initState() {
    super.initState();
    _loadFile().then((data) {
      setState(() {
        _tasks = jsonDecode(data);
      });
    });
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
                      child: const Text("Salvar")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancelar")),
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
                return CheckboxListTile(
                  title: Text(_tasks[index]['title'].toString()),
                  value: _tasks[index]['done'],
                  onChanged: (bool? value) {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
