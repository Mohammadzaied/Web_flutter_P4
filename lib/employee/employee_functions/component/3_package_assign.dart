import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class package_assign extends StatefulWidget {
  final List<driver_assign_to_order> drivers;
  final String photo_cus;
  final int package_type; // 0 Delivery of a package , 1 Receiving a package
  final String city;
  final String name;
  final int id;
  final int package_size; // 0 doc  , 1 small ,2 meduim , 3 large
  final Function() refreshdata;

  package_assign({
    super.key,
    required this.photo_cus,
    required this.package_size,
    required this.city,
    required this.name,
    required this.package_type,
    required this.id,
    required this.refreshdata,
    required this.drivers,
  });

  @override
  State<package_assign> createState() => _package_assignState();
}

class _package_assignState extends State<package_assign> {
  String username = GetStorage().read("userName");
  String password = GetStorage().read("password");

  Future post_assign_order(
      int id, String drivr_username, String date, int type) async {
    var url = urlStarter + "/employee/AssignPackageToDriver";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "employeeUserName": username,
          "employeePassword": password,
          "packageId": id,
          "driverUsername": drivr_username,
          "packageType": type,
          "assignToDate": date,
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    if (responce.statusCode == 200) {
      widget.refreshdata();
    }
  }

  String dayselcted_day = DateFormat('EEEE').format(DateTime.now());
  String dayselcted_num = DateFormat('yyyy-MM-dd').format(DateTime.now());

  List daylist = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];
  String selecteddriver = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext) {
    //////////////////////////////////// filter driver

    List<driver_assign_to_order> filteredDrivers =
        filterDrivers(widget.drivers, dayselcted_num, widget.city);

    ////////////////////////////////////////////////////////////

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
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
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
                            text: widget.package_type == 0 ? 'to: ' : 'from: ',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            children: <InlineSpan>[
                              TextSpan(
                                text: widget.city,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ])),
                        Spacer(),
                        Text.rich(TextSpan(
                            text: 'Package size : ',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            children: <InlineSpan>[
                              TextSpan(
                                text: widget.package_size == 0
                                    ? 'Document'
                                    : widget.package_size == 1
                                        ? 'Small'
                                        : widget.package_size == 2
                                            ? 'Meduim'
                                            : 'Large',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ])),
                        Spacer(),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          child: MaterialButton(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            color: Colors.blue,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    '${dayselcted_day}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              _selectDate(context);
                            },
                          ),
                        ),
                        Container(
                          width: 300,
                          child: DropdownButtonFormField(
                            hint: Text(
                                filteredDrivers.length > 0
                                    ? 'Available drivers by date'
                                    : 'NO Available drivers',
                                style: TextStyle(
                                    color: filteredDrivers.length > 0
                                        ? Colors.black
                                        : Colors.red)),
                            decoration: theme_helper().text_form_style(
                              '',
                              '',
                              null,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            onChanged: (newValue) {
                              setState(() {
                                selecteddriver = newValue as String;
                                print(selecteddriver);
                              });
                            },
                            items: filteredDrivers.map((value) {
                              return DropdownMenuItem(
                                value: value.username,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(value.img,
                                                scale: 1,
                                                headers: {
                                                  'ngrok-skip-browser-warning':
                                                      'true'
                                                }),
                                          )),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(value.name),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: filteredDrivers.length > 0
                                ? primarycolor
                                : Colors.grey,
                          ),
                          child: MaterialButton(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            color: primarycolor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Assign to Driver",
                                style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            onPressed: filteredDrivers.length > 0
                                ? () {
                                    post_assign_order(
                                        widget.id,
                                        selecteddriver,
                                        dayselcted_num + ' 11:11:11',
                                        widget.package_type);
                                    setState(() {
                                      selecteddriver = '';
                                    });
                                  }
                                : null,
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

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 1)),
    );

    if (selectedDate != null) {
      setState(() {
        dayselcted_day = DateFormat('EEEE').format(selectedDate);
        dayselcted_num = DateFormat('yyyy-MM-dd').format(selectedDate);
        print(dayselcted_num);
      });
    }
  }
}

class driver_assign_to_order {
  final String name;
  final String username;
  final String img;
  final List<String> working_days;
  final String city;
  final String vacation;

  driver_assign_to_order({
    required this.city,
    required this.vacation,
    required this.working_days,
    required this.username,
    required this.name,
    required this.img,
  });

  bool isAvailableOnCurrentDay(String currentDay, String c) {
    DateTime dateTime = DateFormat('yyyy-MM-dd').parse(currentDay);
    String dayOfWeek = DateFormat('EEEE').format(dateTime);
    return working_days.contains(dayOfWeek) &&
        vacation != currentDay &&
        city == c;
  }
}

/////////////////   filter to put Suitable drivers
List<driver_assign_to_order> filterDrivers(
    List<driver_assign_to_order> drivers, String currentDay, String city) {
  return drivers
      .where((driver) => driver.isAvailableOnCurrentDay(currentDay, city))
      .toList();
}
