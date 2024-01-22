import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

late package_edit pk_select;

class package_edit extends StatefulWidget {
  final String photo_cus;
  final int package_type; // 0 Delivery of a package , 1 Receiving a package
  final String city;
  final String name;
  final String status;
  final String driver;
  final String? driverUsername;
  final int id;
  final String whoWillPay;
  final Function() refreshdata;

  package_edit(
      {super.key,
      required this.photo_cus,
      required this.city,
      required this.name,
      required this.package_type,
      required this.id,
      required this.status,
      required this.driver,
      required this.refreshdata,
      required this.driverUsername,
      required this.whoWillPay});

  @override
  State<package_edit> createState() => _package_editState();
}

class _package_editState extends State<package_edit> {
  List<String> status = [
    "Under review",
    "Rejected by employee",
    "Accepted",
    //'assign to driver'
    "Wait Driver",
    "Rejected by driver",
    "Complete Receive",
    "In Warehouse",
    //"In Warehouse with driver",
    "With Driver",
    "Delivered",
  ];
  String username = GetStorage().read("userName");
  String password = GetStorage().read("password");

  Future post_delete_package(int id) async {
    var url = urlStarter + "/employee/DeletePackage";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "employeeUserName": username,
          "employeePassword": password,
          "packageId": id,
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    if (responce.statusCode == 200) {
      setState(() {
        widget.refreshdata();
      });
    }
  }

  Future post_edit_package(
      int id, String status, String? driver_username, String whoWillPay) async {
    var url = urlStarter + "/employee/editPackage";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "employeeUserName": username,
          "employeePassword": password,
          "packageId": id,
          "packageStatus": status,
          "driverUsername": driver_username,
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    if (responce.statusCode == 200) {
      setState(() {
        widget.refreshdata();
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext) {
    return Container(
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
                    offset: const Offset(0, 1), spreadRadius: 2, blurRadius: 5)
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
                            image: NetworkImage(widget.photo_cus,
                                scale: 1,
                                headers: {
                                  'ngrok-skip-browser-warning': 'true'
                                }),
                          )),
                    ),
                    Spacer(),
                    Text.rich(TextSpan(
                        text: 'Customer name: ',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        children: <InlineSpan>[
                          TextSpan(
                            text: ' ${widget.name}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ])),
                    Spacer(),
                    Text.rich(TextSpan(
                        text: 'Package Type : ',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        children: <InlineSpan>[
                          TextSpan(
                            text: widget.package_type == 0
                                ? 'Package Delivery '
                                : 'Package Received ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ])),
                    Spacer(),
                    Text.rich(TextSpan(
                        text: 'Package ID : ',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        children: <InlineSpan>[
                          TextSpan(
                            text: ' ${widget.id}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ])),
                    Spacer(),
                    Text.rich(TextSpan(
                        text: 'Package status: ',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        children: <InlineSpan>[
                          TextSpan(
                            text: ' ${widget.status}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ])),
                    Spacer(),
                    Visibility(
                      visible: widget.driver != 'null',
                      child: Text.rich(TextSpan(
                          text: 'Driver: ',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          children: <InlineSpan>[
                            TextSpan(
                              text: ' ${widget.driver}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ])),
                    ),
                    Spacer(),
                    Text.rich(TextSpan(
                        text: widget.package_type == 0 ? 'to: ' : 'from: ',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        children: <InlineSpan>[
                          TextSpan(
                            text: '${widget.city}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ])),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: widget.status != 'Under review' &&
                              widget.status != 'Completed' &&
                              widget.status != 'In Warehouse',
                          child: Container(
                            child: MaterialButton(
                              padding: EdgeInsets.all(8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              color: primarycolor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Undo Progress",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              onPressed: () {
                                String before_status = '';
                                int targetIndex = status.indexOf(widget.status);
                                if (targetIndex != -1 && targetIndex > 0) {
                                  before_status = status[targetIndex - 1];
                                }
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
                                                post_edit_package(
                                                    widget.id,
                                                    widget.status,
                                                    widget.driverUsername,
                                                    widget.whoWillPay);
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
                                        title: Text("Edit package Status"),
                                        content: Container(
                                          width: 400,
                                          child: Text(
                                            "Are you sure you want to edit  the package id's ${widget.id} status from state  '${widget.status}' to '${before_status}'",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                        ),
                                        titleTextStyle: TextStyle(
                                            color: Colors.white, fontSize: 25),
                                        contentTextStyle: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                        backgroundColor: primarycolor,
                                      );
                                    });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Visibility(
                          visible: widget.status == "Rejected by employee" ||
                              widget.status == "Rejected by driver" ||
                              widget.status == "Completed",
                          child: Container(
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
                                                post_delete_package(widget.id);
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
                                        title: Text("Delete package"),
                                        content: Container(
                                          width: 400,
                                          child: Text(
                                            "Are you sure you want to delete  the package id's ${widget.id} for customer ${widget.name} , you can't undo this action!",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                        ),
                                        titleTextStyle: TextStyle(
                                            color: Colors.white, fontSize: 25),
                                        contentTextStyle: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                        backgroundColor: primarycolor,
                                      );
                                    });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
