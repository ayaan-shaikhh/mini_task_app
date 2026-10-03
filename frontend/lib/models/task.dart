class Task {
  final int id;
  final String title;
  final bool completed;

  Task({
    required this.id,
    required this.title,
    required this.completed,
  });

  factory Task.fromJson(Map<String, dynamic> vvvv) {
    return Task(
      id: vvvv['id'],
      title: vvvv['title'],
      completed: vvvv['completed'],
    );
  }
}