import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:taskmanager_hackathon/elements/task.dart' as element;
import 'package:taskmanager_hackathon/repository/taskrepository.dart';
import '../models/task.dart' as model;
import '../models/user.dart';
import '../providers/constants.dart';

class UserPage extends StatefulWidget {
  User user;

  UserPage({Key? key, required this.user}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late double height;
  late double width;
  late TaskRepository taskRepository;

  @override
  void initState() {
    taskRepository = TaskRepository();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: const [
          InkWell(
            child: Icon(Icons.exit_to_app),
          )
        ],
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [nameWidget(), const SizedBox(height: 15), activeTasks()],
          ),
        ),
      ),
    );
  }

  void confirmExit() {

  }

  Widget activeTasks() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Активные задачи',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 15),
        _taskListView(height, width)
      ],
    );
  }

  Widget completedTasks() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Завершенные задачи',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget nameWidget() {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: const BorderRadius.all(
              Radius.circular(50.0),
            ),
            border: Border.all(
              color: const Color(0xFF9F01F4),
              width: 4.0,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: width * 0.6),
              child: Text(
                '${widget.user.FIO}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text('Задействовано 4 задачи')
          ],
        )
      ],
    );
  }

  void _refresh() {
    setState((){});
  }
  Widget _taskListView(double height, double width) {
    return SizedBox(
      width: width,
      height: height * 0.35,
      child: FutureBuilder(
        future: taskRepository.fetchTasksOfUser(user.id!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<model.Task> tasks =
            (json.decode(snapshot.data.toString()) as List)
                .map((e) => model.Task.fromMap(e))
                .toList();
            if (tasks.isEmpty) return Container();
            return ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemCount: tasks.length,
              shrinkWrap: true,
              itemBuilder: (context, index) => element.Task(
                task: tasks[index],
                updated: _refresh,
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

}
