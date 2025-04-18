import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_list.dart';
import '../widgets/add_todo_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<TodoProvider>().todos;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Hafif gri arka plan
      appBar: AppBar(
        title: const Text(
          'ToDo Uygulaması',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.indigoAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: todos.isEmpty
            ? const Center(
          child: Text(
            'Henüz yapılacak bir görev bulunmuyor.\nYeni görev eklemek için "+" butonuna basın.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        )
            : const TodoList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddTodoDialog(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Yeni Görev'),
        backgroundColor: Colors.indigoAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
