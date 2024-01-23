import 'package:flutter/material.dart';
import 'package:flutter_application_1/employee/employee_functions/component/3_package_assign.dart';
import 'package:flutter_application_1/employee/main_page_employee.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class assign_order extends StatefulWidget {
  @override
  State<assign_order> createState() => _assign_orderState();
}

class _assign_orderState extends State<assign_order> {
  List<dynamic> assign_orders = [];
  List<package_assign> pk_assign = [];
  List<dynamic> drivers_ = [];
  List<driver_assign_to_order> drivers = [];

  Future fetchData_drivers() async {
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
      print('driver error');
      throw Exception('Failed to load data');
    }
  }

  List<driver_assign_to_order> buildMy_drivers() {
    List<driver_assign_to_order> new_drivers = [];
    for (int i = 0; i < drivers_.length; i++) {
      List<String> daysList = drivers_[i]['working_days']
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .split(', ')
          .map((day) => day.trim())
          .toList();

      new_drivers.add(
        driver_assign_to_order(
          vacation: drivers_[i]['notAvailableDate'].toString(),
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

  Future<void> fetchData_assign_orders() async {
    var url = urlStarter + "/employee/getAssignPackageToDriver";
    // print(url);
    final response = await http
        .get(Uri.parse(url), headers: {'ngrok-skip-browser-warning': 'true'});
    print("response.statusCode " + response.statusCode.toString());
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      assign_orders = data;
      // print(assign_orders);
      setState(() {
        pk_assign = buildMy_assign_orders();
      });
    } else if (response.statusCode == 404) {
      setState(() {
        pk_assign = buildMy_assign_orders();
      });
    } else {
      print('new_orders error');
      throw Exception('Failed to load data');
    }
  }

  List<package_assign> buildMy_assign_orders() {
    List<package_assign> orders = [];

    for (int i = 0; i < assign_orders.length; i++) {
      orders.add(
        package_assign(
          reason: assign_orders[i]['reason'],
          status: assign_orders[i]['status'],
          refreshdata: () {
            fetchData_assign_orders();
          },
          drivers: drivers,
          id: assign_orders[i]['packageId'],
          package_type: assign_orders[i]['packageType'],
          package_size: assign_orders[i]['packageSize'] == 'Document0'
              ? 0
              : assign_orders[i]['packageSize'] == 'Package0'
                  ? 1
                  : assign_orders[i]['packageSize'] == 'Package1'
                      ? 2
                      : 3,
          photo_cus: urlStarter + assign_orders[i]['img'],
          name: assign_orders[i]['name'],
          city: assign_orders[i]['city'],
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
  List packagetypes = ['Delivery', 'Receiving', 'None'];
  List searchtypes = ['Search by Name', 'Search by ID'];

  String? selectedCity;
  String? selectedtype;
  String? searchtype;
  String? serach_content;

  @override
  void initState() {
    //fetchData_assign_orders();
    fetchData_drivers().then((value) => fetchData_assign_orders());

    setState(() {
      TabController_.index = 2;
    });
    selectedCity = '';
    selectedtype = '';
    searchtype = 'Search by Name';
    serach_content = '';
    super.initState();
  }

  List<package_assign> _filterOrders() {
    if (selectedCity!.isEmpty && selectedtype!.isEmpty && searchtype!.isEmpty) {
      return pk_assign;
    }

    return pk_assign.where((order) {
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
    List<package_assign> filteredOrders = _filterOrders();

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
                padding: const EdgeInsets.all(20.0),
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
                padding: const EdgeInsets.all(20.0),
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
