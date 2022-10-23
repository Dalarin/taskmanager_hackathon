import 'package:flutter/material.dart';
import 'package:taskmanager_hackathon/models/invite.dart';
import 'package:taskmanager_hackathon/repository/taskrepository.dart';

class InviteElement extends StatefulWidget {
  Invite invite;
  String fio;
  String taskName;
  final Function() notifyParent;

  InviteElement(
      {Key? key,
      required this.invite,
      required this.fio,
      required this.taskName,
      required this.notifyParent})
      : super(key: key);

  @override
  State<InviteElement> createState() => _InviteElementState();
}

class _InviteElementState extends State<InviteElement> {
  late TaskRepository taskRepository;

  @override
  void initState() {
    taskRepository = TaskRepository();
    super.initState();
  }

  void acceptInvite() {
    taskRepository.acceptInvite(widget.invite.taskId, widget.invite.userId);
    widget.notifyParent();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      trailing: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children:  [
          Icon(
            Icons.cancel,
            color: Color(0xFF9700F7),
          ),
          InkWell(
            onTap: acceptInvite,
            child: Icon(
              Icons.check,
              color: Colors.green,
            ),
          )
        ],
      ),
      subtitle: Text(
        'Пользователь ${widget.fio} пригласил вас присоединиться к задаче ${widget.taskName}!',
      ),
      title: const Text(
        'Приглашение',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
