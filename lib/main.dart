import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TasksModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TasksModel>(context);
    final completedTasks = model.completedTasks;
    final tasks = model.tasks;
    final progress = completedTasks.length / tasks.length;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TODO List'),
        ),
        body: ListView(
          children: [
            LinearProgressIndicator(
              value: progress,
            ),
            TasksList(onChanged: (newValue, title) {
                model.toggleTask(title);
            })
          ],
        ),
      ),
    );
  }
}

class TasksList extends StatelessWidget {
  const TasksList({
    super.key,
    required this.onChanged,
  });

  final void Function(bool, String) onChanged;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TasksModel>();
    final List<String> tasks = model.tasks;
    final List<String> completedTasks = model.completedTasks;

    return Column(
      children: tasks
          .map(
            (title) => CheckboxListTile(
              title: Text(title),
              value: completedTasks.contains(title),
              onChanged: (checked) => onChanged(checked ?? false, title),
            ),
          )
          .toList(),
    );
  }
}

class TasksModel extends ChangeNotifier {
  final List<String> tasks = [
    'First Task',
    'Second Task',
    'Third Task',
  ];
  final List<String> completedTasks = [];

  TasksModel();

  void toggleTask(String title) {
    if (completedTasks.contains(title)) {
      completedTasks.remove(title);
    } else {
      completedTasks.add(title);
    }
    notifyListeners();
  }
}
