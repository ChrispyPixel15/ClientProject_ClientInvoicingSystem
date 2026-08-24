class TaskItem {
  final String task;

  TaskItem({
    required this.task,
  });

  Map<String, dynamic> toMap() {
    return {
      'task': task,
    };
  }

  factory TaskItem.fromMap(Map<String, dynamic> map) {
    return TaskItem(
      task: map['task'],
    );
  }
}