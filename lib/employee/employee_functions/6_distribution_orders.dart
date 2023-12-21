import 'package:flutter/material.dart';
import 'package:flutter_application_1/employee/employee_functions/component/4_pdf_report.dart';
import 'package:flutter_application_1/employee/main_page_employee.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';

class distribution_orders extends StatefulWidget {
  final List<drivers> driver_with_packages;

  const distribution_orders({super.key, required this.driver_with_packages});

  @override
  State<distribution_orders> createState() => _distribution_ordersState();
}

class _distribution_ordersState extends State<distribution_orders> {
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
  String? serach_content;

  String? selectedCity;

  void initState() {
    setState(() {
      TabController_.index = 5;
    });
    selectedCity = '';
    serach_content = '';

    super.initState();
  }

  List<drivers> _filterOrders() {
    if (selectedCity!.isEmpty && serach_content!.isEmpty) {
      return widget.driver_with_packages;
    }

    return widget.driver_with_packages.where((order) {
      if (selectedCity!.isNotEmpty && (order.address != selectedCity)) {
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
    List<drivers> filteredOrders = _filterOrders();

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
                      'Serach Oreders',
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
                      items: citylist.map((value) {
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
                            'Print',
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
                  //child: ,
                ),
              ],
            ),
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
                    "City",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
                ],
                rows: filteredOrders
                    .expand((customer) => customer.packages_id.map((packageId) {
                          return DataRow(
                            cells: [
                              DataCell(Text(customer.driver_name)),
                              DataCell(Text(packageId)),
                              DataCell(Text(customer.address)),
                            ],
                          );
                        }))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class drivers {
  List<String> packages_id;
  String driver_name;
  String address;

  drivers({
    required this.packages_id,
    required this.driver_name,
    required this.address,
  });
}
