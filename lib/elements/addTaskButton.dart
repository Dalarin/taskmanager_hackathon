import 'package:flutter/material.dart';
import 'package:taskmanager_hackathon/pages/createTaskPage.dart';

class AddButton extends StatefulWidget {
  const AddButton({Key? key}) : super(key: key);

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  late double width;
  late double height;

  _navigateToCreate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateTask(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: _navigateToCreate,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: Color(0xFF9700F7),
        ),
        height: height * 0.06,
        width: width * 0.25,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              '+ Добавить',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
