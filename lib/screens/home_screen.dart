import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import 'add_todo_screen.dart';

enum FilterStatus { semua, selesai, belum }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FilterStatus _filterStatus = FilterStatus.semua;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodoProvider>(context, listen: false).fetchTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);
    final todos = provider.todos;

    // Filter todos sesuai dropdown
    final filteredTodos =
        todos.where((todo) {
          switch (_filterStatus) {
            case FilterStatus.selesai:
              return todo.selesai;
            case FilterStatus.belum:
              return !todo.selesai;
            default:
              return true;
          }
        }).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Daftar To-Do'),
        centerTitle: true,
        elevation: 0,
      ),
      body:
          provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // Filter Dropdown
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButton<FilterStatus>(
                          value: _filterStatus,
                          isExpanded: true,
                          underline: const SizedBox(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _filterStatus = value;
                              });
                            }
                          },
                          items: const [
                            DropdownMenuItem(
                              value: FilterStatus.semua,
                              child: Text('Semua'),
                            ),
                            DropdownMenuItem(
                              value: FilterStatus.selesai,
                              child: Text('Selesai'),
                            ),
                            DropdownMenuItem(
                              value: FilterStatus.belum,
                              child: Text('Belum Selesai'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // List Todo
                  Expanded(
                    child:
                        filteredTodos.isEmpty
                            ? const Center(
                              child: Text(
                                "Belum ada todo",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                            : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              itemCount: filteredTodos.length,
                              itemBuilder: (context, index) {
                                final todo = filteredTodos[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    leading: Checkbox(
                                      value: todo.selesai,
                                      onChanged: (value) {
                                        provider.toggleTodo(
                                          todo.id,
                                          value ?? false,
                                        );
                                      },
                                    ),
                                    title: Text(
                                      todo.judul,
                                      style: TextStyle(
                                        fontSize: 16,
                                        decoration:
                                            todo.selesai
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                      ),
                                    ),
                                    trailing: Wrap(
                                      spacing: 4,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (_) => AddTodoScreen(
                                                      todo: todo,
                                                      isEdit: true,
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            provider.deleteTodo(todo.id);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTodoScreen(isEdit: false)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
