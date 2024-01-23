import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Manager extends StatefulWidget {
  final String photo_cus;
  final String city;
  final String name;
  final String phone;
  final String email;
  final String number_employee;
  final String number_drivers;
  final String date;

  final Function() refreshdata;

  Manager({
    super.key,
    required this.photo_cus,
    required this.city,
    required this.name,
    required this.phone,
    required this.email,
    required this.number_employee,
    required this.number_drivers,
    required this.refreshdata,
    required this.date,
  });

  @override
  State<Manager> createState() => _ManagerState();
}

class _ManagerState extends State<Manager> {
  // String username = GetStorage().read("userName");
  // String password = GetStorage().read("password");

  // Future post_delete_package(int id) async {
  //   var url = urlStarter + "/employee/DeletePackage";
  //   var responce = await http.post(Uri.parse(url),
  //       body: jsonEncode({
  //         "employeeUserName": username,
  //         "employeePassword": password,
  //         "packageId": id,
  //       }),
  //       headers: {
  //         'Content-type': 'application/json; charset=UTF-8',
  //       });
  //   if (responce.statusCode == 200) {
  //     setState(() {
  //       widget.refreshdata();
  //     });
  //   }
  // }

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
                        text: 'Manager name: ',
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
                        text: 'Email : ',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        children: <InlineSpan>[
                          TextSpan(
                            text: widget.email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ])),
                    Spacer(),
                    Text.rich(TextSpan(
                        text: 'Phone : ',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        children: <InlineSpan>[
                          TextSpan(
                            text: ' ${widget.phone}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ])),
                    Spacer(),
                    Text.rich(TextSpan(
                        text: 'City: ',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        children: <InlineSpan>[
                          TextSpan(
                            text: ' ${widget.city}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ])),
                    Spacer(),
                    Text.rich(TextSpan(
                        text: 'Number of emplyees',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        children: <InlineSpan>[
                          TextSpan(
                            text: widget.number_employee,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ])),
                    Spacer(),
                    Text.rich(TextSpan(
                        text: 'Number of drivers',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        children: <InlineSpan>[
                          TextSpan(
                            text: widget.number_drivers,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ])),
                    Spacer(),
                    Text.rich(TextSpan(
                        text: 'Date created',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        children: <InlineSpan>[
                          TextSpan(
                            text: widget.date,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ])),
                    Spacer(),
                    Text.rich(TextSpan(
                        text: 'Date created',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        children: <InlineSpan>[
                          TextSpan(
                            text: widget.date,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ])),
                    Spacer(),
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
                                    borderRadius: BorderRadius.circular(20.0),
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
                                              color: Colors.red, fontSize: 18),
                                        )),
                                  ],
                                  title: Text("Delete Manager"),
                                  content: Container(
                                    width: 400,
                                    child: Text(
                                      "Are you sure you want to delete  the manager name's ${widget.name} from system",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
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
