import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_todo/box.dart';

void main() async {
  await Hive.initFlutter();
  todoBox = await Hive.openBox('todoBox');
  runApp(const HiveApp());
}

class HiveApp extends StatelessWidget {
  const HiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final todoController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hive app"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: todoController,
              decoration: const InputDecoration(
                label: Text("To-do item"),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  todoBox.add(todoController.text);
                });
              },
              child: const Text("Add"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: todoBox.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) {
                      todoBox.deleteAt(index).then((_) {
                        setState(() {});
                      });
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(todoBox.getAt(index).toString()),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
