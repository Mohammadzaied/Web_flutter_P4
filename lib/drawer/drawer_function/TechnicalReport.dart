import 'package:flutter/material.dart';

import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TechnicalReport extends StatefulWidget {
  @override
  _TechnicalReportState createState() => _TechnicalReportState();
}

class _TechnicalReportState extends State<TechnicalReport> {
  List reports = [];
  String? userName;
  TextEditingController _textController2 = TextEditingController();
  String customerUserName = GetStorage().read('userName').toString();
  String customerPassword = GetStorage().read('password');
  bool flag = false;

  Future<void> fetchData() async {
    var url = urlStarter +
        "/admin/getUserTechnicalReports?userName=${customerUserName}";
    final response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'ngrok-skip-browser-warning': 'true'
    });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        reports.clear();
        reports = data['result'];
        flag = false;
      });
    } else if (response.statusCode == 404) {
      setState(() {
        flag = true;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future postDeleteReport(int id) async {
    var url = urlStarter + "/admin/deleteTechnicalReport/${id}";
    var responce = await http.delete(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
    });
    if (responce.statusCode == 200) {
      fetchData();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Technical Reports'),
        backgroundColor: primarycolor,
      ),
      body: Stack(
        children: [
          Visibility(
            visible: !flag,
            child: Expanded(
              child: ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Container(
                      width: 500,
                      child: Card(
                        color: Colors.grey[300],
                        elevation: 3,
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (reports[index]['imageUrl'] != null)
                                Container(
                                  height: 140,
                                  width: 140,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            urlStarter +
                                                reports[index]['imageUrl']
                                                    .toString(),
                                            scale: 1,
                                            headers: {
                                              'ngrok-skip-browser-warning':
                                                  'true'
                                            }),
                                      )),
                                ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(TextSpan(
                                        text: 'Title: ',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text: ' ${reports[index]['Title']}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ])),
                                    // Text(
                                    //   "${reports[index]['Title']}",
                                    //   style: TextStyle(
                                    //       color: primarycolor, fontSize: 28),
                                    // ),
                                    SizedBox(height: 10),
                                    Text.rich(TextSpan(
                                        text: 'Message: ',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text:
                                                ' ${reports[index]['message']}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ])),
                                    // Text.rich(
                                    //   TextSpan(
                                    //     text: "${reports[index]['message']}",
                                    //     style: TextStyle(
                                    //       color: Colors.black,
                                    //       fontSize: 18,
                                    //     ),
                                    //   ),
                                    //   overflow:
                                    //       TextOverflow.visible, // Add this line
                                    // ),
                                    SizedBox(height: 10),
                                    Text.rich(TextSpan(
                                        text: 'Data: ',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text:
                                                '${reports[index]['createdAt'].toString().split('T')[0]}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ])),
                                    SizedBox(height: 10),
                                    Text.rich(TextSpan(
                                        text: 'Time: ',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text:
                                                '${reports[index]['createdAt'].toString().split('T')[1]}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ])),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text.rich(TextSpan(
                                              text: 'Reply: ',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey),
                                              children: <InlineSpan>[
                                                TextSpan(
                                                  text:
                                                      '${reports[index]['reply'] == null ? "No reply yet" : reports[index]['reply']}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              ])),
                                        ),
                                      ],
                                    ),
                                    // Text(
                                    //   "Date: ${reports[index]['createdAt'].toString().split('T')[0]}",
                                    //   style: TextStyle(
                                    //       color: Colors.grey, fontSize: 16),
                                    // ),
                                  ],
                                ),
                              ),
                              // Spacer(),

                              IconButton(
                                icon: Icon(
                                  Icons.delete_sweep,
                                  size: 35,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  postDeleteReport(reports[index]['id']);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          Visibility(
            visible: flag,
            child: Column(
              children: [
                Text(
                  "There are no reports sent",
                  style: TextStyle(color: primarycolor, fontSize: 25),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: Container(
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                color: primarycolor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      Text(
                        'Send New Report',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
                onPressed: () {
                  GoRouter.of(context).go('/send_report');
                  fetchData();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

TextStyle textcolumnstyle() {
  return TextStyle(
    fontSize: 15,
  );
}
