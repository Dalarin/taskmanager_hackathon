import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:taskmanager_hackathon/models/invite.dart';

import '../providers/constants.dart';

class InviteRepository {
  Future<void> createInvite(String email, int taskId, int userId) async {
    var response = await http.post(
      Uri.parse('$URI/api/invite/create'),
      body: jsonEncode({'email': email, 'taskId': taskId, 'userId': userId}),
      headers: {
        'Authorization': 'Bearer $bearer',
        'Content-Type': 'application/json'
      },
    );
    log(response.body.toString());
    if (response.statusCode == 200) {
      log('Created');
    }
  }
  Future<Object> fetchUserInvited(int userId) async {
    http.Response response = await http.get(
      Uri.parse('$URI/api/invite/get?userId=$userId'),
      headers: {'Authorization': 'Bearer $bearer'},
    );
    if (response.statusCode == 200) {
      return response.body;
    }
    return [];
  }

}

