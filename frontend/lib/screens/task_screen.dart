import 'package:flutter/material.dart';
import '../widgets/task_tile.dart';

import '../services/task_service.dart';
import '../models/task.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Task> tasks = [];
  bool isLoading = false;
  String? errorMessage;

  final TaskService taskService = TaskService();

  Future<void> loadTasks() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await taskService.getTasks();

      setState(() {
        tasks = result;
        isLoading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        errorMessage = "Failed to load tasks";
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mini Task App")),

      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              final controller = TextEditingController();

              final title = await showDialog<String>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Add Task"),

                    content: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: "Enter task title",
                      ),
                    ),

                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, controller.text);
                        },
                        child: const Text("Add"),
                      ),
                    ],
                  );
                },
              );

              if (title != null && title.trim().isNotEmpty) {
                await taskService.createTask(title.trim());

                await loadTasks();
              }
            },
            child: const Text("Add Task"),
          ),

          if (isLoading)
            const CircularProgressIndicator()
          else if (errorMessage != null)
            Text(errorMessage!)
          else
            ...tasks.map((task) {
              return TaskTile(
                title: task.title,
                completed: task.completed,

                onChanged: (value) async {
                  final updatedTask = Task(
                    id: task.id,
                    title: task.title,
                    completed: value ?? false,
                  );

                  await taskService.updateTask(updatedTask);
                  await loadTasks();
                },

                onDelete: () async {
                  await taskService.deleteTask(task.id);
                  await loadTasks();
                },
              );
            }),
        ],
      ),
    );
  }
}
