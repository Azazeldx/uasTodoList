import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo.dart';

class TodoService {
  static const String baseUrl =
      'https://687db19e918b6422433270e9.mockapi.io/api/todoUas/todoUas';

  // Ambil semua todo
  static Future<List<Todo>> getTodos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Todo.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data');
    }
  }

  // Tambah todo baru
  static Future<Todo> createTodo(String judul) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'judul': judul, 'selesai': false}),
    );

    if (response.statusCode == 201) {
      return Todo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal menambahkan todo');
    }
  }

  // Update todo selesai
  static Future<Todo> updateTodo(String id, bool selesai) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'selesai': selesai}),
    );

    if (response.statusCode == 200) {
      return Todo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal mengupdate todo');
    }
  }

  // Hapus todo
  static Future<void> deleteTodo(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus todo');
    }
  }
}
