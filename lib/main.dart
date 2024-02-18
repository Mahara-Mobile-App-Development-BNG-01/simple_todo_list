import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    BlocProvider<TasksCubit>(
      create: (context) => TasksCubit(),
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
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TasksCubit>();
    final completedTasks = cubit.state.completedTasks;
    final tasks = cubit.state.tasks;
    final progress = completedTasks.length / tasks.length;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TODO List'),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: textController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your task here'),
                onSubmitted: (text) {
                  cubit.addTask(text);
                  textController.clear();
                },
              ),
            ),
            LinearProgressIndicator(
              value: progress,
            ),
            TasksList(onChanged: (newValue, title) {
              cubit.toggleTask(title);
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
    final model = context.watch<TasksCubit>();
    final List<String> tasks = model.state.tasks;
    final List<String> completedTasks = model.state.completedTasks;

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

class TasksCubit extends Cubit<TasksState> {
  TasksCubit()
      : super(
          TasksState(
            tasks: ['First Task', 'Second Task', 'Third Task'],
            completedTasks: [],
          ),
        );

  void addTask(String title) {
    emit(
      state.copyWith(
        tasks: [
          title,
          ...state.tasks,
        ],
      ),
    );
  }

  void toggleTask(String title) {
    final newState = state.copyWith();

    if (state.completedTasks.contains(title)) {
      newState.completedTasks.remove(title);
      emit(newState);
    } else {
      newState.completedTasks.add(title);
      emit(newState);
    }
  }
}

class TasksState {
  TasksState({required this.tasks, required this.completedTasks});

  final List<String> tasks;
  final List<String> completedTasks;

  TasksState copyWith({
    List<String>? tasks,
    List<String>? completedTasks,
  }) {
    return TasksState(
      tasks: tasks ?? this.tasks,
      completedTasks: completedTasks ?? this.completedTasks,
    );
  }
}
