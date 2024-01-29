import 'package:flutter/material.dart';
import 'package:flutter_application_1/employee/employee_functions/component/4_pdf_report.dart';
import 'package:flutter_application_1/employee/main_page_employee.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class distribution_orders extends StatefulWidget {
  @override
  State<distribution_orders> createState() => _distribution_ordersState();
}

class _distribution_ordersState extends State<distribution_orders> {
  List<packages> all_p = [];
  List<dynamic> new_p = [];

  Future<void> fetchData_packeges() async {
    var url = urlStarter + "/employee/getDistributionOrders";
    print(url);
    final response = await http
        .get(Uri.parse(url), headers: {'ngrok-skip-browser-warning': 'true'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      new_p = data['result'];
      print(new_p);
      setState(() {
        all_p = buildMy_p();
      });
    } else {
      print('new_orders error');
      throw Exception('Failed to load data');
    }
  }

  List<packages> buildMy_p() {
    List<packages> p = [];

    for (int i = 0; i < new_p.length; i++) {
      p.add(
        packages(
          driver_name: new_p[i]['driverName'],
          address: new_p[i]['address'],
          package_type: new_p[i]['packageType'],
          customer_name: new_p[i]['customerName'],
          customer_phone: new_p[i]['phoneNumber'].toString(),
          package_id: new_p[i]['packageId'].toString(),
        ),
      );
    }
    return p;
  }

  List cities = [];
  String? serach_content;

  String? selectedCity;

  void initState() {
    fetch_cities().then((List result) {
      setState(() {
        cities = result;
        cities.add('None');
      });
    });
    setState(() {
      TabController_.index = 5;
    });
    selectedCity = '';
    serach_content = '';
    fetchData_packeges();
    super.initState();
  }

  List<packages> _filterOrders() {
    if (selectedCity!.isEmpty && serach_content!.isEmpty) {
      return all_p;
    }

    return all_p.where((order) {
      if (selectedCity!.isNotEmpty &&
          (order.address.toLowerCase() != selectedCity!.toLowerCase())) {
        return false;
      }
      if (serach_content!.isNotEmpty &&
          !order.driver_name
              .toLowerCase()
              .startsWith(serach_content!.toLowerCase())) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<packages> filteredOrders = _filterOrders();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20),
                  width: 300,
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        serach_content = value;
                      });
                    },
                    onSaved: (newValue) {},
                    decoration: theme_helper().text_form_style(
                      'Serach by name driver',
                      '',
                      Icons.search,
                    ),
                  ),
                ),
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
                      items: cities.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Spacer(),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: primarycolor,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.print,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Print Result',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20),
                          ),
                        ],
                      )),
                  onPressed: () {
                    PdfService().printCustomersPdf(filteredOrders);
                  },
                ),
              ],
            ),
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: DataTable(
                columns: const [
                  DataColumn(
                      label: Text(
                    "Driver Name",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
                  DataColumn(
                      label: Text(
                    "Package ID",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
                  DataColumn(
                      label: Text(
                    "Customer name",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
                  DataColumn(
                      label: Text(
                    "Customer phone",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
                  DataColumn(
                      label: Text(
                    "Type",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
                  DataColumn(
                      label: Text(
                    "Address",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
                ],
                rows: filteredOrders.map((data) {
                  return DataRow(
                    cells: [
                      DataCell(Text(data.driver_name)),
                      DataCell(Text(data.package_id)),
                      DataCell(Text(data.customer_name)),
                      DataCell(Text(data.customer_phone)),
                      DataCell(Text(data.package_type)),
                      DataCell(Text(data.address)),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class packages {
  String package_id;
  String package_type;
  String driver_name;
  String customer_name;
  String customer_phone;
  String address; // from or to

  packages({
    required this.driver_name,
    required this.package_id,
    required this.package_type,
    required this.customer_phone,
    required this.customer_name,
    required this.address,
  });
}
