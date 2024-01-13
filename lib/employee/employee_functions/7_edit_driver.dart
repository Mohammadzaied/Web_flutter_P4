import 'package:day_picker/day_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/employee/main_page_employee.dart';

import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class edit_driver extends StatefulWidget {
  @override
  State<edit_driver> createState() => _edit_driverState();
}

class _edit_driverState extends State<edit_driver> {
  TextEditingController controller = new TextEditingController();
  TextEditingController controller2 = new TextEditingController();

  List<dynamic> drivers_ = [];
  ////////////////
  int _selectedTabIndex =
      1; //1 edit time , 2 Add vacation ,3 edit Transmission line

  //////////// two button in edit driver
  bool isHovered = false;
  bool isHovered2 = false;
  bool isHovered3 = false;
  bool isHovered4 = false;

  /////////////////////
  List citylist = [
    'Nablus',
    'Tulkarm',
    'Ramallah',
    'Jenin',
    'Qalqilya',
    'Salfit',
    'Hebron',
    'None'
  ];
  String? selectedCity;
  String? new_vehicle_id;

  //////
  List<driver> drivers = [];
  driver driver_selcted = driver(
      username: '',
      name: '',
      img: '',
      working_days: [],
      city: '',
      vacation: '',
      vehicle_id: '');
  //////
  List<String> new_working_days = [];
  //////////
  bool is_selected = false; // to change button from disable to enable
  ///////////////////////////////////
  bool vacation_date_true = false;
  String vacation = '';
  List<DayInWeek> _days = [
    DayInWeek(
      "Sun",
      dayKey: 'Sunday',
    ),
    DayInWeek(
      "Mon",
      dayKey: 'Monday',
    ),
    DayInWeek("Tue", dayKey: 'Tuesday'),
    DayInWeek(
      "Wed",
      dayKey: 'Wednesday',
    ),
    DayInWeek(
      "Thu",
      dayKey: 'Thursday',
    ),
    DayInWeek(
      "Fri",
      dayKey: 'Friday',
    ),
    DayInWeek(
      "Sat",
      dayKey: 'Saturday',
    ),
  ];

