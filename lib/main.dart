import 'package:flutter/material.dart';

import 'data/task_database.dart';
import 'data/task_repository.dart';
import 'screens/task_list_screen.dart';
import 'state/task_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TugasMahasiswaApp());
}

class TugasMahasiswaApp extends StatefulWidget {
  const TugasMahasiswaApp({super.key});

  @override
  State<TugasMahasiswaApp> createState() => _TugasMahasiswaAppState();
}

class _TugasMahasiswaAppState extends State<TugasMahasiswaApp> {
  late final TaskController controller;

  @override
  void initState() {
    super.initState();
    controller = TaskController(TaskRepository(TaskDatabase.instance))..load();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Tugas Mahasiswa',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF286B60)),
      useMaterial3: true,
    ),
    home: TaskListScreen(controller: controller),
  );
}
