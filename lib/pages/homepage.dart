import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:taskmanager_hackathon/elements/task.dart';
import 'package:taskmanager_hackathon/models/user.dart';
import 'package:taskmanager_hackathon/pages/userpage.dart';
import 'package:taskmanager_hackathon/providers/constants.dart';
import 'package:taskmanager_hackathon/repository/listrepository.dart';
import 'package:taskmanager_hackathon/repository/taskrepository.dart';
import '../elements/task.dart' as element;
import '../models/task.dart' as model;

import '../models/list.dart' as model;

import '../elements/list.dart' as element;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double width;
  late double height;
  late TextEditingController listTitleController;
  late ListRepository listRepository;
  late TaskRepository taskRepository;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    listTitleController = TextEditingController();
    listRepository = ListRepository();
    taskRepository = TaskRepository();
    setState(() {});
    super.initState();
  }

  Future<void> _refresh() async {
   setState((){});
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: appBar(),
      backgroundColor: const Color(0xFFF3F3FF),
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.05),
                  Text(
                    'Привет, ${user.FIO}',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text('Хорошего дня'),
                  const SizedBox(height: 25),
                  _listListView(height, width),
                  const SizedBox(height: 25),
                  const Text(
                    'Прогресс',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _taskListView(height, width)
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
            if (tasks.isEmpty) return emptyTask();
            return ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemCount: tasks.length,
              shrinkWrap: true,
              itemBuilder: (context, index) => element.Task(
                task: tasks[index],
                updated: refresh,
              ),
            );
          }
          return emptyTask();
        },
      ),
    );
  }

  Widget emptyTask() {
    return Material(
      elevation: 9,
      borderRadius: const BorderRadius.all(
        Radius.circular(20),
      ),
      child: Container(
        alignment: Alignment.center,
        height: height * 0.3,
        width: 30,
        child: const Text(
          'Задания отсутствуют.\nВо вкладке РАСПИСАНИЕ вы можете создать их!',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }

  _navigateToUser() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserPage(user: user),
      ),
    );
  }

  Widget _listListView(double height, double width) {
    return Container(
      height: height * 0.25,
      width: width,
      child: FutureBuilder(
        future: listRepository.fetchListsOfUser(user.id!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<model.ListModel> tasks =
                (json.decode(snapshot.data.toString()) as List)
                    .map((e) => model.ListModel.fromMap(e))
                    .toList();
            return ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(width: 15),
              itemCount: tasks.length + 1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index == tasks.length) {
                  return InkWell(
                    onTap: _createListDialog,
                    child: Material(
                      elevation: 9.0,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        width: width * 0.45,
                        height: height * 0.3,
                        child: const Text(
                          'Добавить список',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return element.List(list: tasks[index]);
              },
            );
          }
          return Container();
        },
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      leading: const Icon(
        Icons.menu,
        color: Colors.black,
      ),
      actions: [
        InkWell(
          onTap: _navigateToUser,
          child: const CircleAvatar(
            backgroundColor: Color(0xFF9F01F4),
            child: Icon(Icons.person),
          ),
        )
      ],
    );
  }

  Widget titleTextField() {
    return TextField(
      controller: listTitleController,
      decoration: const InputDecoration(
        hintStyle: TextStyle(color: Colors.black),
        hintText: 'Название списка',
      ),
    );
  }

  void createList() {
    setState(() {
      listRepository.createList(
        model.ListModel(
          title: listTitleController.text,
          creator: user.id!,
        ),
      );
      Navigator.of(context).pop();
    });
  }

  void _createListDialog() {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 25,
                  horizontal: 15,
                ),
                height: height * 0.3,
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Создание списка',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            child: const Icon(Icons.check_circle_outline),
                            onTap: createList,
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      titleTextField()
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
