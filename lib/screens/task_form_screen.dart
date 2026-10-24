import 'package:flutter/material.dart';

import '../models/task_item.dart';
import '../state/task_controller.dart';

class TaskFormScreen extends StatefulWidget {
  final TaskController controller;
  final TaskItem? task;
  const TaskFormScreen({super.key, required this.controller, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController courseController;
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  DateTime? deadline;
  String priority = 'Sedang';
  String status = 'Belum';
  bool saving = false;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    courseController = TextEditingController(text: task?.course ?? '');
    titleController = TextEditingController(text: task?.title ?? '');
    descriptionController = TextEditingController(text: task?.description ?? '');
    deadline = task?.deadline;
    priority = task?.priority ?? 'Sedang';
    status = task?.status ?? 'Belum';
  }

  @override
  void dispose() {
    courseController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> pickDeadline() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: deadline ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selected != null && mounted) setState(() => deadline = selected);
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    if (deadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih tanggal deadline terlebih dahulu.')),
      );
      return;
    }
    setState(() => saving = true);
    final task = TaskItem(
      id: widget.task?.id,
      course: courseController.text.trim(),
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      deadline: deadline!,
      priority: priority,
      status: status,
    );
    try {
      if (widget.task == null) {
        await widget.controller.add(task);
      } else {
        await widget.controller.update(task);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.task == null ? 'Tambah Tugas' : 'Edit Tugas')),
    body: Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: courseController,
            decoration: const InputDecoration(
              labelText: 'Mata kuliah', border: OutlineInputBorder(),
            ),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Mata kuliah wajib diisi' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Judul tugas', border: OutlineInputBorder(),
            ),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Judul wajib diisi' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: descriptionController,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Deskripsi', border: OutlineInputBorder(),
            ),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Deskripsi wajib diisi' : null,
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            icon: const Icon(Icons.calendar_month),
            label: Text(deadline == null
                ? 'Pilih deadline *'
                : 'Deadline: ${formatDate(deadline!)}'),
            onPressed: pickDeadline,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: priority,
            decoration: const InputDecoration(
              labelText: 'Prioritas', border: OutlineInputBorder(),
            ),
            items: const ['Rendah', 'Sedang', 'Tinggi']
                .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                .toList(),
            onChanged: (value) => setState(() => priority = value ?? 'Sedang'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: status,
            decoration: const InputDecoration(
              labelText: 'Status', border: OutlineInputBorder(),
            ),
            items: const ['Belum', 'Proses', 'Selesai']
                .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                .toList(),
            onChanged: (value) => setState(() => status = value ?? 'Belum'),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            icon: const Icon(Icons.save),
            label: Text(saving ? 'Menyimpan...' : 'Simpan tugas'),
            onPressed: saving ? null : save,
          ),
        ],
      ),
    ),
  );
}
