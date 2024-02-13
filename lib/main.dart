import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Task {
  Task(this.title, this.checked);

  final String title;
  final bool checked;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final tasks = [
    Task('First Task', false),
    Task('Second Task', false),
    Task('Third Task', false),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TODO List'),
        ),
        body: ListView(
          children: [
            const LinearProgressIndicator(
              value: 0.4,
            ),
            ...tasks.map(
              (task) => MyCheckboxTile(
                title: task.title,
                checked: task.checked,
                onChange: (newValue) {

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyCheckboxTile extends StatefulWidget {
  const MyCheckboxTile({
    super.key,
    required this.title,
    required this.checked,
    required this.onChange,
  });

  final String title;
  final bool checked;
  final void Function(bool?) onChange;

  @override
  State<MyCheckboxTile> createState() => _MyCheckboxTileState();
}

class _MyCheckboxTileState extends State<MyCheckboxTile> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.title),
      value: widget.checked,
      onChanged: widget.onChange,
    );
  }
}
