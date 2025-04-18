import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';
import 'edit_todo_dialog.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem({
    super.key,
    required this.todo,
  });

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.redAccent;
      case 'Medium':
        return Colors.orangeAccent;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        Provider.of<TodoProvider>(context, listen: false).deleteTodo(todo.id);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Checkbox(
              value: todo.isCompleted,
              onChanged: (bool? value) {
                Provider.of<TodoProvider>(context, listen: false).toggleTodo(todo.id);
              },
            ),
            title: Text(
              todo.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: todo.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: todo.isCompleted ? Colors.grey : Colors.black,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (todo.description.isNotEmpty)
                  Text(
                    todo.description,
                    style: TextStyle(
                      color: todo.isCompleted ? Colors.grey : Colors.black87,
                    ),
                  ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    // Priority badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(todo.priority).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        todo.priority,
                        style: TextStyle(
                          fontSize: 12,
                          color: _getPriorityColor(todo.priority),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        todo.category,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.indigo,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => EditTodoDialog(todo: todo),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
