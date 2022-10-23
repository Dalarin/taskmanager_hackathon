import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:taskmanager_hackathon/pages/authpage.dart';
import 'package:taskmanager_hackathon/providers/LocalDB.dart';
import 'package:taskmanager_hackathon/providers/jwtdecoder.dart';
import 'package:taskmanager_hackathon/repository/userrepository.dart';
import '../elements/navBar.dart' as navBar;
import '../providers/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserRepository userRepository = UserRepository();
  bearer = await StorageManager.readBearer() ?? 'EMPTY';
  if (await userRepository.isAuthorized()) {
    user = await userRepository.getUser(JWTDecoder.parseJwt(bearer)['id']);
  }
  var homePage = (await userRepository.isAuthorized())
      ? const navBar.NavigationBar()
      : const AuthPage();
  runApp(
    MaterialApp(
      theme: ThemeData(fontFamily: "Gotham"),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [Locale('ru', 'RU')],
      home: homePage,
    ),
  );
}
