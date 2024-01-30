import 'package:flutter/material.dart';
import 'package:flutter_application_1/employee/main_page_employee.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class data_show extends StatefulWidget {
  final int? id;

  const data_show({super.key, this.id});
  @override
  State<data_show> createState() => _data_showState();
}

class _data_showState extends State<data_show> {
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
      GoRouter.of(context).go('/all_orders');
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
      GoRouter.of(context).go('/all_orders');
    }
  }

  List<String> status_pack = [
    "Under review",
    "Rejected by employee",
    "Accepted",
    'Assigned to receive', // employee assign package to driver
    "Wait Driver", // driver accept
    "Rejected by driver",
    "Complete Receive",
    "In Warehouse",
    "Assigned to deliver",
    "With Driver",
    "Delivered",
    "Completed"
  ];
  String? driver_operation = '';
  bool? when_load = false;
  //////
  String? status = '';
  String? reason = '';
  String? id_package = '';
  String? from = '';
  String? to = '';
  String? p_price = '';
  double? d_price = 0;
  String? who_willpay = '';
  int? shipp_type = 0;
//////////////
  String? sender_name;
  String? img_sender;
  String? username_sender;
  String? phone_sender;
  String? email_sender;
  String? city_sender;
///////////////
  String? img_rec;
  String? name_rec;
  String? username_rec;
  String? phone_rec;
  String? email_rec;
  String? city_rec;
///////////////////////
  String? driver_rec_name;
  String? driver_rec_username;
  String? driver_rec_paidmoney;
  String? driver_rec_date;
  String? driver_rec_time;
  /////////////////////////////////
  String? driver_send_name;
  String? driver_send_username;
  String? driver_send_paidmoney;
  String? driver_send_date;
  String? driver_send_timr;
