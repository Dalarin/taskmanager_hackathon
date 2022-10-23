import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:taskmanager_hackathon/models/subtask.dart';
import 'package:taskmanager_hackathon/providers/constants.dart';
import 'package:taskmanager_hackathon/repository/taskrepository.dart';

class SubTaskRepository {
  Future<Object> fetchSubtasksOfTask(int taskId) async {
    http.Response response = await http.get(
      Uri.parse('$URI/api/subtask/get?task_id=$taskId'),
      headers: {'Authorization': 'Bearer $bearer'},
    );
    if (response.statusCode == 200) {
      return response.body;
    }
    return [];
  }

  Future<void> createSubTask(SubTask task, int userId) async {
   var response =  await http.post(
      Uri.parse('$URI/api/subtask/create'),
      body: jsonEncode(task.toMap(userId)),
      headers: {'Authorization': 'Bearer $bearer', 'Content-Type': 'application/json'},
    );
   log(response.body.toString());
   if (response.statusCode == 200) {
     log('Created subtask');
   }
  }

  Future<void> updateSubTask(SubTask task) async {
    var response = await http.put(
      Uri.parse('$URI/api/subtask/update'),
      headers: {'Authorization': 'Bearer $bearer', 'Content-Type': 'application/json'},
      body: jsonEncode(
        task.toMapUpdate(),
      ),
    );
    if (response.statusCode == 200) {
      log('Updated');
    }
  }
}
