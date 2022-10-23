import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:taskmanager_hackathon/models/subtask.dart';
import 'package:taskmanager_hackathon/repository/inviterepository.dart';
import 'package:taskmanager_hackathon/repository/listrepository.dart';
import 'package:taskmanager_hackathon/repository/subtaskrepository.dart';
import 'package:taskmanager_hackathon/repository/taskrepository.dart';

import '../elements/choiceChip.dart';
import '../elements/task.dart' as element;

import '../models/list.dart' as model;
import '../models/tag.dart';
import '../models/task.dart' as model;
import '../providers/constants.dart';

class TaskPage extends StatefulWidget {
  model.Task task;
  final Function() updated;

  TaskPage({Key? key, required this.task, required this.updated})
      : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late double height;
  late double width;
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TaskRepository taskRepository;
  late SubTaskRepository subTaskRepository;
  late ListRepository listRepository;
  late InviteRepository inviteRepository;

  @override
  void initState() {
    inviteRepository = InviteRepository();
    listRepository = ListRepository();
    subTaskRepository = SubTaskRepository();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    taskRepository = TaskRepository();
    titleController.text = widget.task.title;
    descriptionController.text = widget.task.description;
    super.initState();
  }

  @override
  void dispose() {
    widget.task.description = descriptionController.text;
    taskRepository.updateTask(widget.task);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.task.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 15),
                Text('Крайний срок сдачи:'),
                Text(DateFormat.yMMMMd('ru').format(widget.task.completeBy)),
                const SizedBox(height: 15),
                actionsPanels(),
                const SizedBox(height: 15),
                Wrap(
                  spacing: 15,
                  children: [
                    ChoiceChipEl(tag: Tag(0, 'Срочно', Colors.red, 0)),
                    ChoiceChipEl(tag: Tag(1, 'Баг', Colors.green, 1)),
                    ChoiceChipEl(tag: Tag(2, 'Не знаю', Colors.blue, 2)),
                    addTagChip()
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  'ПОДЗАДАЧИ',
                  style: TextStyle(fontSize: 15),
                ),
                subTaskListView(),
                addSubtask(),
                const SizedBox(height: 15),
                const Text(
                  'Заметки',
                  style: TextStyle(fontSize: 18),
                ),
                descriptionField(),
                actionWidgets()
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showInviteUserPanel() {
    AlertDialog alert =  AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      title: Text("Приглашение пользователя"),
      content: TextField(
        onSubmitted: (String? text) {
          if (text != null) {
            inviteRepository.createInvite(text, widget.task.id!, user.id!);
            Navigator.of(context).pop();
          }
        },
        decoration: InputDecoration(hintText: 'Email пользователя'),
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget listPanel() {
    return InkWell(
      onTap: listList,
      child: Material(
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        elevation: 9.0,
        child: SizedBox(
          width: width * 0.3,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.list_alt_rounded),
              Text(
                'Списки',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget shareTaskPanel() {
    return InkWell(
      onTap: showInviteUserPanel,
      child: Material(
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        elevation: 9.0,
        child: SizedBox(
          width: width * 0.3,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.share),
              Text(
                'Поделиться задачей',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget actionsPanels() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [shareTaskPanel(), const SizedBox(width: 15), listPanel()],
    );
  }

  AppBar appBar() {
    return AppBar(
      elevation: 0.0,
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.transparent,
    );
  }

  void deleteTask() {
    AlertDialog alert = AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      title: Text("Удаление"),
      actions: [
        TextButton(
          onPressed: () {
            taskRepository.deleteTask(widget.task.id!, 1);
            widget.updated();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: Text('Да'),
        )
      ],
      content: const Text(
        'Вы уверены, что хотите удалить задание?',
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void listList() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, stateSetter) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
            title: Text("Списки"),
            content: futureListView(stateSetter),
          );
        });
      },
    );
  }

  Widget futureListView(StateSetter stateSetter) {
    return FutureBuilder(
      future: listRepository.fetchListsOfUser(user.id!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<model.ListModel> tasks =
              (json.decode(snapshot.data.toString()) as List)
                  .map((e) => model.ListModel.fromMap(e))
                  .toList();
          return Container(
            width: width,
            height: height * 0.3,
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 5),
              itemBuilder: (context, index) {
                return  CheckboxListTile(
                      activeColor: const Color(0xFF9F01F4),
                      checkboxShape: CircleBorder(),
                      title: Text(tasks[index].title),
                      value: false,
                      onChanged: (bool? value) {
                        stateSetter(() {});
                      },
                    );
                  },
              itemCount: tasks.length,
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget actionWidgets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: deleteTask,
          child: SizedBox(
            height: height * 0.1,
            width: width * 0.45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.delete_forever),
                Text('Удалить задачу'),
              ],
            ),
          ),
        ),
        InkWell(
          child: SizedBox(
            height: height * 0.1,
            width: width * 0.45,
            child: Row(
              children: const [
                Icon(Icons.check),
                Text('Отметить задачу\nвыполненной'),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget addSubtask() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: width,
      height: height * 0.07,
      child: TextField(
        onSubmitted: (String text) {
          setState(() {
            subTaskRepository.createSubTask(
              SubTask(title: text, isCompleted: false, taskId: widget.task.id!),
              user.id!,
            );
          });
        },
        decoration: const InputDecoration(
          hintText: '+ Добавить новую подзадачу',
        ),
      ),
    );
  }

  Widget descriptionField() {
    return Container(
      width: width,
      height: height * 0.15,
      child: TextField(
        controller: descriptionController,
        keyboardType: TextInputType.multiline,
        maxLines: null,
      ),
    );
  }

  Widget subTaskListView() {
    return FutureBuilder(
      future: subTaskRepository.fetchSubtasksOfTask(widget.task.id!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<SubTask> tasks = (json.decode(snapshot.data.toString()) as List)
              .map((e) => SubTask.fromMap(e))
              .toList();
          log(tasks.toString());
          return ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return subTask(tasks[index]);
            },
            separatorBuilder: (context, index) => const SizedBox(height: 5),
            itemCount: tasks.length,
          );
        }
        return Container();
      },
    );
  }

  void _refresh() {
    setState((){});
  }

  Widget subTask(SubTask subTask) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      checkboxShape: CircleBorder(),
      title: Text(subTask.title),
      value: subTask.isCompleted,
      onChanged: (bool? value) {
        if (value != null) {
          setState(() {
            _refresh();
            subTask.isCompleted = !subTask.isCompleted;
            subTaskRepository.updateSubTask(subTask);
          });
        }
      },
    );
  }

  Widget addTagChip() {
    return const ChoiceChip(
      label: Text('Добавить тег'),
      avatar: Icon(Icons.add),
      selected: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    );
  }

}