  Future<void> fetchData_drivers() async {
    var url = urlStarter + "/employee/GetDriverListEmployee";
    print(url);
    final response = await http
        .get(Uri.parse(url), headers: {'ngrok-skip-browser-warning': 'true'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      drivers_ = data;
      // print(data);
      setState(() {
        drivers = buildMy_drivers();
      });
    } else {
      print('new_orders error');
      throw Exception('Failed to load data');
    }
  }

  List<driver> buildMy_drivers() {
    List<driver> new_drivers = [];
    for (int i = 0; i < drivers_.length; i++) {
      List<String> daysList = drivers_[i]['working_days']
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .split(', ')
          .map((day) => day.trim())
          .toList();

      new_drivers.add(
        driver(
          vacation: drivers_[i]['notAvailableDate'].toString(),
          vehicle_id: drivers_[i]['vehicleNumber'],
          city: drivers_[i]['city'],
          username: drivers_[i]['username'],
          name: drivers_[i]['name'],
          working_days: daysList,
          img: urlStarter + drivers_[i]['img'],
        ),
      );
    }

    return new_drivers;
  }

  String username = GetStorage().read("userName");
  String password = GetStorage().read("password");

  Future post_edit_days(String username_driver) async {
    var url = urlStarter + "/employee/editDriverWorkingDays";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "employeeUserName": username,
          "employeePassword": password,
          "driverUsername": username_driver,
          "workingDays": new_working_days.toString()
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    if (responce.statusCode == 200) {
      setState(() {
        new_working_days.clear();
        _days.forEach((day) {
          day.isSelected = false;
        });
        controller.text = '';
        driver_selcted = driver(
            vacation: '',
            username: '',
            name: '',
            img: '',
            working_days: [],
            city: '',
            vehicle_id: '');
        fetchData_drivers();
      });
    }
  }

  Future post_edit_vacation(String username_driver) async {
    var url = urlStarter + "/employee/addVacationDriver";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "employeeUserName": username,
          "employeePassword": password,
          "driverUsername": username_driver,
          "notAvailableDate": vacation,
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    if (responce.statusCode == 200) {
      setState(() {
        fetchData_drivers();
        vacation_date_true = false;
        vacation = '';
        controller.text = '';
        driver_selcted = driver(
            vacation: '',
            username: '',
            name: '',
            img: '',
            working_days: [],
            city: '',
            vehicle_id: '');
      });
    }
  }

  Future post_edit_city(String username_driver) async {
    var url = urlStarter + "/employee/editDriverWorkingCity";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "employeeUserName": username,
          "employeePassword": password,
          "driverUsername": username_driver,
          "newCity": selectedCity,
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    if (responce.statusCode == 200) {
      setState(() {
        fetchData_drivers();
        selectedCity = '';
        controller.text = '';
        driver_selcted = driver(
            vacation: '',
            username: '',
            name: '',
            img: '',
            working_days: [],
            city: '',
            vehicle_id: '');
      });
    }
  }

  Future post_edit_vehicle_id(String username_driver) async {
    var url = urlStarter + "/employee/editDriverVehicleNumber";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "employeeUserName": username,
          "employeePassword": password,
          "driverUsername": username_driver,
          "vehicleNumber": new_vehicle_id,
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    if (responce.statusCode == 200) {
      setState(() {
        fetchData_drivers();
        controller2.text = '';
        new_vehicle_id = '';
        controller.text = '';
        driver_selcted = driver(
            vacation: '',
            username: '',
            name: '',
            img: '',
            working_days: [],
            city: '',
            vehicle_id: '');
      });
    }
  }

  @override
  void initState() {
    setState(() {
      TabController_.index = 7;
    });
    fetchData_drivers();
    selectedCity = '';
    new_vehicle_id = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ////// for tabs dont need any program
          Container(
            height: 700,
            width: 200,
            color: Colors.grey.shade300,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (isHovered || _selectedTabIndex == 1)
                          ? primarycolor
                          : Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: Text('Edit working days'),
                    onPressed: () {
                      setState(() {
                        controller.text = '';
                        _selectedTabIndex = 1;
                        driver_selcted = driver(
                            vacation: '',
                            username: '',
                            name: '',
                            img: '',
                            working_days: [],
                            city: '',
                            vehicle_id: '');
                      });
                    },
                    onHover: (value) {
                      setState(() {
                        isHovered = !isHovered;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 2,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (isHovered2 || _selectedTabIndex == 2)
                          ? primarycolor
                          : Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: Text('Add vacation'),
                    onPressed: () {
                      setState(() {
                        _days.forEach((day) {
                          day.isSelected = false;
                        });
                        controller.text = '';
                        _selectedTabIndex = 2;
                        driver_selcted = driver(
                            vacation: '',
                            username: '',
                            name: '',
                            img: '',
                            working_days: [],
                            city: '',
                            vehicle_id: '');
                      });
                    },
                    onHover: (value) {
                      setState(() {
                        isHovered2 = !isHovered2;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 2,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (isHovered3 || _selectedTabIndex == 3)
                          ? primarycolor
                          : Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: Text('Edit the transmission line'),
                    onPressed: () {
                      setState(() {
                        _days.forEach((day) {
                          day.isSelected = false;
                        });
                        controller.text = '';
                        _selectedTabIndex = 3;
                        driver_selcted = driver(
                            vacation: '',
                            username: '',
                            name: '',
                            img: '',
                            working_days: [],
                            city: '',
                            vehicle_id: '');
                      });
                    },
                    onHover: (value) {
                      setState(() {
                        isHovered3 = !isHovered3;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 2,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (isHovered4 || _selectedTabIndex == 4)
                          ? primarycolor
                          : Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: Text('Edit vehicle number'),
                    onPressed: () {
                      setState(() {
                        controller.text = '';
                        _selectedTabIndex = 4;
                        driver_selcted = driver(
                            vacation: '',
                            username: '',
                            name: '',
                            img: '',
                            working_days: [],
                            city: '',
                            vehicle_id: '');
                      });
                    },
                    onHover: (value) {
                      setState(() {
                        isHovered4 = !isHovered4;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          Spacer(),
          Container(
            padding: EdgeInsets.only(top: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "Name driver :",
                        style: TextStyle(fontSize: 25, color: Colors.black),
                      ),
                    ),
                    Container(
                      width: 400,
                      child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                          onChanged: (text) {
                            setState(() {
                              _days.forEach((day) {
                                day.isSelected = false;
                              });
                              driver_selcted = driver(
                                  vacation: '',
                                  username: '',
                                  name: '',
                                  img: '',
                                  working_days: [],
                                  city: '',
                                  vehicle_id: '');
                            });
                          },
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: "Search by name driver",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: primarycolor,
                            ),
                          ),
                        ),
                        suggestionsCallback: (pattern) {
                          return drivers
                              .where((driver) => driver.name
                                  .toLowerCase()
                                  .startsWith(pattern.toLowerCase()))
                              .toList();
                        },
                        itemBuilder: (context, driver suggestion) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: primarycolor,
                              backgroundImage: suggestion.img == ""
                                  ? null
                                  : NetworkImage(suggestion.img,
                                      scale: 1,
                                      headers: {
                                          'ngrok-skip-browser-warning': 'true'
                                        }),
                              // AssetImage("${suggestion.img}"),
                              child: suggestion.img == ""
                                  ? Text(
                                      suggestion.name[0]
                                          .toString()
                                          .toUpperCase(),
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : null,
                            ),
                            title: Text(suggestion.name),
                            subtitle: Text(suggestion.username),
                          );
                        },
                        onSuggestionSelected: (driver suggestion) {
                          setState(() {
                            if (_selectedTabIndex == 1) {
                              _days.forEach((day) {
                                if (suggestion.working_days
                                    .contains(day.dayKey)) {
                                  day.isSelected = true;
                                  new_working_days.add(day.dayKey);
                                } else {
                                  day.isSelected = false;
                                }
                              });
                            }
                            driver_selcted = suggestion;
                            controller.text = suggestion.name;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                //////////////////////// widgets when select edit working days
                Visibility(
                  visible: _selectedTabIndex == 1,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text.rich(TextSpan(
                              text: 'Working days for the driver: ',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '${driver_selcted.working_days}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Set New working Days',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 400,
                            child: SelectWeekDays(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              days: _days,
                              border: false,
                              boxDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  colors: [
                                    primarycolor.withOpacity(0.5),
                                    Colors.green.shade300
                                  ],
                                  tileMode: TileMode.repeated,
                                ),
                              ),
                              onSelect: (values) {
                                setState(() {
                                  new_working_days.clear();

                                  _days.forEach((day) {
                                    if (day.isSelected) {
                                      new_working_days.add(day.dayKey);
                                    }
                                  });
                                  // new_working_days = values;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: (new_working_days.isNotEmpty &&
                                      driver_selcted.name.isNotEmpty)
                                  ? primarycolor
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                color: primarycolor,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text(
                                    "save edit",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                onPressed: (new_working_days.isNotEmpty &&
                                        driver_selcted.name.isNotEmpty)
                                    ? () {
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
                                                        //when pressed change working day to driver store in  new_working_day variable
                                                        post_edit_days(
                                                            driver_selcted
                                                                .username);
                                                        new_working_days
                                                            .clear();
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
                                                title: Text("Edit Work days"),
                                                content: Container(
                                                  width: 400,
                                                  child: Text(
                                                    "Are you sure you want to change working days for ${driver_selcted.name} to ${new_working_days}",
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
                                      }
                                    : null),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                //////////////////////// widgets when select add vacation
                Visibility(
                  visible: _selectedTabIndex == 2,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text.rich(TextSpan(
                              text: 'Working days for the driver: ',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '${driver_selcted.working_days}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text.rich(TextSpan(
                              text: 'Specific Vacation :',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                              children: <InlineSpan>[
                                TextSpan(
                                  text:
                                      ' ${driver_selcted.vacation != 'null' ? driver_selcted.vacation : 'No specific vacation'}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: (driver_selcted.name.isNotEmpty)
                                  ? primarycolor
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ElevatedButton(
                              onPressed: driver_selcted.name.isNotEmpty
                                  ? () {
                                      _selectDate(context);
                                    }
                                  : null,
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
                                    'Select Date',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text.rich(TextSpan(
                              text: 'Date selected : ',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '${vacation}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 400,
                            height: 1,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: (vacation_date_true &&
                                      driver_selcted.name.isNotEmpty)
                                  ? primarycolor
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                color: primarycolor,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text(
                                    "Add vacation",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                onPressed: (vacation_date_true &&
                                        driver_selcted.name.isNotEmpty)
                                    ? () {
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
                                                        //when pressed add vacation to driver store in  vacation variable
                                                        post_edit_vacation(
                                                            driver_selcted
                                                                .username);
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
                                                title: Text("Add vacation"),
                                                content: Container(
                                                  width: 400,
                                                  child: Text(
                                                    "Are you sure you want to Add vacation for ${driver_selcted.name} in ${vacation}",
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
                                      }
                                    : null),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                //////////////////////// widgets when Transmission line
                Visibility(
                  visible: _selectedTabIndex == 3,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text.rich(TextSpan(
                              text: 'Transmission line: ',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '${driver_selcted.city}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              width: 200,
                              child: DropdownButtonFormField(
                                hint: Text('New City',
                                    style: TextStyle(color: Colors.grey)),
                                decoration: theme_helper().text_form_style(
                                  '',
                                  '',
                                  null,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                onChanged: (newValue) {
                                  setState(() {
                                    if (newValue == 'None') {
                                      selectedCity = '';
                                      is_selected = false;
                                    } else {
                                      selectedCity = newValue as String?;
                                      is_selected = true;
                                    }
                                  });
                                },
                                items: citylist.map((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 400,
                            height: 1,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: (vacation_date_true &&
                                      driver_selcted.name.isNotEmpty)
                                  ? primarycolor
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                color: primarycolor,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text(
                                    "Save Changes",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                onPressed: (is_selected &&
                                        driver_selcted.name.isNotEmpty)
                                    ? () {
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
                                                        //when pressed add vacation to driver store in  vacation variable
                                                        post_edit_city(
                                                            driver_selcted
                                                                .username);
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
                                                title: Text(
                                                    "Edit the transmission line"),
                                                content: Container(
                                                  width: 400,
                                                  child: Text(
                                                    "Are you sure you want to Edit the transmission line for ${driver_selcted.name} from ${driver_selcted.city} to ${selectedCity}",
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
                                      }
                                    : null),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                //////////////////////// widgets when edit  number

                Visibility(
                  visible: _selectedTabIndex == 4,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text.rich(TextSpan(
                              text: 'Vehicle Number: ',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: '${driver_selcted.vehicle_id}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              width: 300,
                              child: TextField(
                                controller: controller2,
                                keyboardType: TextInputType.emailAddress,
                                decoration: theme_helper().text_form_style(
                                    "Vehicle Number",
                                    "Enter Vehicle Number",
                                    null),
                                onChanged: (newValue) {
                                  setState(() {
                                    new_vehicle_id = newValue;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 400,
                            height: 1,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: (new_vehicle_id!.isNotEmpty &&
                                      driver_selcted.name.isNotEmpty)
                                  ? primarycolor
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                color: primarycolor,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text(
                                    "Save Changes",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                onPressed: (new_vehicle_id!.isNotEmpty &&
                                        driver_selcted.name.isNotEmpty)
                                    ? () {
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
                                                        //when pressed add vacation to driver store in  vacation variable
                                                        post_edit_vehicle_id(
                                                            driver_selcted
                                                                .username);
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
                                                    Text("Edit Vehicle number"),
                                                content: Container(
                                                  width: 400,
                                                  child: Text(
                                                    "Are you sure you want to Edit Vehicle number for ${driver_selcted.name} from ${driver_selcted.vehicle_id} to ${new_vehicle_id}",
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
                                      }
                                    : null),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      vacation = DateFormat('yyyy-MM-dd').format(selectedDate);
      String current_date =
          DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal());
      String dayOfWeek = DateFormat('EEEE').format(selectedDate);
      if (current_date == vacation || selectedDate.isAfter(DateTime.now())) {
        if (driver_selcted.working_days.contains(dayOfWeek)) {
          setState(() {
            vacation_date_true = true;
            vacation;
          });
        } else {
          setState(() {
            vacation_date_true = false;
            vacation =
                'This date does not correspond to the driver working days';
          });
        }
      } else {
        setState(() {
          vacation = 'Error choosing date';
          vacation_date_true = false;
        });
      }
    }
  }
}

class driver {
  final String name;
  final String username;
  final String img;
  final String city;
  final String vehicle_id;
  final String vacation;
  final List<String> working_days;

  driver({
    required this.vehicle_id,
    required this.city,
    required this.working_days,
    required this.username,
    required this.name,
    required this.img,
    required this.vacation,
  });
}
