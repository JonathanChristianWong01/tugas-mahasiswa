import 'package:flutter/material.dart';

import '../models/task_item.dart';
import '../state/task_controller.dart';
import 'task_detail_screen.dart';
import 'task_form_screen.dart';

class TaskListScreen extends StatefulWidget {
  final TaskController controller;
  const TaskListScreen({super.key, required this.controller});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String filter = 'Semua';

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Tugas Mahasiswa')),
    body: AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final controller = widget.controller;
        if (controller.isLoading && controller.tasks.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error != null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(controller.error!, textAlign: TextAlign.center),
                TextButton(onPressed: controller.load, child: const Text('Coba lagi')),
              ],
            ),
          );
        }
        final visible = controller.tasks
            .where((task) => filter == 'Semua' || task.status == filter)
            .toList();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  Text('${controller.tasks.length} tugas',
                      style: Theme.of(context).textTheme.titleMedium),
                  const Spacer(),
                  DropdownButton<String>(
                    value: filter,
                    items: const ['Semua', 'Belum', 'Proses', 'Selesai']
                        .map((value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ))
                        .toList(),
                    onChanged: (value) => setState(() => filter = value ?? 'Semua'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: visible.isEmpty
                  ? Center(
                child: Text(controller.tasks.isEmpty
                    ? 'Belum ada tugas. Tekan + untuk menambahkan.'
                    : 'Tidak ada tugas dengan status $filter.'),
              )
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 88),
                itemCount: visible.length,
                itemBuilder: (context, index) {
                  final task = visible[index];
                  return Card(
                    child: ListTile(
                      title: Text(task.title,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(
                        '${task.course} • ${formatDate(task.deadline)}\n'
                            '${task.status} • Prioritas ${task.priority}',
                      ),
                      isThreeLine: true,
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => TaskDetailScreen(
                            taskId: task.id!,
                            controller: controller,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => TaskFormScreen(controller: widget.controller),
        ),
      ),
      icon: const Icon(Icons.add),
      label: const Text('Tambah tugas'),
    ),
  );
}
