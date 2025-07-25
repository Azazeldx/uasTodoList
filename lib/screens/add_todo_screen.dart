import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';

class AddTodoScreen extends StatefulWidget {
  final Todo? todo;
  final bool isEdit;

  const AddTodoScreen({super.key, this.todo, required this.isEdit});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judulController;
  bool _selesai = false;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(
      text: widget.isEdit ? widget.todo?.judul : '',
    );
    _selesai = widget.todo?.selesai ?? false;
  }

  @override
  void dispose() {
    _judulController.dispose();
    super.dispose();
  }

  void _saveTodo() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<TodoProvider>(context, listen: false);
      final judul = _judulController.text.trim();

      if (widget.isEdit && widget.todo != null) {
        provider.updateTodo(widget.todo!.id, judul, _selesai);
      } else {
        provider.addTodo(judul, _selesai);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isEdit ? 'Edit Todo' : 'Tambah Todo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(labelText: 'Judul Todo'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Selesai?'),
                value: _selesai,
                onChanged: (value) {
                  setState(() {
                    _selesai = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveTodo,
                child: Text(widget.isEdit ? 'Simpan Perubahan' : 'Tambah Todo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
