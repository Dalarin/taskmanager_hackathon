import 'package:flutter/material.dart';

import '../models/tag.dart';

class ChoiceChipEl extends StatefulWidget {
  Tag tag;
  ChoiceChipEl({Key? key, required this.tag}) : super(key: key);

  @override
  State<ChoiceChipEl> createState() => _ChoiceChipElState();
}

class _ChoiceChipElState extends State<ChoiceChipEl> {
  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      avatar: Icon(Icons.cancel),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      disabledColor: widget.tag.color,
      selectedColor: widget.tag.color,
      labelStyle: const TextStyle(color: Colors.white),
      label: Text(widget.tag.title),
      selected: true,
    );
  }
}


