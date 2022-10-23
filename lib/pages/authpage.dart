import 'package:flutter/material.dart';
import 'package:taskmanager_hackathon/pages/registerpage.dart';
import 'package:taskmanager_hackathon/repository/userrepository.dart';
import '../elements/navBar.dart' as element;

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late double width;
  late double height;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late UserRepository userRepository;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    userRepository = UserRepository();
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
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [topContainer(), bottomContainer()],
          ),
        ),
      ),
    );
  }

  void makeAuth() async {
    bool authorized = await userRepository.authorize(
        emailController.text, passwordController.text);
    if (authorized) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => element.NavigationBar(),
        ),
      );
    }
  }

  void navigateToRegisterPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const RegisterPage(),
      ),
    );
  }

  Widget topContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Авторизация',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        const SizedBox(height: 15),
        const Text('Пожалуйста, заполните данные для входа'),
        const SizedBox(height: 25),
        usernameTextField(),
        const SizedBox(height: 25),
        passwordTextField(),
        const SizedBox(height: 25),
        signInButton()
      ],
    );
  }

  Widget bottomContainer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Еще нет аккаунта?'),
        TextButton(
          onPressed: navigateToRegisterPage,
          child: const Text('Зарегистрироваться'),
        )
      ],
    );
  }

  Widget signInButton() {
    return InkWell(
      onTap: makeAuth,
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
          'Авторизоваться',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
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

  Widget usernameTextField() {
    return TextField(
      controller: emailController,
      decoration: const InputDecoration(
        fillColor: Color(0xFFF4F9FC),
        filled: true,
        hintText: 'Email пользователя',
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
    );
  }
}
