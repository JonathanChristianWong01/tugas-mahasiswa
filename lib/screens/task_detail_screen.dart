import 'package:flutter/material.dart';

import '../models/task_item.dart';
import '../state/task_controller.dart';
import 'task_form_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final int taskId;
  final TaskController controller;
  const TaskDetailScreen({super.key, required this.taskId, required this.controller});

  Future<void> confirmDelete(BuildContext context) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus tugas?'),
        content: const Text('Tugas yang dihapus tidak dapat dikembalikan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (yes != true || !context.mounted) return;
    try {
      await controller.delete(taskId);
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, _) {
      final index = controller.tasks.indexWhere((task) => task.id == taskId);
      if (index < 0) {
        return Scaffold(
          appBar: AppBar(title: const Text('Detail Tugas')),
          body: const Center(child: Text('Tugas tidak ditemukan.')),
        );
      }
      final task = controller.tasks[index];
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Tugas'),
          actions: [
            IconButton(
              tooltip: 'Edit',
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => TaskFormScreen(controller: controller, task: task),
                ),
              ),
            ),
            IconButton(
              tooltip: 'Hapus',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => confirmDelete(context),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(task.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 18),
            _detail('Mata kuliah', task.course),
            _detail('Deskripsi', task.description),
            _detail('Deadline', formatDate(task.deadline)),
            _detail('Prioritas', task.priority),
            const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: task.status,
              items: const ['Belum', 'Proses', 'Selesai']
                  .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                  .toList(),
              onChanged: (value) async {
                if (value == null || value == task.status) return;
                try {
                  await controller.changeStatus(task, value);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal mengubah status: $e')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      );
    },
  );

  Widget _detail(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value),
      ],
    ),
  );
}
