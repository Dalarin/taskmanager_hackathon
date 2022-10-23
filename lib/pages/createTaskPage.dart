import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskmanager_hackathon/repository/taskrepository.dart';
import '../models/task.dart';
import '../providers/constants.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({Key? key}) : super(key: key);

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  late double width;
  late double heigth;
  late DateTime _startDate;
  late DateTime _selectedDate;
  late TextEditingController titleController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late TextEditingController descriptionController;
  late TaskRepository taskRepository;

  @override
  void initState() {
    taskRepository = TaskRepository();
    _startDate = DateTime.now();
    _selectedDate = DateTime.now();
    titleController = TextEditingController();
    startDateController = TextEditingController();
    endDateController = TextEditingController();
    descriptionController = TextEditingController();
    startDateController.text =
        DateFormat.yMMMMd('ru').format(DateTime.now()).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    heigth = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFA300FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA300FF),
        elevation: 0.0,
        centerTitle: true,
        title: const Text("Создание новой задачи"),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _inputField(25, 'Название', Colors.white, titleController),
              bottomContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context,
      TextEditingController controller, int dateField) async {
    final DateTime? picked = await showDatePicker(
      locale: const Locale('ru'),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light().copyWith(
            primary: const Color(0xFFA300FF),
          )),
          child: child!,
        );
      },
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat.yMMMMd('ru').format(picked).toString();
        if (dateField == 1) {
          _startDate = picked;
        } else {
          _selectedDate = picked;
        }
      });
    }
  }

  Widget _inputField(double padding, String hintText, Color hintColor,
      TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: hintColor),
          hintText: hintText,
        ),
      ),
    );
  }

  Widget _inputFieldDate(TextEditingController controller, int date) {
    return SizedBox(
      height: heigth * 0.13,
      width: width * 0.35,
      child: TextField(
        enableInteractiveSelection: false,
        readOnly: true,
        onTap: () => _selectDate(context, controller, date),
        enabled: true,
        controller: controller,
        decoration: const InputDecoration(
          label: Text('Дата'),
          labelStyle: TextStyle(fontSize: 13),
          suffixIcon: Icon(Icons.alarm),
        ),
      ),
    );
  }

  Widget createTaskButton() {
    return InkWell(
      onTap: () {
        taskRepository.createTask(
          Task(
            createdBy: user.id!,
            title: titleController.text,
            description: descriptionController.text,
            completeBy: _selectedDate,
            dayOfStart: _startDate,
            isCompleted: false,
          ),
        );
        Navigator.of(context).pop();
      },
      child: Container(
        alignment: Alignment.center,
        height: heigth * 0.07,
        width: width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: Color(0xFFA300FF),
        ),
        child: const Text(
          'Добавить задачу',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget bottomContainer() {
    return Container(
      height: heigth * 0.6,
      width: width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _inputFieldDate(startDateController, 1),
                    _inputFieldDate(endDateController, 2)
                  ],
                ),
                _inputField(0, 'Описание', Colors.black, descriptionController),
                const SizedBox(height: 25),
                // const Text(
                //   'Категории',
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //     fontSize: 20,
                //   ),
                // ),
                // Wrap(
                //   spacing: 15,
                //   children: [
                //     ChoiceChipEl(
                //       tag: Tag(0, 'Срочно', Colors.red, 0),
                //     ),
                //     ChoiceChipEl(tag: Tag(1, 'Баг', Colors.green, 1)),
                //     ChoiceChipEl(tag: Tag(2, 'Не знаю', Colors.blue, 2))
                //   ],
                // ),
              ],
            ),
            Column(
              children: [createTaskButton()],
            )
          ],
        ),
      ),
    );
  }
}
