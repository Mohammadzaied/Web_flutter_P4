import 'package:flutter/material.dart';
import 'package:flutter_application_1/employee/employee_functions/component/1_packages.dart';
import 'package:flutter_application_1/employee/employee_functions/component/3_package_assign.dart';
import 'package:flutter_application_1/employee/main_page_employee.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class all_orders extends StatefulWidget {
  @override
  State<all_orders> createState() => _all_ordersState();
}

class _all_ordersState extends State<all_orders> {
  List<dynamic> all_orders = [];
  List<package_edit> pk_all = [];

  Future<void> fetchData_all_orders() async {
    var url = urlStarter + "/employee/getAllPackages";
    print(url);
    final response = await http
        .get(Uri.parse(url), headers: {'ngrok-skip-browser-warning': 'true'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      all_orders = data;
      //print(new_orders);
      setState(() {
        pk_all = buildMy_all_orders();
      });
    } else if (response.statusCode == 404) {
      setState(() {
        pk_all = buildMy_all_orders();
      });
    } else {
      print('new_orders error');
      throw Exception('Failed to load data');
    }
  }

  List<package_edit> buildMy_all_orders() {
    List<package_edit> orders = [];

    for (int i = 0; i < all_orders.length; i++) {
      orders.add(
        package_edit(
          refreshdata: () {
            fetchData_all_orders();
          },
          reason: all_orders[i]['reason'],
          driverUsername: all_orders[i]['driverUsername'],
          driver: all_orders[i]['driverName'],
          id: all_orders[i]['packageId'],
          package_type: all_orders[i]['packageType'],
          photo_cus: urlStarter + all_orders[i]['img'],
          name: all_orders[i]['name'],
          city: all_orders[i]['city'],
          status: all_orders[i]['status'],
          whoWillPay: all_orders[i]['whoWillPay'],
        ),
      );
    }

    return orders;
  }

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

  List<String> status = [
    "Under review",
    "Rejected by employee",
    "Accepted",
    'Assigned to receive', // employee assign package to driver
    "Wait Driver",
    "Rejected by driver",
    "Complete Receive",
    "In Warehouse",
    "Assigned to deliver",
    "With Driver",
    "Delivered",
    "Completed",
    "None",
  ];
  List packagetypes = ['Delivery', 'Receiving', 'None'];
  List searchtypes = ['Search by Name', 'Search by ID'];

  String? selectedCity;
  String? selectedtype;
  String? selectedstatus;
  String? searchtype;
  String? serach_content;

  @override
  void initState() {
    fetchData_all_orders();
    setState(() {
      TabController_.index = 3;
    });
    selectedCity = '';
    selectedtype = '';
    selectedstatus = '';
    searchtype = 'Search by Name';
    serach_content = '';
    super.initState();
  }

  List<package_edit> _filterOrders() {
    if (selectedCity!.isEmpty && selectedtype!.isEmpty && searchtype!.isEmpty) {
      return pk_all;
    }

    return pk_all.where((order) {
      if (selectedstatus!.isNotEmpty && (order.status != selectedstatus)) {
        return false;
      }

      if (selectedtype == '' &&
          selectedCity!.isNotEmpty &&
          order.package_type == 0 &&
          (order.city != selectedCity)) {
        return false;
      }

      if (selectedtype == '' &&
          selectedCity!.isNotEmpty &&
          order.package_type == 1 &&
          (order.city != selectedCity)) {
        return false;
      }

      if (selectedtype == 'Delivery' &&
          selectedCity!.isNotEmpty &&
          order.city != selectedCity) {
        return false;
      }
      if (selectedtype == 'Receiving' &&
          selectedCity!.isNotEmpty &&
          order.city != selectedCity) {
        return false;
      }

      if (selectedtype == 'Delivery' && order.package_type != 0) {
        return false;
      }

      if (selectedtype == 'Receiving' && order.package_type != 1) {
        return false;
      }

      if (searchtype == 'Search by Name' &&
          serach_content!.isNotEmpty &&
          !order.name.toLowerCase().startsWith(serach_content!.toLowerCase())) {
        return false;
      }
      if (searchtype == 'Search by ID' &&
          serach_content!.isNotEmpty &&
          !order.id.toString().startsWith(serach_content!)) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<package_edit> filteredOrders = _filterOrders();

    return ListView(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                width: 300,
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      serach_content = value;
                      //print(value);
                    });
                  },
                  onSaved: (newValue) {},
                  decoration: theme_helper().text_form_style(
                    'Serach Oreders',
                    '',
                    Icons.search,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: 250,
                  child: DropdownButtonFormField(
                    hint:
                        Text('Search by', style: TextStyle(color: Colors.grey)),
                    decoration: theme_helper().text_form_style(
                      '',
                      '',
                      null,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    value: searchtype,
                    onChanged: (newValue) {
                      setState(() {
                        searchtype = newValue as String?;
                      });
                    },
                    items: searchtypes.map((value) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 5, 20),
                child: Container(
                  width: 250,
                  child: DropdownButtonFormField(
                    hint: Text('Filterd by Status',
                        style: TextStyle(color: Colors.grey)),
                    decoration: theme_helper().text_form_style(
                      '',
                      '',
                      null,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    onChanged: (newValue) {
                      setState(() {
                        if (newValue == 'None')
                          selectedstatus = '';
                        else
                          selectedstatus = newValue;
                      });
                    },
                    items: status.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
                child: Container(
                  width: 200,
                  child: DropdownButtonFormField(
                    hint: Text('Filterd by city',
                        style: TextStyle(color: Colors.grey)),
                    decoration: theme_helper().text_form_style(
                      '',
                      '',
                      null,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    onChanged: (newValue) {
                      setState(() {
                        if (newValue == 'None')
                          selectedCity = '';
                        else
                          selectedCity = newValue as String?;
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
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
                child: Container(
                  width: 200,
                  child: DropdownButtonFormField(
                    hint: Text('Filterd by type',
                        style: TextStyle(color: Colors.grey)),
                    decoration: theme_helper().text_form_style(
                      '',
                      '',
                      null,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    onChanged: (newValue) {
                      setState(() {
                        if (newValue == 'None')
                          selectedtype = '';
                        else
                          selectedtype = newValue as String?;
                      });
                    },
                    items: packagetypes.map((value) {
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
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text.rich(TextSpan(
              text: 'Result: ',
              style: TextStyle(fontSize: 20, color: Colors.grey),
              children: <InlineSpan>[
                TextSpan(
                  text: ' ( ${filteredOrders.length} )',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ])),
        ],
      ),
      ...filteredOrders.map((order) {
        return order;
      }).toList(),
    ]);
  }
}
