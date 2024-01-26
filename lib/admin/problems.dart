import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin/main_page_admin.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class problems extends StatefulWidget {
  @override
  State<problems> createState() => _problemsState();
}

class _problemsState extends State<problems> {
  List type = ['Read', 'Unread', 'All'];
  List sort = [
    'The recent',
    'The oldest',
  ];
  String sorting = 'The recent';
  String typing = 'All';
  List<content_p> p_new = [
    content_p(
      read: 'unread',
      img: '',
      title: 'p_new',
      id_problem: 3,
      username: 'HHDHD',
      name: '111123',
      date: '2023-02-10',
      refreshdata: () {
        // fetchData_problems();
      },
    ),
    content_p(
      read: 'read',
      img: '',
      title: 'p_new',
      id_problem: 2,
      username: 'HHDHD',
      name: '22222',
      date: '2024-01-08',
      refreshdata: () {
        // fetchData_problems();
      },
    ),
    content_p(
      read: 'unread',
      img: '',
      title: 'p_new',
      id_problem: 2,
      username: 'HHDHD',
      name: '111123',
      date: '2024-02-10',
      refreshdata: () {
        // fetchData_problems();
      },
    ),
  ];
  List<dynamic> p_news = [];

  Future<void> fetchData_problems() async {
    var url = urlStarter + "/admin/managersList";
    print(url);
    final response = await http
        .get(Uri.parse(url), headers: {'ngrok-skip-browser-warning': 'true'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      p_news = data;
      //print(data);
      setState(() {
        p_new = buildMy_problems();
      });
    } else {
      print('new_orders error');
      throw Exception('Failed to load data');
    }
  }

  List<content_p> buildMy_problems() {
    List<content_p> M = [];
    for (int i = 0; i < p_news.length; i++) {
      M.add(
        content_p(
          read: p_news[i]['username'],
          img: urlStarter + p_news[i]['username'],
          title: p_news[i]['username'],
          id_problem: p_news[i]['username'],
          username: p_news[i]['username'],
          name: p_news[i]['name'],
          date: p_news[i]['createdAt'],
          refreshdata: () {
            fetchData_problems();
          },
        ),
      );
    }
    return M;
  }

  String? serach_content;

  @override
  void initState() {
    setState(() {
      TabController_2.index = 2;
    });
    serach_content = '';

    super.initState();
    //fetchData_managers();
  }

  void dispose() {
    super.dispose();
  }

  List<content_p> _filterOrders() {
    // if (selectedCity_from!.isEmpty &&
    //     searchtype!.isEmpty &&
    //     selectedCity_to!.isNotEmpty) {
    //   return pk_new;
    // }

    return p_new.where((order) {
      if (typing == 'Read' && order.read == 'unread') {
        return false;
      }
      if (typing == 'Unread' && order.read == 'read') {
        return false;
      }

      if (serach_content!.isNotEmpty &&
          !order.name.toLowerCase().startsWith(serach_content!.toLowerCase())) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<content_p> filteredReports = _filterOrders();
    sorting == 'The oldest'
        ? filteredReports.sort(
            (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)))
        : filteredReports.sort(
            (b, a) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
    return ListView(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(40, 20, 0, 0),
            width: 300,
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  serach_content = value;
                });
              },
              onSaved: (newValue) {},
              decoration: theme_helper().text_form_style(
                'Serach by name',
                '',
                Icons.search,
              ),
            ),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                width: 200,
                child: DropdownButtonFormField(
                  value: sorting,
                  hint: Text('Sort', style: TextStyle(color: Colors.grey)),
                  decoration: theme_helper().text_form_style(
                    '',
                    '',
                    null,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  onChanged: (newValue) {
                    setState(() {
                      sorting = newValue as String;
                    });
                  },
                  items: sort.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                width: 200,
                child: DropdownButtonFormField(
                  value: typing,
                  hint: Text('Type', style: TextStyle(color: Colors.grey)),
                  decoration: theme_helper().text_form_style(
                    '',
                    '',
                    null,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  onChanged: (newValue) {
                    setState(() {
                      typing = newValue as String;
                    });
                  },
                  items: type.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text.rich(TextSpan(
              text: 'Result: ',
              style: TextStyle(fontSize: 20, color: Colors.grey),
              children: <InlineSpan>[
                TextSpan(
                  text: ' ( ${filteredReports.length} )',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ])),
        ],
      ),
      for (int index = 0; index < filteredReports.length; index++)
        Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              splashColor: primarycolor.withOpacity(0.6),
              child: Ink(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 1),
                        spreadRadius: 2,
                        blurRadius: 5)
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(filteredReports[index].img,
                                    scale: 1,
                                    headers: {
                                      'ngrok-skip-browser-warning': 'true'
                                    }),
                              )),
                        ),
                        Spacer(),
                        Text.rich(TextSpan(
                            text: 'Name: ',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            children: <InlineSpan>[
                              TextSpan(
                                text: ' ${filteredReports[index].name}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ])),
                        Spacer(),
                        Text.rich(TextSpan(
                            text: 'Username: ',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            children: <InlineSpan>[
                              TextSpan(
                                text: filteredReports[index].username,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ])),
                        Spacer(),
                        Text.rich(TextSpan(
                            text: 'Tittle: ',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            children: <InlineSpan>[
                              TextSpan(
                                text: filteredReports[index].title,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ])),
                        Spacer(),
                        Text.rich(TextSpan(
                            text: 'Date: ',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            children: <InlineSpan>[
                              TextSpan(
                                text: filteredReports[index].date,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ])),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              child: MaterialButton(
                                padding: EdgeInsets.all(8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                color: primarycolor,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Show",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                onPressed: () {
                                  GoRouter.of(context).go(
                                      '/problem?id=${filteredReports[index].id_problem}');
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              child: MaterialButton(
                                padding: EdgeInsets.all(8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                color: Colors.red,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "Yes",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                )),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 18),
                                                )),
                                          ],
                                          title: Text("Delete report"),
                                          content: Container(
                                            width: 400,
                                            child: Text(
                                              "Are you sure to delete report",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                          ),
                                          titleTextStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                          contentTextStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                          backgroundColor: primarycolor,
                                        );
                                      });
                                },
                              ),
                            ),
                          ],
                        ),
                        //  Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
    ]);
  }
}

class content_p {
  final String date;
  final int id_problem;
  final String name;
  final String username;
  final String img;
  final String read;
  final Function() refreshdata;
  final String title;

  content_p({
    required this.read,
    required this.img,
    required this.date,
    required this.name,
    required this.username,
    required this.title,
    required this.refreshdata,
    required this.id_problem,
  });
}
