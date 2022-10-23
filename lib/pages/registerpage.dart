import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskmanager_hackathon/providers/LocalDB.dart';
import 'package:taskmanager_hackathon/providers/constants.dart';
import 'package:taskmanager_hackathon/providers/jwtdecoder.dart';
import '../elements/navBar.dart' as elements;
import 'package:taskmanager_hackathon/models/user.dart';
import 'package:taskmanager_hackathon/repository/userrepository.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double width;
  late double height;
  late UserRepository userRepository;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController fioController;
  late TextEditingController passwordController;
  late bool errorMessage;

  @override
  void initState() {
    errorMessage = false;
    userRepository = UserRepository();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    fioController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 25,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [topContainer()],
            ),
          ),
        ),
      ),
    );
  }

  Widget passwordTextField() {
    return TextField(
      controller: passwordController,
      decoration: const InputDecoration(
        fillColor: Color(0xFFF4F9FC),
        filled: true,
        hintText: 'Пароль',
        prefixIcon: Icon(Icons.key),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
    );
  }

  void register() async {
    user = User(
      FIO: fioController.text,
      phone: phoneController.text,
      email: emailController.text,
      password: passwordController.text,
    );
    var token = json.decode((await userRepository.register(user)).toString());
    user.id = User.fromMap(JWTDecoder.parseJwt(token['token'])).id;
    if (user.id != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => elements.NavigationBar(),
        ),
      );
    } else {
      setState(() {
        errorMessage = true;
      });
    }
  }

  Widget signUpButton() {
    return InkWell(
      onTap: register,
      child: Container(
        height: height * 0.08,
        width: width,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xFF9700F7),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: const Text(
          'Регистрация',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget emailTextField() {
    return TextField(
      controller: emailController,
      decoration: const InputDecoration(
        fillColor: Color(0xFFF4F9FC),
        filled: true,
        hintText: 'Email',
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget nameLastNameTextField() {
    return TextField(
      controller: fioController,
      decoration: const InputDecoration(
        fillColor: Color(0xFFF4F9FC),
        filled: true,
        hintText: 'Имя и фамилия',
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget phoneTextField() {
    return TextField(
      controller: phoneController,
      decoration: const InputDecoration(
        fillColor: Color(0xFFF4F9FC),
        filled: true,
        hintText: 'Номер телефона',
        prefixIcon: Icon(Icons.phone),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget topContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Регистрация',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        const SizedBox(height: 15),
        const Text('Пожалуйста, заполните данные для входа'),
        const SizedBox(height: 25),
        emailTextField(),
        const SizedBox(height: 25),
        phoneTextField(),
        const SizedBox(height: 25),
        nameLastNameTextField(),
        const SizedBox(height: 25),
        passwordTextField(),
        const SizedBox(height: 25),
        signUpButton(),
        const SizedBox(height: 25),
        errorMessageWidget()
      ],
    );
  }

  Widget errorMessageWidget() {
    if (errorMessage) {
      return const Text('Ошибка регистрации');
    }
    return Container();
  }
}
