import 'package:flutter/material.dart';
import 'package:flutter_application_1/employee/main_page_employee.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  var userType = GetStorage().read("userType");
  print(userType);
  runApp(MaterialApp.router(
    theme: ThemeData(
      primaryColor: primarycolor,
    ),
    debugShowCheckedModeBanner: false,
    routerConfig: Router_pages,
  ));
}
