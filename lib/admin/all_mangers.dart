import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin/component_all_m.dart';
import 'package:flutter_application_1/employee/main_page_employee.dart';
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
    var url = urlStarter + "/employee/getNewOrders";
    print(url);
    final response = await http
        .get(Uri.parse(url), headers: {'ngrok-skip-browser-warning': 'true'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      M_news = data['result'];
      print(M_news);
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
    //M_news
    for (int i = 0; i < 10; i++) {
      M.add(
        Manager(
          name: 'Mahmoud',
          email: 'eaasss@gmail.com',
          phone: '1111111111111',
          photo_cus: "",
          city: 'Tulkarm',
          number_drivers: '10',
          number_employee: '5',
          date: '2024-01-12',
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
    super.initState();
    setState(() {
      TabController_.index = 0;
    });
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Row(
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
      ...M_new.map((order) {
        return order;
      }).toList(),
    ]);
  }
}
