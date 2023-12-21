import 'package:flutter/material.dart';
import 'package:flutter_application_1/employee/main_page_employee.dart';
import 'package:flutter_application_1/style/common/theme_h.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userType = prefs.getString("userType");
  print(userType);
  runApp(MaterialApp.router(
    theme: ThemeData(
      primaryColor: primarycolor,
    ),
    debugShowCheckedModeBanner: false,
    routerConfig: Router_pages,
  ));
}
