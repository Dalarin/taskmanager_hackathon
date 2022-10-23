import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:taskmanager_hackathon/providers/constants.dart';

import '../models/task.dart';

class TaskRepository {
  Future<Object> fetchTasksOfUser(int userId) async {
    http.Response response = await http.get(
      Uri.parse('$URI/api/task/get?userId=$userId'),
      headers: {'Authorization': 'Bearer $bearer'},
    );
    if (response.statusCode == 200) {
      log('Data fetched');
      return response.body;
    }
    return [];
  }

  Future<Object> fetchTaskById(int taskId, int userId) async {
    http.Response response = await http.get(
      Uri.parse('$URI/api/task/get?userId=$userId&taskId=$taskId'),
      headers: {'Authorization': 'Bearer $bearer'},
    );
    if (response.statusCode == 200) {
      return response.body;
    }
    return [];
  }

  Future<Object> fetchTasksByListId(int listId) async {
    http.Response response = await http.get(
      Uri.parse('$URI/api/task/get_list_of_task?listId=$listId'),
      headers: {'Authorization': 'Bearer $bearer'},
    );
    log(response.body.toString());

    if (response.statusCode == 200) {
      return response.body;
    }
    return [];
  }

  Future<bool> checkIfContains(int listId, int taskId) async {
    http.Response response = await http.get(
      Uri.parse('$URI/api/task/check_if_cont?listId=$listId&taskId=$taskId'),
      headers: {'Authorization': 'Bearer $bearer'},
    );
    log(response.body.toString());
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<Object> fetchTasksInSelectedDay(int userId, DateTime dateTime) async {
    http.Response response = await http.get(
      Uri.parse(
        '$URI/api/task/datesort?userId=$userId&date_of_finish=${dateTime.toString().substring(0, dateTime.toString().length - 1)}',
      ),
      headers: {'Authorization': 'Bearer $bearer'},
    );
    if (response.statusCode == 200) {
      return response.body;
    }
    return [];
  }

  Future<void> acceptInvite(int taskId, int userId) async {
    var response = await http.post(
      Uri.parse('$URI/api/task/accept_invite'),
      body: jsonEncode({'taskId': taskId, 'userId': userId}),
      headers: {
        'Authorization': 'Bearer $bearer',
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      log('Created');
    }
  }

  Future<void> deleteTask(int taskId, int userId) async {
    await http.delete(
      Uri.parse('$URI/api/task/delete/?userId=$userId&id=$taskId'),
      headers: {
        'Authorization': 'Bearer $bearer',
        'Content-Type': 'application/json'
      },
    );
  }

  Future<void> createTask(Task task) async {
    var response = await http.post(
      Uri.parse('$URI/api/task/create'),
      body: jsonEncode(task.toMap()),
      headers: {
        'Authorization': 'Bearer $bearer',
        'Content-Type': 'application/json'
      },
    );
    log(response.statusCode.toString());
    log(response.body.toString());
    if (response.statusCode == 200) {
      log('Created');
    }
  }

  Future<void> updateTask(Task task) async {
    log('Updating');
    var response = await http.put(
      Uri.parse('$URI/api/task/update'),
      headers: {
        'Authorization': 'Bearer $bearer',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(task.toMapUpdate()),
    );
    if (response.statusCode == 200) {
      log('Updated');
    }
  }
}
