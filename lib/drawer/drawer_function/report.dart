import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:flutter_application_1/style/header/header.dart';

class report extends StatefulWidget {
  @override
  State<report> createState() => _reportState();
}

class _reportState extends State<report> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Problem'),
        centerTitle: true,
        backgroundColor: primarycolor,
      ),
      body: Column(
        children: [
          Container(
            height: 120,
            child: HeaderWidget(120),
          ),
          Container(
            child: Text('123'),
          ),
        ],
      ),
    );
  }
}
