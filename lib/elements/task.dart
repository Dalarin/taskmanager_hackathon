import 'package:flutter/material.dart';
import '../pages/task.dart' as page;
import '../models/task.dart' as model;

class Task extends StatefulWidget {
  model.Task task;
  final Function() updated;

   Task({Key? key, required this.task, required this.updated}) : super(key: key);

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  late double width;
  late double height;

  _navigateToTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page.TaskPage(task: widget.task, updated: widget.updated),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: _navigateToTask,
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFC200FD),
        ),
        title: Text(
          widget.task.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(widget.task.description),
        trailing: const Icon(Icons.more_vert_rounded),
      ),
    );
  }
}
