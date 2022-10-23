import 'dart:convert';
import 'dart:developer';
import '../models/list.dart' as model;
import 'package:http/http.dart' as http;
import 'package:taskmanager_hackathon/providers/constants.dart';

class ListRepository {
  Future<Object> fetchListsOfUser(int userId) async {
    http.Response response = await http.get(
      Uri.parse('$URI/api/tasklist/get?userId=$userId'),
      headers: {'Authorization': 'Bearer $bearer'},
    );
    if (response.statusCode == 200) {
      return response.body;
    }
    return [];
  }


  Future<void> deleteList(int taskId, int userId) async {
    await http.delete(
      Uri.parse('$URI/api/tasklist/delete/?userId=$userId&id=$taskId'),
      headers: {
        'Authorization': 'Bearer $bearer',
        'Content-Type': 'application/json'
      },
    );
  }

  Future<void> createList(model.ListModel task) async {
    var response = await http.post(
      Uri.parse('$URI/api/tasklist/create'),
      body: jsonEncode(task.toMap()),
      headers: {
        'Authorization': 'Bearer $bearer',
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      log('Created');
    }
  }
}
