import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin/main_page_admin.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//  id: int.parse(state.uri.queryParameters['id'].toString()),
class problem_content extends StatefulWidget {
  final int? id;

  const problem_content({super.key, this.id});

  @override
  State<problem_content> createState() => _problem_contentState();
}

class _problem_contentState extends State<problem_content> {
  String? img;
  String? report_img;
  String? name;
  String? user;
  String? title;
  String? desc;
  String? date;
  String? time;
  String? reply;

  @override
  void initState() {
    setState(() {
      TabController_2.index = 2;
    });

    super.initState();
  }
  // Future post_delete_Manager(String user) async {
  //   var url = urlStarter + "/admin/deleteManager/${user}";
  //   var responce = await http.delete(Uri.parse(url), headers: {
  //     'Content-type': 'application/json; charset=UTF-8',
  //   });
  //   if (responce.statusCode == 200) {}
  // }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 800,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //    Text('xssss')
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage('', scale: 1, headers: {
                                      'ngrok-skip-browser-warning': 'true'
                                    }),
                                  )),
                            ),
                          ],
                        ),
                        Spacer(),
                        Text.rich(TextSpan(
                            text: 'Name: ',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            children: <InlineSpan>[
                              TextSpan(
                                text: ' 111', //${name}
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              )
                            ])),
                        Spacer(),
                        Text.rich(TextSpan(
                            text: 'Username: ',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            children: <InlineSpan>[
                              TextSpan(
                                text: 'DDDDD', // ${user}
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              )
                            ])),
                        Spacer(),
                        Text.rich(TextSpan(
                            text: 'Date: ',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            children: <InlineSpan>[
                              TextSpan(
                                text: ' SSSS', //${date}
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              )
                            ])),
                        Spacer(),
                        Text.rich(TextSpan(
                            text: 'Time: ',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            children: <InlineSpan>[
                              TextSpan(
                                text: '11111111 ', ////${time}
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              )
                            ])),
                        Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: Text.rich(TextSpan(
                                  text: 'Description: ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text:
                                          ' 11111111111111111111111111111111111111112222222222222222222222222222222222222222222222222222222222222222222222222111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111\$',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    )
                                  ])),
                            ),
                          ],
                        ),
                        Spacer(),
                        Container(
                          height: 100,
                          child: Form(
                            child: TextFormField(
                              onSaved: (newValue) {
                                reply = newValue;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter reply";
                                }

                                return null;
                              },
                              maxLines: 4,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Reply',
                                hintText: 'Enter Reply',
                                fillColor: Colors.white,
                                labelStyle: TextStyle(color: Colors.grey),
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 10, 20, 10),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 2)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 2)),
                              ),
                            ),
                          ),
                        ),
                        //Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                    "Send Reply",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                onPressed: () {},
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
                                    "Back",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                onPressed: () {
                                  GoRouter.of(context).go('/problem_reports');
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Visibility(
                      visible: img != null,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'The attached photo',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                height: 400,
                                width: 400,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage('',
                                          scale: 1,
                                          headers: {
                                            'ngrok-skip-browser-warning': 'true'
                                          }), //AssetImage("assets/fff.png"),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
