// here load data from database
import 'package:flutter_application_1/employee/employee_functions/component/3_package_assign.dart';
import 'package:flutter_application_1/employee/employee_functions/component/2_package_new.dart';
import 'package:flutter_application_1/employee/employee_functions/component/1_packages.dart';
import 'package:flutter_application_1/employee/employee_functions/6_distribution_orders.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:get_storage/get_storage.dart';

List<dynamic> new_orders = [];

//String? userName;

//String customerUserName = GetStorage().read('userName');
//String customerPassword = GetStorage().read('password');

Future<void> fetchData_new_orders() async {
  var url = urlStarter + "/employee/getNewOrders";
  print(url);
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    new_orders = data['result'];
    print(new_orders);
  } else {
    print('new_orders error');
    throw Exception('Failed to load data');
  }
}

List<package_new> buildMy_new_orders() {
  fetchData_new_orders();
  List<package_new> orders = [];

  for (int i = 0; i < new_orders.length; i++) {
    orders.add(
      package_new(
        id: new_orders[i]['packageId'],
        photo_cus: urlStarter +
            '/' +
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

  // orders.add(
  //   package_new(
  //     id: 88484888488848,
  //     package_type: 0,
  //     photo_cus: "assets/f3.png",
  //     name: 'ahmad',
  //     from: 'Salfit',
  //     to: 'Tulkarm',
  //     price: 200,
  //     package_size: 3,
  //   ),
  // );
  // // }
  // orders.add(
  //   package_new(
  //     id: 2000,
  //     package_type: 0,
  //     photo_cus: "assets/f3.png",
  //     name: 'othman',
  //     from: 'Nablus',
  //     to: 'Qalqilya',
  //     price: 400,
  //     package_size: 3,
  //   ),
  // );
  // orders.add(
  //   package_new(
  //     id: 1,
  //     package_type: 0,
  //     photo_cus: "assets/f3.png",
  //     name: 'zaid',
  //     from: 'Ramallah',
  //     to: 'Tulkarm',
  //     price: 134,
  //     package_size: 2,
  //   ),
  // );
  // // }
  // // }

  return orders;
}

List<package_assign> buildMy_assign_orders() {
  List<package_assign> orders = [];

  //for (int i = 1; i <= 20; i++) {
  orders.add(
    package_assign(
      id: 00000000000,
      package_type: 1,
      photo_cus: "assets/f3.png",
      name: 'majed',
      from: 'Ramallah',
      to: 'Nablus',
      package_size: 2,
    ),
  );
  orders.add(
    package_assign(
      id: 1234586886,
      package_type: 1,
      photo_cus: "assets/f3.png",
      name: 'Mohammad aaaaaaaaa',
      from: 'Ramallah',
      to: 'Hebron',
      package_size: 3,
    ),
  );
  orders.add(
    package_assign(
      id: 88484888488848,
      package_type: 0,
      photo_cus: "assets/f3.png",
      name: 'ahmad',
      from: 'Hebron',
      to: 'Tulkarm',
      package_size: 3,
    ),
  );
  // }
  orders.add(
    package_assign(
      id: 2000,
      package_type: 0,
      photo_cus: "assets/f3.png",
      name: 'othman',
      from: 'Nablus',
      to: 'Hebron',
      package_size: 3,
    ),
  );
  orders.add(
    package_assign(
      id: 1,
      package_type: 0,
      photo_cus: "assets/f3.png",
      name: 'zaid',
      from: 'Ramallah',
      to: 'Jenin',
      package_size: 2,
    ),
  );
  // }
  // }

  return orders;
}

List<drivers> buildMy_drivers() {
  List<drivers> deiver = [];

  deiver.add(
    drivers(
      packages_id: ["7531045269", "111111111"],
      driver_name: "Lacy R. Caldwell",
      address: "Tulkarm",
    ),
  );
  deiver.add(
    drivers(
      packages_id: ["7359627951"],
      driver_name: "Shirley R. Simmons",
      address: "Nablus",
    ),
  );
  deiver.add(
    drivers(
      packages_id: ["6831318839"],
      driver_name: "Todd M. Akers",
      address: "Nablus",
    ),
  );
  deiver.add(
    drivers(
      packages_id: ["123455"],
      driver_name: "Mohammad",
      address: "Tulkarm",
    ),
  );

  return deiver;
}

List<package_edit> buildMy_package_edit() {
  List<package_edit> orders = [];

  orders.add(
    package_edit(
      driver: 'mohammad zaied',
      status: 'reject',
      id: 00000000000,
      package_type: 1,
      photo_cus: "assets/f3.png",
      name: 'majed',
      from: 'Ramallah',
      to: 'Nablus',
    ),
  );
  orders.add(
    package_edit(
      driver: 'rami',
      status: 'on way',
      id: 1234586886,
      package_type: 1,
      photo_cus: "assets/f3.png",
      name: 'Mohammad aaaaaaaaa',
      from: 'Ramallah',
      to: 'Hebron',
    ),
  );
  orders.add(
    package_edit(
      driver: '',
      status: 'accept',
      id: 88484888488848,
      package_type: 0,
      photo_cus: "assets/f3.png",
      name: 'ahmad',
      from: 'Hebron',
      to: 'Tulkarm',
    ),
  );
  // }
  orders.add(
    package_edit(
      driver: 'ahmad',
      status: 'assign to driver',
      id: 2000,
      package_type: 0,
      photo_cus: "assets/f3.png",
      name: 'othman',
      from: 'Nablus',
      to: 'Hebron',
    ),
  );
  orders.add(
    package_edit(
      driver: '',
      status: 'reject',
      id: 1,
      package_type: 0,
      photo_cus: "assets/f3.png",
      name: 'zaid',
      from: 'Ramallah',
      to: 'Jenin',
    ),
  );

  return orders;
}
