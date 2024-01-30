import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin/main_page_admin.dart';
import 'package:flutter_application_1/employee/main_page_employee.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';

import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  String? username;
  String? title;
  String? desc;
  String? date;
  String? time;
  String? reply;
  // String? reply_data;
  var controller = new TextEditingController();
  @override
  void initState() {
    setState(() {
      TabController_2.index = 2;
    });
    get_problem(widget.id!);
    super.initState();
  }

  String formatDate(DateTime dateTime) {
    // Format the DateTime object as a string in 'yyyy-MM-dd' format
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  String formatTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour < 12 ? 'AM' : 'PM'}';
  }

  Future postreply(int id, String rep) async {
    var url = urlStarter + "/admin/sendReplyTechnicalReport";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "id": id,
          "reply": reply,
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    var responceBody = jsonDecode(responce.body);
    if (responceBody['message'] == "Success") {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(27.0), // Adjust the radius as needed
              ),
              title: Text('Done'),
              content: Text('Reply Done!'),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
              contentTextStyle: TextStyle(color: Colors.white, fontSize: 16),
              backgroundColor: primarycolor,
              actions: [
                TextButton(
                  child: Text(
                    "Ok",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    GoRouter.of(context).go('/problem_reports');
                  },
                ),
              ],
            );
          });
    }
    //print(responceBody);
  }

  GlobalKey<FormState> formState = GlobalKey();

  Future get_problem(int user) async {
    var url = urlStarter + "/admin/getTechnicalReport?id=${user}";
    var response = await http
        .get(Uri.parse(url), headers: {'ngrok-skip-browser-warning': 'true'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      DateTime dateTime = DateTime.parse(data['createdAt']);
      String datePart = formatDate(dateTime);
      String timePart = formatTime(dateTime);
      setState(() {
        img = urlStarter + data['img'];
        report_img = data['imageUrl'];
        name = data['name'];
        username = data['username'];
        title = data['title'];
        desc = data['message'];
        date = datePart;
        time = timePart;
        reply = data['reply'];
        controller.text = (reply != null ? reply! : '');
      });
    }
  }

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
                            Container(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(img != null ? img! : '',
                                        scale: 1,
                                        headers: {
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
                                text: '${name}', //${name}
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
                                text: '${username}', // ${user}
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
                                text: '${date}', //${date}
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
                                text: '${time}', ////${time}
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
                                      text: '${desc}\$',
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
                        // if (reply != null)
                        //   Row(
                        //     children: [
                        //       Expanded(
                        //         child: Text.rich(TextSpan(
                        //             text: 'Reply: ',
                        //             style: TextStyle(
                        //                 fontSize: 20,
                        //                 fontWeight: FontWeight.bold,
                        //                 color: Colors.grey),
                        //             children: <InlineSpan>[
                        //               TextSpan(
                        //                 text: '${reply}',
                        //                 style: TextStyle(
                        //                   fontSize: 18,
                        //                   color: Colors.black,
                        //                 ),
                        //               )
                        //             ])),
                        //       ),
                        //     ],
                        //   ),
                        // if (reply_data != null)
                        Spacer(),
                        Container(
                          height: 100,
                          child: Form(
                            key: formState,
                            child: TextFormField(
                              controller: controller,
                              // initialValue: reply != null ? reply : '123',
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
                                onPressed: () {
                                  if (formState.currentState!.validate()) {
                                    formState.currentState!.save();
                                    postreply(widget.id!, reply!);
                                  }
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
                                    "Back",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                onPressed: () {
                                  //GoRouter.of(context).go('/problem');

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
                      visible: report_img != null,
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
                                      image: NetworkImage(
                                          report_img != null
                                              ? urlStarter + report_img!
                                              : '',
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
