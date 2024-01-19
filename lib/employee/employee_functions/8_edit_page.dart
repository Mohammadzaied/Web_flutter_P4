import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/employee/employee_functions/component/1_packages.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';

class edit_package extends StatefulWidget {
  final package_edit pk_edit;

  const edit_package({super.key, required this.pk_edit});

  @override
  State<edit_package> createState() => _edit_packageState();
}

class _edit_packageState extends State<edit_package> {
  String username = GetStorage().read("userName");
  String password = GetStorage().read("password");
  String selected_driver = '';
  String selected_status = '';

  Future post_edit_order(int id) async {
    var url = urlStarter + "/employee/acceptPackage";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "employeeUserName": username,
          "employeePassword": password,
          "packageId": id
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    if (responce.statusCode == 200) {
      //widget.refreshdata();
    }
  }

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
  ////you should add all status here

  @override
  void initState() {
    selected_status =
        widget.pk_edit.status.isEmpty ? '' : widget.pk_edit.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////
    List<String> filteredList = selected_status.isNotEmpty
        ? status.sublist(0, status.indexOf(selected_status) + 1)
        : status;
    //////////////////////////////////////////

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text.rich(TextSpan(
                      text: 'Customer Name: ',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                      children: <InlineSpan>[
                        TextSpan(
                          text: ' ${widget.pk_edit.name}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ])),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Text.rich(TextSpan(
                      text: 'Package ID: ',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                      children: <InlineSpan>[
                        TextSpan(
                          text: ' ${widget.pk_edit.id}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ])),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              // Visibility(
              //   visible: selected_driver.isNotEmpty,
              //   child: Column(
              //     children: [
              //       Row(
              //         children: [
              //           Text(
              //             'Driver: ',
              //             style: TextStyle(fontSize: 20, color: Colors.grey),
              //           ),
              //           Container(
              //             width: 260,
              //             child: DropdownButtonFormField(
              //               value: selected_driver.isNotEmpty
              //                   ? selected_driver
              //                   : null,
              //               hint: Text('Drivers',
              //                   style: TextStyle(color: Colors.grey)),
              //               decoration: theme_helper().text_form_style(
              //                 '',
              //                 '',
              //                 null,
              //               ),
              //               borderRadius: BorderRadius.circular(10),
              //               onChanged: (newValue) {
              //                 setState(() {
              //                   selected_driver = newValue as String;
              //                 });
              //               },
              //               items: filteredDrivers.map((value) {
              //                 return DropdownMenuItem(
              //                   value: value.name,
              //                   child: Row(
              //                     mainAxisAlignment: MainAxisAlignment.start,
              //                     children: [
              //                       Container(
              //                         height: 40,
              //                         width: 40,
              //                         decoration: BoxDecoration(
              //                             shape: BoxShape.circle,
              //                             image: DecorationImage(
              //                                 fit: BoxFit.cover,
              //                                 image: AssetImage(value.img))),
              //                       ),
              //                       SizedBox(
              //                         width: 3,
              //                       ),
              //                       Text(value.name),
              //                     ],
              //                   ),
              //                 );
              //               }).toList(),
              //             ),
              //           ),
              //         ],
              //       ),
              //       SizedBox(
              //         height: 30,
              //       )
              //     ],
              //   ),
              // ),
              Visibility(
                visible: selected_status.isNotEmpty,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Status: ',
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                        Container(
                          width: 260,
                          child: DropdownButtonFormField(
                            value: selected_status,
                            hint: Text('status',
                                style: TextStyle(color: Colors.grey)),
                            decoration: theme_helper().text_form_style(
                              '',
                              '',
                              null,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            onChanged: (newValue) {
                              setState(() {
                                selected_status = newValue as String;
                              });
                            },
                            items: filteredList.map((value) {
                              return DropdownMenuItem(
                                  value: value, child: Text(value));
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 60,
                    ),
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
                                "Save Changes",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            onPressed: () {
                              ////////////////
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
                                "Cancel",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            onPressed: () {
                              GoRouter.of(context).go('/main');
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
