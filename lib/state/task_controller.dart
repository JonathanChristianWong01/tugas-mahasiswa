import 'package:flutter/foundation.dart';

import '../data/task_repository.dart';
import '../models/task_item.dart';

// ChangeNotifier berperan sebagai pengelola state (padanan ViewModel).
class TaskController extends ChangeNotifier {
  final TaskRepository repository;
  TaskController(this.repository);

  List<TaskItem> tasks = [];
  bool isLoading = false;
  String? error;

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      tasks = await repository.getAll();
    } catch (e) {
      error = 'Gagal memuat tugas: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(TaskItem task) async {
    await repository.add(task);
    await load();
  }

  Future<void> update(TaskItem task) async {
    await repository.update(task);
    await load();
  }

  Future<void> delete(int id) async {
    await repository.delete(id);
    await load();
  }

  Future<void> changeStatus(TaskItem task, String status) =>
      update(task.copyWith(status: status));
}
