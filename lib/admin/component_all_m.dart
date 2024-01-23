import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Manager extends StatefulWidget {
  final String photo_cus;
  final String name;
  final String username;
  final String phone;
  final String email;
  final String date;
  final Function() refreshdata;

  Manager({
    super.key,
    required this.photo_cus,
    required this.name,
    required this.phone,
    required this.email,
    required this.refreshdata,
    required this.date,
    required this.username,
  });

  @override
  State<Manager> createState() => _ManagerState();
}

class _ManagerState extends State<Manager> {
  Future post_delete_Manager(String user) async {
    var url = urlStarter + "/admin/deleteManager/${user}";
    var responce = await http.delete(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
    });
    if (responce.statusCode == 200) {
      setState(() {
        widget.refreshdata();
      });
    }
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
                        text: 'Date created: ',
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
                                          post_delete_Manager(widget.username);
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
