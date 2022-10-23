import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:taskmanager_hackathon/repository/taskrepository.dart';
import '../elements/task.dart';
import '../models/list.dart';
import '../models/task.dart' as model;

class ListPage extends StatefulWidget {
  ListModel list;

  ListPage({Key? key, required this.list}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late TaskRepository taskRepository;

  @override
  void initState() {
    taskRepository = TaskRepository();
    super.initState();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {},
            child: const Icon(Icons.add),
          ),
          InkWell(
            onTap: () {},
            child: const Icon(Icons.delete_forever),
          )
        ],
        elevation: 0.0,
        titleTextStyle: const TextStyle(color: Colors.black),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        title: Text(
          widget.list.title,
          style: const TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          child: FutureBuilder(
            future: taskRepository.fetchTasksByListId(widget.list.id!),
            builder: (context, snapshot) {
              log(snapshot.data.toString());
              if (snapshot.hasData) {
                List<model.Task> task =
                    (json.decode(snapshot.data.toString()) as List)
                        .map((e) => model.Task.fromMap(e))
                        .toList();
                return ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Task(task: task[index], updated: refresh);
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 15),
                  itemCount: task.length,
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