/////////////////////////
  String? current_driver_username;
  void initState() {
    setState(() {
      TabController_.index = 3;
    });
    fetchData_all_orders(widget.id!);

    super.initState();
  }

  Future<void> fetchData_all_orders(int id) async {
    var url = urlStarter + "/employee/PackageDeteils?packageId=${id}";
    print(url);
    final response = await http
        .get(Uri.parse(url), headers: {'ngrok-skip-browser-warning': 'true'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        driver_operation = data['PackageDeteils']['driver_userName'];

        /////////////////////////
        reason = data['PackageDeteils']['driverComment'];
        status = data['PackageDeteils']['status'];
        id_package = data['PackageDeteils']['packageId'].toString();
        from = data['PackageDeteils']['fromCity'];
        to = data['PackageDeteils']['toCity'];
        p_price = data['PackageDeteils']['packagePrice'].toString();
        d_price = data['PackageDeteils']['total'];
        who_willpay = data['PackageDeteils']['whoWillPay'];
        shipp_type = data['PackageDeteils']['shippingType'] == 'Document0'
            ? 0
            : data['PackageDeteils']['shippingType'] == 'Package0'
                ? 1
                : data['PackageDeteils']['shippingType'] == 'Package1'
                    ? 2
                    : 3;
// //////////////
        sender_name = data['PackageDeteils']['send_user']['Fname'] +
            ' ' +
            data['PackageDeteils']['send_user']['Lname'];
        username_sender = data['PackageDeteils']['send_user']['userName'];
        img_sender = urlStarter + data['PackageDeteils']['send_user']['url'];
        phone_sender =
            data['PackageDeteils']['send_user']['phoneNumber'].toString();
        email_sender = data['PackageDeteils']['send_user']['email'];

// ///////////////
        name_rec = data['PackageDeteils']['rec_user']['Fname'] +
            ' ' +
            data['PackageDeteils']['rec_user']['Lname'];
        img_rec = urlStarter + data['PackageDeteils']['rec_user']['url'];
        username_rec = data['PackageDeteils']['rec_user']['userName'];
        phone_rec =
            data['PackageDeteils']['rec_user']['phoneNumber'].toString();
        email_rec = data['PackageDeteils']['rec_user']['email'];

// ///////////////////////
        when_load = data['packagePriceDetails'] != null;
/////////////////
        if (data['packagePriceDetails'] != null) {
          driver_rec_name = data['packagePriceDetails']['reciveDriver']
                  ['Fname'] +
              ' ' +
              data['packagePriceDetails']['reciveDriver']['Lname'];
          driver_rec_username =
              data['packagePriceDetails']['reciveDriver']['userName'];
          driver_rec_paidmoney =
              data['packagePriceDetails']['paidAmount'].toString();

          DateTime dateTime =
              DateTime.parse(data['packagePriceDetails']['receiveDate']);
          // Extract date and time components
          String date =
              "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
          String time =
              "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";
          driver_rec_date = date;
          driver_rec_time = time;
        }

        if (status == 'Delivered' || status == 'Completed') {
          driver_send_name = data['packagePriceDetails']['deliverDriver']
                  ['Fname'] +
              ' ' +
              data['packagePriceDetails']['deliverDriver']['Lname'];
          driver_send_username =
              data['packagePriceDetails']['deliverDriver']['userName'];
          driver_send_paidmoney =
              data['packagePriceDetails']['receiveAmount'].toString();

          DateTime dateTime =
              DateTime.parse(data['packagePriceDetails']['deliverDate']);
          // Extract date and time components
          String date =
              "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
          String time =
              "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";
          driver_send_date = date;
          driver_send_timr = time;
        }
        ///////////////////////////////
      });
    } else {
      print('new_orders error');
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          child: Column(
        children: [
          Column(
            children: [
              Container(
                width: 1000,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    splashColor: primarycolor.withOpacity(0.6),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 1),
                              spreadRadius: 2,
                              blurRadius: 5)
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Package ID: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                  '${id_package}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Package status: ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade700)),
                                  Text(
                                    '${status}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('From: ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey.shade700)),
                                      Text(
                                        '${from}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('To: ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey.shade700)),
                                      Text(
                                        '${to}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Package price: ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey.shade700)),
                                      Text(
                                        '${p_price}\$',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Delivery price: ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey.shade700)),
                                      Text(
                                        '${d_price!.toStringAsFixed(2)}\$',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Who will pay: ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade700)),
                                  Text(
                                    '${who_willpay}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Package Type: ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade700)),
                                  Text(
                                    shipp_type == 0
                                        ? 'Document'
                                        : shipp_type == 1
                                            ? 'Small'
                                            : shipp_type == 2
                                                ? 'Meduim'
                                                : 'Large',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Visibility(
                                  visible: status == "Rejected by employee" ||
                                      status == "Rejected by driver" ||
                                      (status == "In Warehouse" &&
                                          reason != null) ||
                                      (status == "Accepted" && reason != null),
                                  child: Container(
                                    child: MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      color: Colors.grey.shade700,
                                      child: Icon(
                                        Icons.comment,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        "Ok",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18),
                                                      )),
                                                ],
                                                title: Text(status ==
                                                        "Rejected by employee"
                                                    ? "Comment from employee"
                                                    : "Comment from driver"),
                                                content: Container(
                                                  width: 400,
                                                  child: Text(
                                                    "${reason}",
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
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Visibility(
                                  visible: status != 'Under review' &&
                                      status != 'Completed' &&
                                      status != 'In Warehouse',
                                  child: Container(
                                    child: MaterialButton(
                                      padding: EdgeInsets.all(8),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
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
                                        int targetIndex =
                                            status_pack.indexOf(status!);
                                        if (targetIndex != -1 &&
                                            targetIndex > 0) {
                                          if (status == 'Complete Receive' ||
                                              status == 'Accepted')
                                            before_status =
                                                status_pack[targetIndex - 2];
                                          else
                                            before_status =
                                                status_pack[targetIndex - 1];
                                        }
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        post_edit_package(
                                                            int.parse(
                                                                id_package!),
                                                            status!,
                                                            driver_operation,
                                                            who_willpay!);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        "Yes",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18),
                                                      )),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 18),
                                                      )),
                                                ],
                                                title:
                                                    Text("Edit package Status"),
                                                content: Container(
                                                  width: 400,
                                                  child: Text(
                                                    "Are you sure you want to edit  the package id's ${id_package} status from state  '${status}' to '${before_status}'",
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
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Visibility(
                                  visible: status == "Rejected by employee" ||
                                      status == "Rejected by driver" ||
                                      status == "Completed",
                                  child: Container(
                                    child: MaterialButton(
                                      padding: EdgeInsets.all(8),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
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
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        post_delete_package(
                                                            int.parse(
                                                                id_package!));
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        "Yes",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18),
                                                      )),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
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
                                                    "Are you sure you want to delete  the package id's ${id_package} , you can't undo this action!",
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
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      splashColor: primarycolor.withOpacity(0.6),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 1),
                                spreadRadius: 2,
                                blurRadius: 5)
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Sender Deatails',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ],
                              ),
                              Divider(
                                thickness: 1,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Sender name: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade700)),
                                    Text(
                                      '${sender_name}', //${sender_name}
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('username: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade700)),
                                    Text(
                                      '${username_sender}', //${username_sender}
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Phone number: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade700)),
                                    Text(
                                      '${phone_sender}', //${phone_sender}
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Email: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade700)),
                                    Text(
                                      '${email_sender}', //${email_sender}
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: when_load!,
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        splashColor: primarycolor.withOpacity(0.6),
                        child: Ink(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 1),
                                  spreadRadius: 2,
                                  blurRadius: 5)
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text.rich(TextSpan(
                                        text: 'Receiving driver: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text:
                                                '${driver_rec_name}', //${driver_rec_name}
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ])),
                                    Text.rich(TextSpan(
                                        text: 'Username: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text:
                                                '${driver_rec_username}', //${driver_rec_username}
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ])),
                                  ],
                                ),
                                Divider(
                                  thickness: 1,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('The paid money : ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey.shade700)),
                                      Text(
                                        '${driver_rec_paidmoney}\$', //${driver_rec_paidmoney}
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 0),
                                      child: Row(
                                        children: [
                                          Text('Date: ',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey.shade700)),
                                          Text(
                                            '${driver_rec_date}', //${driver_rec_date}
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 0),
                                      child: Row(
                                        children: [
                                          Text('Time: ',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey.shade700)),
                                          Text(
                                            '${driver_rec_time}', //${driver_rec_time}
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  thickness: 4,
                                  color: Colors.black,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text.rich(TextSpan(
                                        text: 'sender driver: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text:
                                                '${driver_send_name}', //${driver_send_name}
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ])),
                                    Text.rich(TextSpan(
                                        text: 'Username: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text:
                                                '${driver_send_username}', //${driver_send_username}
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ])),
                                  ],
                                ),
                                Divider(
                                  thickness: 1,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('The received money: ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey.shade700)),
                                      Text(
                                        '${driver_send_paidmoney}\$', //${driver_send_paidmoney}
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 0),
                                      child: Row(
                                        children: [
                                          Text('Date: ',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey.shade700)),
                                          Text(
                                            '${driver_send_date}', //${driver_send_date}
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 0),
                                      child: Row(
                                        children: [
                                          Text('Time: ',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey.shade700)),
                                          Text(
                                            '${driver_send_timr}', //${driver_send_timr}
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
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
                ),
                ///////////////////////////
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      splashColor: primarycolor.withOpacity(0.6),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 1),
                                spreadRadius: 2,
                                blurRadius: 5)
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Recipient Deatails',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Divider(
                                thickness: 1,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Recipient name: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade700)),
                                    Text(
                                      '${name_rec}', //${name_rec}
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Username: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade700)),
                                    Text(
                                      '${username_rec}', //${username_rec}
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Phone number: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade700)),
                                    Text(
                                      '${phone_rec}', //${phone_rec}
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Email: ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade700)),
                                    Text(
                                      '${email_rec}', //${email_rec}
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Divider(
                              //   thickness: 1,
                              // ),
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              //   child: Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Text('City: ',
                              //           style: TextStyle(
                              //               fontSize: 16,
                              //               color: Colors.grey.shade700)),
                              //       Text(
                              //         '111111', //${city_rec}
                              //         style: TextStyle(
                              //           fontSize: 14,
                              //           color: Colors.black,
                              //           fontWeight: FontWeight.bold,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //Spacer(),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
