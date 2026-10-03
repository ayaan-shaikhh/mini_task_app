import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final String title;
  final bool completed;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onDelete;

  const TaskTile({
    super.key,
    required this.title,
    required this.completed,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: completed,
          onChanged: onChanged,
        ),

        Expanded(
          child: Text(
            title,
            style: TextStyle(
              decoration: completed
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
        ),

        IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }
}