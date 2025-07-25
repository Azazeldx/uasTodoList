class Todo {
  final String id;
  final String judul;
  final bool selesai;

  Todo({required this.id, required this.judul, required this.selesai});

  // Factory constructor untuk membuat objek Todo dari data JSON
  factory Todo.fromJson(Map<String, dynamic> json) {
    // Mengambil data dari map dan menginisialisasi objek Todo
    return Todo(id: json['id'], judul: json['judul'], selesai: json['selesai']);
  }

  // Mengubah objek Todo menjadi map (JSON)
  Map<String, dynamic> toJson() {
    // Mengembalikan map berisi data todo
    return {'id': id, 'judul': judul, 'selesai': selesai};
  }
}
