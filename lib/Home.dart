import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> _tasks = ["a", "b", "c"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("ToDo List"),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
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
                  TextButton(onPressed: () {}, child: const Text("Salvar")),
                  TextButton(onPressed: () {}, child: const Text("Cancelar")),
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
