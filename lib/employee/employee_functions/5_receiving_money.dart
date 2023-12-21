import 'package:flutter/material.dart';
import 'package:flutter_application_1/employee/main_page_employee.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class receiving_money extends StatefulWidget {
  @override
  State<receiving_money> createState() => _receiving_moneyState();
}

class _receiving_moneyState extends State<receiving_money> {
  late List<driver> persons;
  late driver selected_driver;
  TextEditingController controller = new TextEditingController();

  void loadData() async {
    persons = [
      driver(
        name: 'mohammad',
        img: "assets/f3.png",
        num_pkg_deliver: 10,
        num_pkg_receive: 12,
        total_delivery: 1500,
        total_purchase: 300,
      ),
      driver(
        name: 'rami',
        img: "assets/add-friend.png",
        num_pkg_deliver: 11,
        num_pkg_receive: 2,
        total_delivery: 3300,
        total_purchase: 200,
      ),
      driver(
        name: 'zain',
        img: "assets/driver.png",
        num_pkg_deliver: 1,
        num_pkg_receive: 1,
        total_delivery: 100,
        total_purchase: 100,
      ),
      driver(
        name: 'ahmad',
        img: "",
        num_pkg_deliver: 30,
        num_pkg_receive: 15,
        total_delivery: 4000,
        total_purchase: 200,
      ),
    ];

    for (int i = 0; i < 10; i++) {
      persons.add(driver(
        name: 'rida',
        img: "assets/driver.png",
        num_pkg_deliver: 40,
        num_pkg_receive: 15,
        total_delivery: 5000,
        total_purchase: 700,
      ));
    }
  }

  @override
  void initState() {
    setState(() {
      TabController_.index = 4;
    });
    loadData();
    selected_driver = persons[0];
    controller.text = selected_driver.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
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
                          return persons
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
                                  : AssetImage("${suggestion.img}"),
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
                          shape: BoxShape.circle,
                          //borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(selected_driver.img))),
                    ),
                  ),
                  SizedBox(
                    height: 20,
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
                    height: 20,
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
                    height: 20,
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
                    height: 20,
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
                    height: 20,
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
                    height: 20,
                  ),
                  Text.rich(TextSpan(
                      text: 'Total balance: ',
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
                    height: 20,
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
                          onPressed: () {},
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
  final String img;
  final int num_pkg_receive;
  final int num_pkg_deliver;
  final int total_delivery;
  final int total_purchase;

  driver({
    required this.num_pkg_receive,
    required this.num_pkg_deliver,
    required this.total_delivery,
    required this.total_purchase,
    required this.name,
    required this.img,
  });
}
