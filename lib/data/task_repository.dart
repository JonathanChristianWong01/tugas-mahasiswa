import '../models/task_item.dart';
import 'task_database.dart';

class TaskRepository {
  final TaskDatabase database;
  TaskRepository(this.database);

  Future<List<TaskItem>> getAll() => database.getAll();
  Future<void> add(TaskItem task) => database.insert(task);
  Future<void> update(TaskItem task) => database.update(task);
  Future<void> delete(int id) => database.delete(id);
}
