import 'package:flutter/material.dart';
import 'package:flutter_application_1/employee/employee_functions/component/2_package_new.dart';
import 'package:flutter_application_1/employee/main_page_employee.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class new_order extends StatefulWidget {
  @override
  State<new_order> createState() => _new_orderState();
}

class _new_orderState extends State<new_order> {
  List<package_new> pk_new = [];
  List citylist = [
    'Nablus',
    'Tulkarm',
    'Ramallah',
    'Jenin',
    'Qalqilya',
    'Salfit',
    'Hebron',
    'None',
  ];
  //List packagetypes = ['Delivery', 'Receiving', 'None'];
  List searchtypes = ['Search by Name', 'Search by ID'];
  List<dynamic> new_orders = [];
  String? selectedCity;
  // String? selectedtype;
  String? searchtype;
  String? serach_content;

  Future<void> fetchData_new_orders() async {
    var url = urlStarter + "/employee/getNewOrders";
    print(url);
    final response = await http
        .get(Uri.parse(url), headers: {'ngrok-skip-browser-warning': 'true'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      new_orders = data['result'];
      print(new_orders);
      setState(() {
        pk_new = buildMy_new_orders();
      });
    } else {
      print('new_orders error');
      throw Exception('Failed to load data');
    }
  }

  List<package_new> buildMy_new_orders() {
    List<package_new> orders = [];
    print(new_orders);
    for (int i = 0; i < new_orders.length; i++) {
      orders.add(
        package_new(
          id: new_orders[i]['packageId'],
          photo_cus: urlStarter +
              '/image/' +
              new_orders[i]['send_user']['userName'] +
              new_orders[i]['send_user']['url'],

          name: new_orders[i]['send_user']['Fname'] +
              ' ' +
              new_orders[i]['send_user']['Lname'],

          from: 'Nablus', // new_orders[i]['packageId'],
          to: 'Tulkarm', //new_orders[i]['packageId'],

          price: new_orders[i]['packagePrice'],

          package_size: new_orders[i]['shippingType'] == 'Document0'
              ? 0
              : new_orders[i]['shippingType'] == 'Package0'
                  ? 1
                  : new_orders[i]['shippingType'] == 'Package1'
                      ? 2
                      : 3,
        ),
      );
    }
    return orders;
  }

  @override
  void initState() {
    super.initState();
    fetchData_new_orders();
    setState(() {
      TabController_.index = 0;
    });
    selectedCity = '';
    //selectedtype = '';
    searchtype = 'Search by Name';
    serach_content = '';
  }

  List<package_new> _filterOrders() {
    if (selectedCity!.isEmpty && searchtype!.isEmpty) {
      return pk_new;
    }

    return pk_new.where((order) {
      if (selectedCity!.isNotEmpty && (order.to != selectedCity)) {
        return false;
      }

      if (selectedCity!.isNotEmpty && (order.from != selectedCity)) {
        return false;
      }

      if (selectedCity!.isNotEmpty && order.to != selectedCity) {
        return false;
      }
      if (selectedCity!.isNotEmpty && order.from != selectedCity) {
        return false;
      }

      // if (selectedtype == 'Delivery' && order.package_type != 0) {
      //   return false;
      // }

      // if (selectedtype == 'Receiving' && order.package_type != 1) {
      //   return false;
      // }

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
    List<package_new> filteredOrders = _filterOrders();

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
              // Padding(
              //   padding: const EdgeInsets.all(20.0),
              //   child: Container(
              //     width: 200,
              //     child: DropdownButtonFormField(
              //       hint: Text('Filterd by type',
              //           style: TextStyle(color: Colors.grey)),
              //       decoration: theme_helper().text_form_style(
              //         '',
              //         '',
              //         null,
              //       ),
              //       borderRadius: BorderRadius.circular(10),
              //       onChanged: (newValue) {
              //         setState(() {
              //           if (newValue == 'None')
              //             selectedtype = '';
              //           else
              //             selectedtype = newValue as String?;
              //         });
              //       },
              //       items: packagetypes.map((value) {
              //         return DropdownMenuItem(
              //           value: value,
              //           child: Text(value),
              //         );
              //       }).toList(),
              //     ),
              //   ),
              // ),
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
          //  Text('${filteredOrders.length}'),
        ],
      ),
      ...filteredOrders.map((order) {
        return order;
      }).toList(),
    ]);
  }
}
