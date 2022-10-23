

import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static void saveData(String key, dynamic value) async {
    log('Data $key saved ${value.toString()}');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    }
  }

  static void saveBearerToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('BEARER', value);
  }

  static Future<String?> readBearer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('BEARER');
  }

  static Future<dynamic> readData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic object = prefs.get(key);
    return object;
  }

}