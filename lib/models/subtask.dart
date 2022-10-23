class SubTask {
  int? id;
  String title;
  bool isCompleted;
  int taskId;

  SubTask(
      { this.id,
      required this.title,
      required this.isCompleted,
      required this.taskId});

  Map<String, dynamic> toMap(int userId) {
    return {'title': title, 'task_id': taskId, 'userId': userId};
  }

  Map<String, dynamic> toMapUpdate() {
    return {'task_id': taskId, 'done': isCompleted, 'id': id!};
  }

  factory SubTask.fromMap(Map<String, dynamic> map) {
    return SubTask(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      isCompleted: map['done'] == 'true' ? true : false,
      taskId: map['taskId'] ?? 0,
    );
  }
}
