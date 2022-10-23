import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:taskmanager_hackathon/models/user.dart';
import 'package:taskmanager_hackathon/providers/LocalDB.dart';
import 'package:taskmanager_hackathon/providers/constants.dart';
import 'package:taskmanager_hackathon/providers/jwtdecoder.dart';
import 'package:taskmanager_hackathon/repository/taskrepository.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  Future<Object> register(User user) async {
    var request = await http.post(
      Uri.parse('$URI/api/user/registration'),
      body: jsonEncode(user.toMap()),
      headers: {'Content-Type': 'application/json'},
    );
    if (request.statusCode == 200) {
      log('Регистрация успешна');
      log('BEARER: ${request.body}');
      bearer = json.decode(request.body)['token'];
      StorageManager.saveBearerToken(json.decode(request.body)['token']);
      return request.body;
    }
    return false;
  }

  Future<User> getUser(int id) async {
    String bearerToken = await StorageManager.readBearer() ?? 'EMPTY BEARER';
    var request = await http.get(
      Uri.parse('$URI/api/user/get_inf?id=$id'),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      },
    );

    return User.fromMap(json.decode(request.body));
  }

  Future<bool> isAuthorized() async {
    try {
      log('Checking authorization..');
      var request = await http.get(
        Uri.parse('$URI/api/user/auth'),
        headers: {
          'Authorization': 'Bearer $bearer',
          'Content-Type': 'application/json'
        },
      );
      if (request.statusCode == 200) {
        bearer = json.decode(request.body)['token'];
        StorageManager.saveBearerToken(json.decode(request.body)['token']);
        log(bearer.toString());
        log('Authorized');
        return true;
      }
      log('Not authorized');
      return false;
    } on SocketException {
      log('No ethernet connection');
      return false;
    } catch (E) {
      log(E.toString());
      return false;
    }
  }

  Future<bool> authorize(String email, String password) async {
    log('Authorizing..');
    var request = await http.post(
      Uri.parse('$URI/api/user/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        {'email': email, 'password': password},
      ),
    );
    if (request.statusCode == 200) {
      log(request.body.toString());
      bearer = json.decode(request.body)['token'];
      user = await getUser(JWTDecoder.parseJwt(bearer)['id']);
      StorageManager.saveBearerToken(bearer);
      log('Authorized');
      return true;
    }
    return false;
  }
}
