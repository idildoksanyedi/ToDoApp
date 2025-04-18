import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];
  final String _storageKey = 'todos';

  List<Todo> get todos => [..._todos];

  TodoProvider() {
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todosJson = prefs.getStringList(_storageKey);
    if (todosJson != null) {
      _todos = todosJson
          .map((todo) => Todo.fromJson(json.decode(todo)))
          .toList();
      notifyListeners();
    }
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todosJson = _todos
        .map((todo) => json.encode(todo.toJson()))
        .toList();
    await prefs.setStringList(_storageKey, todosJson);
  }

  Future<void> addTodo(String title, String description, String priority, String category) async {
    final todo = Todo(
      id: DateTime.now().toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      priority: priority,
      category: category,
    );
    _todos.add(todo);
    notifyListeners();
    await _saveTodos();
  }

  Future<void> toggleTodo(String id) async {
    final todoIndex = _todos.indexWhere((todo) => todo.id == id);
    if (todoIndex >= 0) {
      _todos[todoIndex] = _todos[todoIndex].copyWith(
        isCompleted: !_todos[todoIndex].isCompleted,
      );
      notifyListeners();
      await _saveTodos();
    }
  }

  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
    await _saveTodos();
  }

  Future<void> updateTodo(String id, String title, String description, String priority, String category) async {
    final todoIndex = _todos.indexWhere((todo) => todo.id == id);
    if (todoIndex >= 0) {
      _todos[todoIndex] = _todos[todoIndex].copyWith(
        title: title,
        description: description,
        priority: priority,
        category: category,
      );
      notifyListeners();
      await _saveTodos();
    }
  }
}
