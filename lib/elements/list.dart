
import 'package:flutter/material.dart';
import 'package:taskmanager_hackathon/pages/listpage.dart';

import '../models/list.dart';

class List extends StatefulWidget {
  ListModel list;

  List({Key? key, required this.list}) : super(key: key);

  @override
  State<List> createState() => _ListState();
}

class _ListState extends State<List> {
  late double width;
  late double height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: _navigateToList,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFC200FD),
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        width: width * 0.45,
        height: height * 0.3,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: width * 0.35,
                      maxHeight: height * 0.25
                    ),
                    child: Text(
                      widget.list.title,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _navigateToList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListPage(
          list: widget.list,
        ),
      ),
    );
  }
}
