class Task {
  int? id;
  int createdBy;
  String title;
  String description;
  DateTime completeBy;
  DateTime dayOfStart;
  bool isCompleted;

  Task({
    this.id,
    required this.createdBy,
    required this.title,
    required this.description,
    required this.completeBy,
    required this.dayOfStart,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': title,
      'description': description,
      'date_of_start': dayOfStart.toString(),
      'date_of_finish': completeBy.toString(),
      'done': isCompleted ? 'true' : 'false',
      'userId': createdBy.toString()
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return {
      'id': id!,
      'name': title,
      'description': description,
      'date_of_start': dayOfStart.toString(),
      'date_of_finish': completeBy.toString(),
      'done': isCompleted ? 'true' : 'false',
      'userId': createdBy.toString()
    };
  }


  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id']?.toInt() ?? 0,
      createdBy: map['userId'] ?? 0,
      title: map['name'] ?? '',
      description: map['description'] ?? '',
      completeBy: DateTime.parse(map['date_of_finish'] ?? DateTime.now()),
      dayOfStart: DateTime.parse(map['date_of_start'] ?? DateTime.now()),
      isCompleted: map['done'] == 'false' ? false : true,
    );
  }
}
