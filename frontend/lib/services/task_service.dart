import 'package:http/http.dart' as http;
import '../models/task.dart';

import 'dart:convert';

class TaskService {
  Future<List<Task>> getTasks() async {
    final response = await http.get(Uri.parse("http://10.0.2.2:3000/tasks"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List<Task> tasks = data.map<Task>((item) {
        return Task.fromJson(item);
      }).toList();

      return tasks;
    } else {
      throw Exception("Failed to load tasks");
    }
  }

  Future<Task> getTask(int id) async {
    final response = await http.get(
      Uri.parse("http://10.0.2.2:3000/tasks/$id"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return Task.fromJson(data);
    } else {
      throw Exception("Failed to load task");
    }
  }

  Future<Task> createTask(String title) async {
    final response = await http.post(
      Uri.parse("http://10.0.2.2:3000/tasks"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"title": title}),
    );
    

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return Task.fromJson(data);
    } else {
      throw Exception("Failed to create task");
    }
  }

  Future<Task> updateTask(Task task) async {
    final response = await http.patch(
      Uri.parse("http://10.0.2.2:3000/tasks/${task.id}"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"completed": task.completed, "title": task.title}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return Task.fromJson(data);
    } else {
      throw Exception("Failed to update task");
    }
  }

  Future<Task> deleteTask(int id) async {
    final response = await http.delete(
      Uri.parse("http://10.0.2.2:3000/tasks/$id"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return Task.fromJson(data);
    } else {
      throw Exception("Failed to delete task");
    }
  }
}
