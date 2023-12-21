import 'package:flutter/material.dart';
import 'package:flutter_application_1/employee/employee_functions/component/1_packages.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class edit_package extends StatefulWidget {
  final package_edit pk_edit;

  const edit_package({super.key, required this.pk_edit});

  @override
  State<edit_package> createState() => _edit_packageState();
}

class _edit_packageState extends State<edit_package> {
  List<driver_assign_to_order> drivers = [];
  String selected_driver = '';
  String selected_status = '';

  List<String> status = [
    'pendding',
    'accept',
    'reject',
    'assign to driver',
    'on way'
  ]; ////you should add all status here
  void loadData() async {
    drivers = [
      driver_assign_to_order(
        username: '111111',
        name: 'mohammad zaied',
        working_days: ['Sunday', 'Monday', 'Thursday'],
        img: "assets/f3.png",
        vacation: '19-12-2023',
        city: 'Ramallah',
      ),
      driver_assign_to_order(
        username: '222222222222',
        name: 'rami',
        working_days: ['Thursday', 'Monday'],
        img: "assets/add-friend.png",
        vacation: '12-12-2023',
        city: 'Ramallah',
      ),
      driver_assign_to_order(
        username: '555555',
        name: 'zain',
        working_days: ['Sunday', 'Friday', 'Thursday'],
        img: "assets/driver.png",
        vacation: '15-12-2023',
        city: 'Ramallah',
      ),
      driver_assign_to_order(
        username: '4532233',
        name: 'ahmad',
        working_days: ['Thursday', 'Monday', 'Saturday'],
        img: "",
        vacation: '19-12-2023',
        city: 'Hebron',
      ),
      driver_assign_to_order(
        username: '4532233',
        name: 'ahmad saleh',
        working_days: ['Thursday', 'Monday', 'Tuesday'],
        img: "",
        vacation: '20-12-2023',
        city: 'Jenin',
      ),
    ];
  }

  @override
  void initState() {
    selected_driver =
        widget.pk_edit.driver.isEmpty ? '' : widget.pk_edit.driver;
    selected_status =
        widget.pk_edit.status.isEmpty ? '' : widget.pk_edit.status;
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //////////////////////////////////// filter driver
    String currentDay_format = DateFormat('dd-MM-yyyy').format(DateTime.now());
    List<driver_assign_to_order> filteredDrivers = filterDrivers(
        drivers,
        currentDay_format,
        widget.pk_edit.package_type == 0
            ? widget.pk_edit.to
            : widget.pk_edit.from);
    ////////////////////////////////////////////////////////////
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
              Visibility(
                visible: selected_driver.isNotEmpty,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Driver: ',
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                        Container(
                          width: 260,
                          child: DropdownButtonFormField(
                            value: selected_driver.isNotEmpty
                                ? selected_driver
                                : null,
                            hint: Text('Drivers',
                                style: TextStyle(color: Colors.grey)),
                            decoration: theme_helper().text_form_style(
                              '',
                              '',
                              null,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            onChanged: (newValue) {
                              setState(() {
                                selected_driver = newValue as String;
                              });
                            },
                            items: filteredDrivers.map((value) {
                              return DropdownMenuItem(
                                value: value.name,
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
                                              image: AssetImage(value.img))),
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
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
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
                            items: status.map((value) {
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

  bool isAvailableOnCurrentDay(String currentDay) {
    DateTime dateTime = DateFormat('dd-MM-yyyy').parse(currentDay);
    String dayOfWeek = DateFormat('EEEE').format(dateTime);
    return working_days.contains(dayOfWeek) && vacation != currentDay;
  }
}

/////////////////   filter to put Suitable drivers
List<driver_assign_to_order> filterDrivers(
    List<driver_assign_to_order> drivers, String currentDay, String city) {
  return drivers
      .where((driver) =>
          driver.isAvailableOnCurrentDay(currentDay) && driver.city == city)
      .toList();
}
