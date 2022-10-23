import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:taskmanager_hackathon/elements/addTaskButton.dart';
import 'package:taskmanager_hackathon/providers/constants.dart';
import 'package:taskmanager_hackathon/repository/taskrepository.dart';

import '../models/task.dart' as model;
import '../elements/task.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late double width;
  late double height;
  late TaskRepository taskRepository;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();


  @override
  void initState() {
    taskRepository = TaskRepository();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    super.initState();
  }

  Future<void> _refresh() async {
    setState((){});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat.yMMMMd('ru').format(_selectedDay),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      const AddButton()
                    ],
                  ),
                  TableCalendar(
                    locale: 'ru',
                    focusedDay: _focusedDay,
                    currentDay: _selectedDay,
                    firstDay: DateTime.now(),
                    headerVisible: false,
                    calendarFormat: CalendarFormat.twoWeeks,
                    lastDay: DateTime(2112),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay =
                            focusedDay; // update `_focusedDay` here as well
                      });
                    },
                  ),
                  selectedDayTasksListView()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }

  Widget selectedDayTasksListView() {
    log('Loading');
    return FutureBuilder(
      future: taskRepository.fetchTasksInSelectedDay(user.id!, _focusedDay),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<model.Task> tasks =
              (json.decode(snapshot.data.toString()) as List)
                  .map((e) => model.Task.fromMap(e))
                  .toList();
          log(tasks.length.toString());
          return ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Task(task: tasks[index], updated: refresh);
            },
            separatorBuilder: (context, index) => const SizedBox(height: 15),
            itemCount: tasks.length,
          );
        }
        return Container();
      },
    );
  }
}
