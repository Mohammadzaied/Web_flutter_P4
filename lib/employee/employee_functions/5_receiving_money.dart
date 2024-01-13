import 'package:flutter/material.dart';
import 'package:flutter_application_1/employee/main_page_employee.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class receiving_money extends StatefulWidget {
  @override
  State<receiving_money> createState() => _receiving_moneyState();
}

class _receiving_moneyState extends State<receiving_money> {
  List<driver> drivers = [];
  List<dynamic> new_drivers = [];

  late driver selected_driver;
  TextEditingController controller = new TextEditingController();

  String username = GetStorage().read("userName");
  String password = GetStorage().read("password");

  Future post_checkout() async {
    var url = urlStarter + "/employee/receiveDriverBalance";
    var responce = await http.post(Uri.parse(url),
        body: jsonEncode({
          "employeeUserName": username,
          "employeePassword": password,
          "driverUsername": selected_driver.username,
          "deliverdNumber": selected_driver.num_pkg_deliver,
          "receivedNumber": selected_driver.num_pkg_receive,
          "totalBalance": selected_driver.total_delivery
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    if (responce.statusCode == 200) {
      //driver dr = selected_driver;
      setState(() {
        fetchData_drivers();
        // controller.text = dr.name;
        // selected_driver = dr;
      });
    }
  }

  Future<void> fetchData_drivers() async {
    var url = urlStarter + "/employee/getDriversBalance";
    print(url);
    final response = await http
        .get(Uri.parse(url), headers: {'ngrok-skip-browser-warning': 'true'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      new_drivers = data;
      print(new_drivers);
      setState(() {
        drivers = loadData();
        selected_driver = drivers.first;
        controller.text = selected_driver.name;
      });
    } else {
      print('new_orders error');
      throw Exception('Failed to load data');
    }
  }

  List<driver> loadData() {
    List<driver> d = [];

    for (int i = 0; i < new_drivers.length; i++) {
      d.add(driver(
        name: new_drivers[i]['name'],
        username: new_drivers[i]['username'],
        img: new_drivers[i]['img'],
        num_pkg_deliver: new_drivers[i]['deliverdNumber'],
        num_pkg_receive: new_drivers[i]['receivedNumber'],
        total_delivery: new_drivers[i]['totalBalance'],
        total_purchase: 0,
      ));
    }
    return d;
  }

  @override
  void initState() {
    fetchData_drivers();
    setState(() {
      TabController_.index = 4;
    });
    selected_driver = driver(
      name: '',
      username: '',
      img: "/image/sdssd.jpg",
      num_pkg_deliver: 0,
      num_pkg_receive: 0,
      total_delivery: 0,
      total_purchase: 0,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "Search by Name :",
                        style: TextStyle(fontSize: 25, color: Colors.black),
                      ),
                    ),
                    Container(
                      width: 400,
                      child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: "Search by name driver",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            suffixIcon: controller.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        controller.clear();
                                      });
                                    },
                                  )
                                : null,
                            prefixIcon: Icon(
                              Icons.search,
                              color: primarycolor,
                            ),
                          ),
                        ),
                        suggestionsCallback: (pattern) {
                          print('object');
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
                              backgroundImage: NetworkImage(
                                  urlStarter + suggestion.img,
                                  scale: 1,
                                  headers: {
                                    'ngrok-skip-browser-warning': 'true'
                                  }),
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
                            controller.text = suggestion.name;
                            selected_driver = suggestion;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 2.0,
                ),
                borderRadius:
                    BorderRadius.circular(10.0), // Set the border radius here
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 180,
                      width: 180,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          //borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                urlStarter + selected_driver.img,
                                scale: 1,
                                headers: {
                                  'ngrok-skip-browser-warning': 'true'
                                }),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text.rich(TextSpan(
                      text: 'Driver name: ',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                      children: <InlineSpan>[
                        TextSpan(
                          text: ' ${selected_driver.name}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ])),
                  SizedBox(
                    height: 15,
                  ),
                  Text.rich(TextSpan(
                      text: 'Username: ',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                      children: <InlineSpan>[
                        TextSpan(
                          text: ' ${selected_driver.username}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ])),
                  SizedBox(
                    height: 15,
                  ),
                  Text.rich(TextSpan(
                      text: 'Number package delivery: ',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                      children: <InlineSpan>[
                        TextSpan(
                          text: ' ${selected_driver.num_pkg_deliver}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ])),
                  SizedBox(
                    height: 15,
                  ),
                  Text.rich(TextSpan(
                      text: 'Number package receive: ',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                      children: <InlineSpan>[
                        TextSpan(
                          text: ' ${selected_driver.num_pkg_receive}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ])),
                  SizedBox(
                    height: 15,
                  ),
                  Text.rich(TextSpan(
                      text: 'Money of delivery: ',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                      children: <InlineSpan>[
                        TextSpan(
                          text: ' ${selected_driver.total_delivery}₪',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ])),
                  SizedBox(
                    height: 15,
                  ),
                  Text.rich(TextSpan(
                      text: 'Money of purchase: ',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                      children: <InlineSpan>[
                        TextSpan(
                          text: ' ${selected_driver.total_purchase}₪',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ])),
                  SizedBox(
                    height: 15,
                  ),
                  Text.rich(TextSpan(
                      text: 'Total amount: ',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                      children: <InlineSpan>[
                        TextSpan(
                          text:
                              ' ${selected_driver.total_delivery + selected_driver.total_purchase}₪',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ])),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          color: primarycolor,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                            child: Text(
                              "Checkout",
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
                                            post_checkout();
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
                                                color: Colors.red,
                                                fontSize: 18),
                                          )),
                                    ],
                                    title: Text("Chekout"),
                                    content: Container(
                                      width: 400,
                                      child: Text(
                                        "Are you sure you to chekout the driver's ${selected_driver.name} ?",
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
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class driver {
  final String name;
  final String username;
  final String img;
  final int num_pkg_receive;
  final int num_pkg_deliver;
  final int total_delivery;
  final int total_purchase;

  driver({
    required this.num_pkg_receive,
    required this.username,
    required this.num_pkg_deliver,
    required this.total_delivery,
    required this.total_purchase,
    required this.name,
    required this.img,
  });
}
