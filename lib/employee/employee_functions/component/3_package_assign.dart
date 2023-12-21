import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:intl/intl.dart';

class package_assign extends StatefulWidget {
  final String photo_cus;
  final int package_type; // 0 Delivery of a package , 1 Receiving a package
  final String from;
  final String to;
  final String name;
  final int id;
  final int package_size; //0 doc  , 1 small ,2 meduim , 3 large

  package_assign({
    super.key,
    required this.photo_cus,
    required this.package_size,
    required this.from,
    required this.to,
    required this.name,
    required this.package_type,
    required this.id,
  });

  @override
  State<package_assign> createState() => _package_assignState();
}

class _package_assignState extends State<package_assign> {
  List<driver_assign_to_order> drivers = [];
  String selecteddriver = '';
  void loadData() async {
    drivers = [
      driver_assign_to_order(
        username: '111111',
        name: 'mohammad zaied',
        working_days: ['Sunday', 'Monday'],
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
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext) {
    //////////////////////////////////// filter driver
    String currentDay_format = DateFormat('dd-MM-yyyy').format(DateTime.now());
    List<driver_assign_to_order> filteredDrivers = filterDrivers(drivers,
        currentDay_format, widget.package_type == 0 ? widget.to : widget.from);
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
                              image: AssetImage(widget.photo_cus))),
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
                            text: widget.package_type == 0
                                ? '${widget.to}'
                                : '${widget.from}',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 260,
                          //height: 70,
                          child: DropdownButtonFormField(
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
                                selecteddriver = newValue as String;
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
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: MaterialButton(
                            padding: EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            color: primarycolor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Assign",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            onPressed: () {
                              ////this name customer
                              print(widget.name);
                              /////this selected driver
                              print(selecteddriver);
                            },
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
