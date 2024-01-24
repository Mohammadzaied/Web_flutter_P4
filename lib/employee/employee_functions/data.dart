import 'package:flutter/material.dart';

class data_show extends StatefulWidget {
  final String name;

  const data_show({super.key, this.name = 'd'});
  @override
  State<data_show> createState() => _data_showState();
}

class _data_showState extends State<data_show> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text('${widget.name}'));
  }
}
