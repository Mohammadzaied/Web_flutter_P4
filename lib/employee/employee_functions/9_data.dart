// here load data from database
import 'package:flutter_application_1/employee/employee_functions/component/1_packages.dart';

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
