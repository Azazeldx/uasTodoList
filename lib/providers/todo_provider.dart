import 'package:flutter/foundation.dart';
import '../models/todo.dart';
import '../services/todo_service.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];
  bool _isLoading = false;

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;

  // Fetch dari API
  Future<void> fetchTodos() async {
    _isLoading = true;
    notifyListeners();

    try {
      _todos = await TodoService.getTodos();
    } catch (e) {
      debugPrint('Error fetch: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Tambah Todo ke API
  Future<void> addTodo(String judul, bool selesai) async {
    try {
      final newTodo = await TodoService.createTodo(judul);
      _todos.add(newTodo);
      notifyListeners();
    } catch (e) {
      debugPrint('Error add: $e');
    }
  }

  // Update Todo (ubah status selesai)
  Future<void> updateTodo(String id, String judul, bool selesai) async {
    try {
      // API hanya update selesai
      final updatedTodo = await TodoService.updateTodo(id, selesai);

      final index = _todos.indexWhere((t) => t.id == id);
      if (index != -1) {
        // Ubah juga judul di local state
        _todos[index] = Todo(
          id: id,
          judul: judul,
          selesai: updatedTodo.selesai,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error update: $e');
    }
  }

  // Toggle status selesai langsung
  Future<void> toggleTodo(String id, bool selesai) async {
    try {
      final updatedTodo = await TodoService.updateTodo(id, selesai);
      final index = _todos.indexWhere((t) => t.id == id);
      if (index != -1) {
        _todos[index] = updatedTodo;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error toggle: $e');
    }
  }

  // Hapus Todo
  Future<void> deleteTodo(String id) async {
    try {
      await TodoService.deleteTodo(id);
      _todos.removeWhere((t) => t.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error delete: $e');
    }
  }
}
