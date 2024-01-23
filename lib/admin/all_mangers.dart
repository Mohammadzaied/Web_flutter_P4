import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin/component_all_m.dart';
import 'package:flutter_application_1/admin/main_page_admin.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class all_managers extends StatefulWidget {
  @override
  State<all_managers> createState() => _all_managersState();
}

class _all_managersState extends State<all_managers> {
  List<Manager> M_new = [];
  List<dynamic> M_news = [];

  Future<void> fetchData_managers() async {
    var url = urlStarter + "/admin/managersList";
    print(url);
    final response = await http
        .get(Uri.parse(url), headers: {'ngrok-skip-browser-warning': 'true'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      M_news = data;
      print(data);
      setState(() {
        M_new = buildMy_Managers();
      });
    } else {
      print('new_orders error');
      throw Exception('Failed to load data');
    }
  }

  List<Manager> buildMy_Managers() {
    List<Manager> M = [];
    for (int i = 0; i < M_news.length; i++) {
      M.add(
        Manager(
          username: M_news[i]['username'],
          name: M_news[i]['name'],
          email: M_news[i]['email'],
          phone: M_news[i]['phoneNumber'].toString(),
          photo_cus: urlStarter + M_news[i]['img'],
          date: M_news[i]['createdAt'],
          refreshdata: () {
            fetchData_managers();
          },
        ),
      );
    }
    return M;
  }

  @override
  void initState() {
    setState(() {
      TabController_2.index = 0;
    });
    super.initState();
    fetchData_managers();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text.rich(TextSpan(
                text: 'Result: ',
                style: TextStyle(fontSize: 20, color: Colors.grey),
                children: <InlineSpan>[
                  TextSpan(
                    text: ' ( ${M_new.length} )',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ])),
          ],
        ),
      ),
      ...M_new.map((order) {
        return order;
      }).toList(),
    ]);
  }
}
