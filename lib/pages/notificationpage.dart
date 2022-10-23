import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:taskmanager_hackathon/elements/inviteElement.dart';
import 'package:taskmanager_hackathon/models/user.dart';
import 'package:taskmanager_hackathon/providers/constants.dart';
import 'package:taskmanager_hackathon/repository/inviterepository.dart';
import 'package:taskmanager_hackathon/repository/taskrepository.dart';
import 'package:taskmanager_hackathon/repository/userrepository.dart';

import '../models/invite.dart';
import '../models/task.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late InviteRepository inviteRepository;
  late UserRepository userRepository;
  late TaskRepository taskRepository;

  @override
  void initState() {
    inviteRepository = InviteRepository();
    userRepository = UserRepository();
    taskRepository = TaskRepository();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Уведомления',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 20),
              invitationListView()
            ],
          ),
        ),
      ),
    );
  }

  void refresh() {
    setState((){});
  }

  Widget invitationListView() {
    return FutureBuilder(
      future: inviteRepository.fetchUserInvited(user.id!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          log(snapshot.data.toString());
          List<Invite> invitations =
              (json.decode(snapshot.data.toString()) as List)
                  .map((e) => Invite.fromMap(e))
                  .toList();
          return ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: Future.wait([
                  userRepository.getUser(invitations[index].userId),
                  taskRepository.fetchTaskById(
                    invitations[index].taskId,
                    invitations[index].userId,
                  )
                ]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var snapshotList = snapshot.data as List;
                    Task task = Task.fromMap(
                      json.decode(snapshotList[1].toString())[0],
                    );
                    return InviteElement(
                      invite: invitations[index],
                      fio: snapshotList[0].FIO,
                      taskName: task.title,
                      notifyParent: refresh,
                    );
                  }
                  return emptyContainer();
                },
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 15),
            itemCount: invitations.length,
          );
        }
        return emptyContainer();
      },
    );
  }

  Widget emptyContainer() {
    return Material(
      elevation: 9.0,
      color: Colors.black,
      child: SizedBox(height: 50, width: 50),
    );
  }
}
