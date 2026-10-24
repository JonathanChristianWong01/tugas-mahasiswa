import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/task_item.dart';

// Lapisan akses SQLite: UI tidak berinteraksi langsung dengan database.
class TaskDatabase {
  TaskDatabase._();
  static final TaskDatabase instance = TaskDatabase._();
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final dbPath = p.join(await getDatabasesPath(), 'tugas_mahasiswa.db');
    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            course TEXT NOT NULL,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            deadline TEXT NOT NULL,
            priority TEXT NOT NULL,
            status TEXT NOT NULL
          )
        ''');
      },
    );
    return _db!;
  }

  Future<List<TaskItem>> getAll() async {
    final db = await database;
    final rows = await db.query('tasks', orderBy: 'deadline ASC, id DESC');
    return rows.map(TaskItem.fromMap).toList();
  }

  Future<void> insert(TaskItem task) async {
    final db = await database;
    final map = task.toMap()..remove('id');
    await db.insert('tasks', map);
  }

  Future<void> update(TaskItem task) async {
    if (task.id == null) throw ArgumentError('ID tugas wajib diisi');
    final db = await database;
    await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<void> delete(int id) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
