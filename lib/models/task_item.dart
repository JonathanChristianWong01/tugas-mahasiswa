class TaskItem {
  final int? id;
  final String course;
  final String title;
  final String description;
  final DateTime deadline;
  final String priority;
  final String status;

  const TaskItem({
    this.id,
    required this.course,
    required this.title,
    required this.description,
    required this.deadline,
    required this.priority,
    required this.status,
  });

  TaskItem copyWith({String? status}) => TaskItem(
    id: id,
    course: course,
    title: title,
    description: description,
    deadline: deadline,
    priority: priority,
    status: status ?? this.status,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'course': course,
    'title': title,
    'description': description,
    'deadline': deadline.toIso8601String(),
    'priority': priority,
    'status': status,
  };

  factory TaskItem.fromMap(Map<String, Object?> map) => TaskItem(
    id: map['id'] as int,
    course: map['course'] as String,
    title: map['title'] as String,
    description: map['description'] as String,
    deadline: DateTime.parse(map['deadline'] as String),
    priority: map['priority'] as String,
    status: map['status'] as String,
  );
}

String formatDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/${date.year}';
